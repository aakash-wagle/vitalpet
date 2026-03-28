import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';

part 'check_in_session_state.freezed.dart';

/// Union representing every phase of the check-in session lifecycle.
@freezed
sealed class CheckInSessionState with _$CheckInSessionState {
  const factory CheckInSessionState.idle() = _Idle;

  const factory CheckInSessionState.collecting({
    required int wellnessScore,
    required List<QuestionAnswer> answers,
    required List<String> pendingDomains,
  }) = _Collecting;

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
