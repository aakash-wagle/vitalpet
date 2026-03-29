import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vitalpet/core/constants/symptom_domains.dart';
import 'package:vitalpet/core/database/dao_providers.dart';
import 'package:vitalpet/core/database/database_provider.dart';
import 'package:vitalpet/features/check_in/domain/check_in_engine.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_state.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/check_in/domain/symptom_text_to_json_action.dart';
import 'package:vitalpet/features/health/health_adapter.dart';
import 'package:vitalpet/features/pet/domain/widget_data_writer.dart';
import 'package:vitalpet/features/slm/slm_providers.dart';

part 'check_in_session_notifier.g.dart';

@riverpod
class CheckInSessionNotifier extends _$CheckInSessionNotifier {
  late CheckInEngine _engine;
  late SymptomTextToJsonAction _symptomTextAction;

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
    _symptomTextAction = SymptomTextToJsonAction(
      slmClient: ref.read(slmClientProvider),
    );
    return const CheckInSessionState.idle();
  }

  /// Opens a new check-in session (or resumes a partial one).
  Future<void> startSession() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _engine.startSession());
  }

  /// Submits the overall status ("great" or "not_great").
  Future<void> submitOverallStatus(String status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _engine.submitOverallStatus(status));
  }

  /// User selected symptom categories — begin collecting details.
  void selectSymptomCategories(List<SymptomCategory> categories) {
    final current = state.value;
    if (current == null) return;
    final overallStatus =
        current.whenOrNull(selectingSymptoms: (os) => os) ?? 'not_great';
    state = AsyncData(_engine.beginSymptomDetails(overallStatus, categories));
  }

  /// Parses free-form symptom text into structured symptom objects.
  /// Falls back to category keyword detection if model extraction fails.
  Future<void> submitUnstructuredSymptoms(String text) async {
    final current = state.value;
    if (current == null) return;

    final overallStatus = current.whenOrNull(selectingSymptoms: (os) => os);
    if (overallStatus == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final jsonObject = await _symptomTextAction.extractSymptomsJsonObject(
          text,
        );
        final decoded = jsonDecode(jsonObject);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException(
            'Structured symptom output was not a JSON object',
          );
        }

        final symptoms = SymptomTextToJsonAction.decodeSymptomsFromJsonObject(
          jsonObject,
        );
        if (symptoms.isEmpty) {
          throw const FormatException('No symptoms extracted');
        }

        return _engine.beginFromStructuredSymptoms(overallStatus, symptoms);
      } catch (_) {
        final fallback = _fallbackCategoriesFromText(text);
        return _engine.beginSymptomDetails(overallStatus, fallback);
      }
    });
  }

  /// Submit a symptom detail answer.
  Future<void> submitSymptomDetail(String key, dynamic value) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _engine.submitSymptomDetail(current, key, value),
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

  /// Atomically writes the completed check-in and transitions to completed.
  Future<void> completeSession() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _engine.completeSession(current);
      await updateWidgetData(result.updatedPet, [
        result.overallStatus == 'great' ? 8 : 3,
      ]);
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

  List<SymptomCategory> _fallbackCategoriesFromText(String text) {
    final lower = text.toLowerCase();
    final detected = <SymptomCategory>{};

    if (lower.contains('fever') ||
        lower.contains('temperature') ||
        lower.contains('hot')) {
      detected.add(SymptomCategory.fever);
    }
    if (lower.contains('pain') ||
        lower.contains('hurt') ||
        lower.contains('ache') ||
        lower.contains('sore')) {
      detected.add(SymptomCategory.pain);
    }
    if (lower.contains('tired') ||
        lower.contains('fatigue') ||
        lower.contains('exhausted') ||
        lower.contains('energy')) {
      detected.add(SymptomCategory.fatigue);
    }
    if (lower.contains('nausea') ||
        lower.contains('vomit') ||
        lower.contains('sick') ||
        lower.contains('throw up')) {
      detected.add(SymptomCategory.nausea);
    }

    if (detected.isEmpty) {
      detected.add(SymptomCategory.other);
    }

    return detected.toList();
  }
}
