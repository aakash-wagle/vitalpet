import 'package:health/health.dart';

/// A snapshot of de-identified health data for the check-in context.
/// Raw values are never persisted — only derived summaries go into the DB.
class HealthSnapshot {
  const HealthSnapshot({
    this.sleepVsBaselineSummary,
    this.stepsVsBaselineSummary,
    this.hrVsBaselineSummary,
  });

  final String? sleepVsBaselineSummary;
  final String? stepsVsBaselineSummary;
  final String? hrVsBaselineSummary;
}

/// Wraps the health package. Read-only — never requests write permissions.
///
/// Requested types: STEPS, SLEEP_ASLEEP, RESTING_HEART_RATE.
/// Raw values are discarded after building the snapshot; only derived strings
/// (e.g. "sleep_vs_baseline: -2.1h") are returned for storage.
class HealthAdapter {
  const HealthAdapter();

  static const _types = [
    HealthDataType.STEPS,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.RESTING_HEART_RATE,
  ];

  // All requested as READ only — write types are never requested (NFR-SEC-03).
  static const _permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  /// Fetches a [HealthSnapshot] for the window [start]..[end].
  ///
  /// Returns null if permissions are denied — callers continue normally with
  /// health UI hidden. Raw values are discarded after building the snapshot.
  Future<HealthSnapshot?> fetchSummary({
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      final health = Health();

      final granted = await health.requestAuthorization(
        _types,
        permissions: _permissions,
      );
      if (!granted) return null;

      final data = await health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: _types,
      );

      // De-duplicate (health package may return multiple data points per type).
      final deduped = health.removeDuplicates(data);

      // --- Steps ---
      final stepPoints = deduped
          .where((p) => p.type == HealthDataType.STEPS)
          .toList();
      final totalSteps = stepPoints.fold<double>(
        0,
        (sum, p) => sum + _numericValue(p.value),
      );

      // --- Sleep (hours asleep) ---
      final sleepPoints = deduped
          .where((p) => p.type == HealthDataType.SLEEP_ASLEEP)
          .toList();
      final totalSleepMinutes = sleepPoints.fold<double>(
        0,
        (sum, p) =>
            sum + p.dateTo.difference(p.dateFrom).inMinutes.toDouble(),
      );
      final sleepHours = totalSleepMinutes / 60.0;

      // --- Resting heart rate (latest reading) ---
      final hrPoints = deduped
          .where((p) => p.type == HealthDataType.RESTING_HEART_RATE)
          .toList()
        ..sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
      final latestHr =
          hrPoints.isEmpty ? null : _numericValue(hrPoints.first.value);

      // Build derived strings — raw numeric values are not returned.
      return HealthSnapshot(
        stepsVsBaselineSummary:
            stepPoints.isEmpty ? null : 'steps: ${totalSteps.round()}',
        sleepVsBaselineSummary:
            sleepPoints.isEmpty ? null : 'sleep_h: ${sleepHours.toStringAsFixed(1)}',
        hrVsBaselineSummary:
            latestHr == null ? null : 'rhr_bpm: ${latestHr.round()}',
      );
    } catch (_) {
      // If permissions are revoked or HealthKit is unavailable, return null
      // so the rest of the check-in flow continues unaffected.
      return null;
    }
  }

  double _numericValue(HealthValue value) {
    if (value is NumericHealthValue) return value.numericValue.toDouble();
    return 0;
  }
}
