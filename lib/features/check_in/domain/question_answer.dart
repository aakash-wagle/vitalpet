import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_answer.freezed.dart';
part 'question_answer.g.dart';

@freezed
abstract class QuestionAnswer with _$QuestionAnswer {
  const factory QuestionAnswer({
    required String domain,
    required String questionType,
    required dynamic value,
  }) = _QuestionAnswer;

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuestionAnswerFromJson(json);
}
