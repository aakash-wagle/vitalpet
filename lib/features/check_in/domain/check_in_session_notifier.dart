import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vitalpet/core/database/dao_providers.dart';
import 'package:vitalpet/core/database/database_provider.dart';
import 'package:vitalpet/features/check_in/domain/check_in_engine.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_state.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/health/health_adapter.dart';
import 'package:vitalpet/features/pet/domain/widget_data_writer.dart';
import 'package:vitalpet/features/slm/slm_providers.dart';

part 'check_in_session_notifier.g.dart';

@riverpod
class CheckInSessionNotifier extends _$CheckInSessionNotifier {
  late CheckInEngine _engine;

  @override
  Future<CheckInSessionState> build() async {
    _engine = CheckInEngine(
      checkInDao: ref.read(checkInDaoProvider),
      petDao: ref.read(petDaoProvider),
      auditLogDao: ref.read(auditLogDaoProvider),
      db: ref.read(databaseProvider),
      healthAdapter: const HealthAdapter(),
      questionSequencer: ref.read(questionSequencerProvider),
    );
    return const CheckInSessionState.idle();
  }

  /// Opens a new check-in session: loads health snapshot, shows slider.
  Future<void> startSession() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _engine.startSession());
  }

  /// Submits the wellness score and fetches SLM questions for Mode 2/3.
  Future<void> submitWellnessScore(int score) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _engine.submitWellnessScore(score),
    );
  }

  /// Appends an answer and advances the question index.
  Future<void> submitAnswer(QuestionAnswer answer) async {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(_engine.submitAnswer(current, answer));
  }

  /// Persists the in-progress session as partial (isPartial=true).
  Future<void> savePartial() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _engine.savePartial(current));
  }

  /// Resumes a previously-partial session (called from HomeScreen).
  Future<void> resumePartial() async {
    // TODO: load partial check-in from DB, reconstruct SLM question list,
    //       call _engine.resumePartial(...)
  }

  /// Atomically writes the completed check-in and transitions to completed.
  Future<void> completeSession() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _engine.completeSession(current);
      // Widget update is a Flutter side-effect — done here, not in the engine.
      await updateWidgetData(
        result.updatedPet,
        [result.wellnessScore],
      );
      return result.state;
    });
  }

  /// Amends a same-day check-in by [checkInId].
  Future<void> amendSession(
    String checkInId,
    List<QuestionAnswer> updatedAnswers,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _engine.amendSession(checkInId, updatedAnswers);
      return const CheckInSessionState.idle();
    });
  }

  /// Resets to idle after the completion animation has finished.
  void reset() {
    state = const AsyncData(CheckInSessionState.idle());
  }
}
