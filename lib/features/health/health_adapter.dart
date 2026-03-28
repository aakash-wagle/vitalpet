import 'package:flutter/material.dart' show DateTimeRange;

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
class HealthAdapter {
  const HealthAdapter();

  /// Fetches a [HealthSnapshot] for [dateRange].
  /// Returns null if permissions are denied — callers continue normally.
  /// Raw values are discarded after building the snapshot.
  Future<HealthSnapshot?> fetchSummary(DateTimeRange dateRange) async {
    // TODO: implement HealthKit read via Health.instance + baseline comparison.
    // Request read permissions only — never write types.
    // Do NOT persist raw values in the DB.
    return null;
  }
}
