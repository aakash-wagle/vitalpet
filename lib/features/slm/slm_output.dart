import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vitalpet/core/constants/symptom_domains.dart';

part 'slm_output.freezed.dart';
part 'slm_output.g.dart';

enum QuestionType { binary, slider, bodyMap, text }

@freezed
abstract class SLMQuestion with _$SLMQuestion {
  const factory SLMQuestion({
    required SymptomCategory category,
    required QuestionType type,
    required String prompt,
    /// Identifies the specific symptom field being captured, e.g. 'temperature', 'regions', 'scope'.
    /// Null for high-level category-level questions (e.g. cold-start fallback).
    String? fieldName,
    Map<String, String>? options,
  }) = _SLMQuestion;

  factory SLMQuestion.fromJson(Map<String, dynamic> json) =>
      _$SLMQuestionFromJson(json);
}

@freezed
abstract class SLMOutput with _$SLMOutput {
  const factory SLMOutput({
    required List<SLMQuestion> questions,
    @Default(false) bool usedFallback,
    String? rawResponse,
  }) = _SLMOutput;

  factory SLMOutput.fromJson(Map<String, dynamic> json) =>
      _$SLMOutputFromJson(json);
}
