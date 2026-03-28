import 'package:freezed_annotation/freezed_annotation.dart';

part 'slm_context.freezed.dart';
part 'slm_context.g.dart';

/// Context passed to the SLM for question sequencing.
/// Contains only de-identified, derived data — never raw health values.
@freezed
abstract class SLMContext with _$SLMContext {
  const factory SLMContext({
    required int wellnessScore,
    required List<String> activeDomains,
    required Map<String, double> baselines,
    @Default([]) List<String> recentAnswerSummaries,
    String? conditionFocus,
    String? healthContextSummary,
  }) = _SLMContext;

  factory SLMContext.fromJson(Map<String, dynamic> json) =>
      _$SLMContextFromJson(json);
}
