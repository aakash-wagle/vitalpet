import 'package:freezed_annotation/freezed_annotation.dart';

part 'narrative_context.freezed.dart';
part 'narrative_context.g.dart';

/// De-identified context for the SLM narrative generation call.
/// Must never contain raw health values or PII.
@freezed
abstract class NarrativeContext with _$NarrativeContext {
  const factory NarrativeContext({
    required int dayCount,
    required double averageWellnessScore,
    required List<String> dominantSymptomDomains,
    required List<String> deviationAlertSummaries,
    String? conditionFocus,
    String? healthCorrelationSummary,
  }) = _NarrativeContext;

  factory NarrativeContext.fromJson(Map<String, dynamic> json) =>
      _$NarrativeContextFromJson(json);
}
