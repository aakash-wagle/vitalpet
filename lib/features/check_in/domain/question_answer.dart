import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vitalpet/core/constants/symptom_domains.dart';

part 'question_answer.freezed.dart';
part 'question_answer.g.dart';

@freezed
abstract class QuestionAnswer with _$QuestionAnswer {
  const factory QuestionAnswer({
    required SymptomCategory category,
    required String fieldName,
    required dynamic value,
  }) = _QuestionAnswer;

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuestionAnswerFromJson(json);
}
