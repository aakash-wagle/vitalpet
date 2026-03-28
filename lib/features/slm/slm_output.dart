import 'package:freezed_annotation/freezed_annotation.dart';

part 'slm_output.freezed.dart';
part 'slm_output.g.dart';

enum QuestionType { binary, slider, bodyMap, text }

@freezed
abstract class SLMQuestion with _$SLMQuestion {
  const factory SLMQuestion({
    required String domain,
    required QuestionType type,
    required String prompt,
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
