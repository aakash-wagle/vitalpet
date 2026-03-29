import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/pet/domain/milestone_detector.dart';
import 'package:vitalpet/features/slm/slm_output.dart';

part 'check_in_session_state.freezed.dart';

/// Union representing every phase of the check-in session lifecycle.
@freezed
sealed class CheckInSessionState with _$CheckInSessionState {
  /// No active session. The check-in screen has not been opened.
  const factory CheckInSessionState.idle() = _Idle;

  /// Health snapshot loaded; WellnessSlider is visible.
  const factory CheckInSessionState.collectingScore() = _CollectingScore;

  /// Mode 2 or Mode 3: follow-up questions are being answered.
  const factory CheckInSessionState.collectingAnswers({
    required int wellnessScore,
    required CheckInMode mode,
    required List<SLMQuestion> questions,
    required int currentIndex,
    required List<QuestionAnswer> answers,
  }) = _CollectingAnswers;

  /// User tapped "Save and come back" — partial session persisted to DB.
  const factory CheckInSessionState.partial({
    required int wellnessScore,
    required List<QuestionAnswer> answers,
    required DateTime savedAt,
  }) = _Partial;

  /// Atomic DB write in progress.
  const factory CheckInSessionState.completing() = _Completing;

  /// Write complete; pet reaction animation and optional confetti ready.
  const factory CheckInSessionState.completed({
    required bool hadMilestone,
    MilestoneType? milestone,
  }) = _Completed;
}
