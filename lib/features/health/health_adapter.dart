/// A snapshot of de-identified health data for the check-in context.
/// Raw values are never persisted.
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

/// Health integration is intentionally disabled.
///
/// This adapter never requests OS health permissions and always returns null so
/// check-in/report flows continue without platform health data.
class HealthAdapter {
  const HealthAdapter();

  Future<HealthSnapshot?> fetchSummary({
    required DateTime start,
    required DateTime end,
  }) async {
    return null;
  }
}
