import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vitalpet/core/constants/symptom_domains.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/slm/slm_output.dart';

part 'check_in_session_state.freezed.dart';

/// Union representing every phase of the check-in session lifecycle.
@freezed
sealed class CheckInSessionState with _$CheckInSessionState {
  const factory CheckInSessionState.idle() = _Idle;

  /// Wellness slider is visible; waiting for the user's score submission.
  const factory CheckInSessionState.collectingScore() = _CollectingScore;

  const factory CheckInSessionState.collectingAnswers({
    required CheckInMode mode,
    required List<SLMQuestion> questions,
    required List<QuestionAnswer> answers,
    required SymptomCategory? currentCategory,
  }) = _CollectingAnswers;

  const factory CheckInSessionState.partial({
    required int wellnessScore,
    required List<QuestionAnswer> answers,
    required DateTime savedAt,
  }) = _Partial;

  const factory CheckInSessionState.completing({
    required int wellnessScore,
    required List<QuestionAnswer> answers,
  }) = _Completing;
}
