import 'package:freezed_annotation/freezed_annotation.dart';

part 'narrative_context.freezed.dart';
part 'narrative_context.g.dart';

/// De-identified context for the SLM (or rule-based) narrative generation call.
/// Must never contain raw health values, patient names, device IDs, or PII.
@freezed
abstract class NarrativeContext with _$NarrativeContext {
  const factory NarrativeContext({
    required int dayCount,
    required double averageWellnessScore,
    required List<String> dominantSymptomDomains,
    required List<String> deviationAlertSummaries,
    // Extended fields for richer narrative — all optional for back-compat
    String? conditionFocus,
    String? healthCorrelationSummary,
    /// 'improving' | 'stable' | 'declining'
    String? trendDirection,
    /// symptom category → number of sessions it appeared in
    Map<String, int>? symptomFrequency,
    /// Body regions most frequently selected on the pain body-map
    List<String>? mostFrequentPainRegions,
    /// Count of sessions where fatigue blocked daily activity
    int? fatigueBlockedDailyCount,
    /// Total possible check-in days in the date range
    int? totalCheckins,
    /// Completed (non-partial) check-ins in the range
    int? completedCheckins,
  }) = _NarrativeContext;

  factory NarrativeContext.fromJson(Map<String, dynamic> json) =>
      _$NarrativeContextFromJson(json);
}
