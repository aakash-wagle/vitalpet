import 'package:freezed_annotation/freezed_annotation.dart';

part 'slm_context.freezed.dart';
part 'slm_context.g.dart';

/// Context passed to the SLM for question sequencing.
/// Contains only de-identified, derived data — never raw health values.
@freezed
abstract class SLMContext with _$SLMContext {
  const factory SLMContext({
    /// "great" or "not_great" — matches DATA_TO_COLLECT.md
    required String overallStatus,
    required List<String> activeDomains,
    required Map<String, double> baselines,
    @Default([]) List<String> recentAnswerSummaries,
    String? conditionFocus,
    String? healthContextSummary,
    // Keep wellnessScore for backward compat with SLM prompt
    @Default(5) int wellnessScore,
  }) = _SLMContext;

  factory SLMContext.fromJson(Map<String, dynamic> json) =>
      _$SLMContextFromJson(json);
}
