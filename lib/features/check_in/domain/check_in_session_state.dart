import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vitalpet/core/constants/symptom_domains.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/check_in/domain/symptom_data.dart';
import 'package:vitalpet/features/pet/domain/milestone_detector.dart';
import 'package:vitalpet/features/slm/slm_output.dart';

part 'check_in_session_state.freezed.dart';

/// Union representing every phase of the check-in session lifecycle.
@freezed
sealed class CheckInSessionState with _$CheckInSessionState {
  /// No active session. The check-in screen has not been opened.
  const factory CheckInSessionState.idle() = _Idle;

  /// Health snapshot loaded; overall status selection is visible.
  const factory CheckInSessionState.collectingScore() = _CollectingScore;

  /// User said "not_great" — picking which symptom categories apply.
  const factory CheckInSessionState.selectingSymptoms({
    required String overallStatus,
  }) = _SelectingSymptoms;

  /// Collecting details for each selected symptom category.
  const factory CheckInSessionState.collectingSymptomDetails({
    required String overallStatus,
    required List<SymptomCategory> selectedCategories,
    required int currentCategoryIndex,
    required List<SymptomEntry> collectedSymptoms,
    /// Current step within the category's detail questions
    required int categoryStep,
    /// Accumulated partial data for current category
    required Map<String, dynamic> currentCategoryData,
  }) = _CollectingSymptomDetails;

  /// Mode 2 or Mode 3: follow-up questions are being answered.
  const factory CheckInSessionState.collectingAnswers({
    required String overallStatus,
    required CheckInMode mode,
    required List<SLMQuestion> questions,
    required int currentIndex,
    required List<QuestionAnswer> answers,
    @Default([]) List<SymptomEntry> symptoms,
  }) = _CollectingAnswers;

  /// User tapped "Save and come back" — partial session persisted to DB.
  const factory CheckInSessionState.partial({
    required String overallStatus,
    required List<QuestionAnswer> answers,
    required List<SymptomEntry> symptoms,
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
