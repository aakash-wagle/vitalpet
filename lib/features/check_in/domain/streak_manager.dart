import 'package:vitalpet/features/check_in/domain/mode_selector.dart';

/// Manages check-in streak validity and freeze tokens.
/// All date comparisons are UTC-keyed.
class StreakManager {
  const StreakManager();

  /// Returns true if this check-in counts toward the streak.
  ///
  /// Rules:
  ///   - Mode is [CheckInMode.quick] (wellnessScore ≥ 7): slider tap alone is sufficient.
  ///   - Mode is [CheckInMode.guided] or [CheckInMode.companion]: at least 1 symptom
  ///     must have been collected (symptomsCollected ≥ 1).
  bool isValidCheckin({
    required int wellnessScore,
    required int symptomsCollected,
  }) {
    final mode = selectMode(wellnessScore);
    if (mode == CheckInMode.quick) return true;
    return symptomsCollected >= 1;
  }

  /// Returns true if the streak is still alive given the last check-in date
  /// and any active freeze.
  bool isStreakValid({
    required DateTime lastCheckIn,
    required DateTime now,
    required bool freezeActive,
  }) {
    final lastUtcDay = DateTime.utc(
      lastCheckIn.toUtc().year,
      lastCheckIn.toUtc().month,
      lastCheckIn.toUtc().day,
    );
    final nowUtcDay = DateTime.utc(
      now.toUtc().year,
      now.toUtc().month,
      now.toUtc().day,
    );
    final missedDays = nowUtcDay.difference(lastUtcDay).inDays - 1;
    if (missedDays <= 0) return true;
    if (freezeActive && missedDays == 1) return true;
    return false;
  }

  /// Activates a streak freeze token for today.
  /// [reason] is stored in the freeze record for handoff context.
  /// Returns the UTC date string of activation.
  String activateFreeze(String reason) {
    return DateTime.now().toUtc().toIso8601String().substring(0, 10);
  }

  /// Returns the UTC date string for today (YYYY-MM-DD).
  static String utcToday() =>
      DateTime.now().toUtc().toIso8601String().substring(0, 10);
}
