import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:vitalpet/core/audit/audit_log_dao.dart';
import 'package:vitalpet/core/database/app_database.dart';
import 'package:vitalpet/features/check_in/data/check_in_dao.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_state.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/health/health_adapter.dart';
import 'package:vitalpet/features/pet/data/pet_dao.dart';
import 'package:vitalpet/features/pet/domain/milestone_detector.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';
import 'package:vitalpet/features/pet/domain/pet_state_mapper.dart';
import 'package:vitalpet/features/pet/domain/vitality_calculator.dart';
import 'package:vitalpet/features/slm/question_sequencer.dart';
import 'package:vitalpet/features/slm/slm_context.dart';
import 'package:vitalpet/features/slm/slm_output.dart';

/// Result of [CheckInEngine.completeSession].
class CompleteSessionResult {
  const CompleteSessionResult({
    required this.state,
    required this.updatedPet,
    required this.milestone,
    required this.wellnessScore,
  });

  final CheckInSessionState state;
  final PetState updatedPet;
  final MilestoneType? milestone;
  final int wellnessScore;
}

/// Orchestrates the full check-in session lifecycle.
/// Pure Dart — no Flutter plugin dependencies (widget update handled by notifier).
class CheckInEngine {
  CheckInEngine({
    required this.checkInDao,
    required this.petDao,
    required this.auditLogDao,
    required this.db,
    required this.healthAdapter,
    required this.questionSequencer,
  });

  final CheckInDao checkInDao;
  final PetDao petDao;
  final AuditLogDao auditLogDao;
  final AppDatabase db;
  final HealthAdapter healthAdapter;
  final QuestionSequencer questionSequencer;

  /// Loads health snapshot and transitions session to collectingScore.
  Future<CheckInSessionState> startSession() async {
    final now = DateTime.now();
    await healthAdapter.fetchSummary(
      start: now.subtract(const Duration(hours: 24)),
      end: now,
    );
    return const CheckInSessionState.collectingScore();
  }

  /// Determines mode from [score], fetches SLM questions for Mode 2/3.
  Future<CheckInSessionState> submitWellnessScore(int score) async {
    final mode = selectMode(score);

    if (mode == CheckInMode.light) {
      return CheckInSessionState.collectingAnswers(
        wellnessScore: score,
        mode: mode,
        questions: const [],
        currentIndex: 0,
        answers: const [],
      );
    }

    final slmCtx = SLMContext(
      wellnessScore: score,
      activeDomains: const ['pain', 'fatigue', 'sleep', 'appetite', 'mood'],
      baselines: const {},
    );
    final output = await questionSequencer.sequence(slmCtx);

    return CheckInSessionState.collectingAnswers(
      wellnessScore: score,
      mode: mode,
      questions: output.questions,
      currentIndex: 0,
      answers: const [],
    );
  }

  /// Adds [answer] to session and advances the question index.
  CheckInSessionState submitAnswer(
    CheckInSessionState current,
    QuestionAnswer answer,
  ) {
    return current.whenOrNull(
          collectingAnswers: (wellnessScore, mode, questions, currentIndex,
                  answers) =>
              CheckInSessionState.collectingAnswers(
                wellnessScore: wellnessScore,
                mode: mode,
                questions: questions,
                currentIndex: currentIndex + 1,
                answers: [...answers, answer],
              ),
        ) ??
        (throw StateError('submitAnswer called in wrong state: $current'));
  }

  /// Persists a partial session (isPartial=true) inside a DB transaction.
  Future<CheckInSessionState> savePartial(CheckInSessionState current) async {
    final data = _requireCollecting(current, 'savePartial');
    final sessionId = _sessionId(data.wellnessScore, data.answers);
    final answersJson = _encodeAnswers(data.answers);

    await db.transaction(() async {
      await checkInDao.insertCheckIn(
        _buildCompanion(
          sessionId: sessionId,
          wellnessScore: data.wellnessScore,
          mode: data.mode,
          answersJson: answersJson,
          depthScore: _depth(data.answers, data.questions),
          isPartial: true,
        ),
      );
      await auditLogDao.appendInTransaction(
        AuditEvent.checkinWrite(
          sessionId: sessionId,
          payloadHash: _sha256(answersJson),
        ),
      );
    });

    return CheckInSessionState.partial(
      wellnessScore: data.wellnessScore,
      answers: data.answers,
      savedAt: DateTime.now(),
    );
  }

  /// Restores a partial session, resuming from where the user left off.
  CheckInSessionState resumePartial({
    required int wellnessScore,
    required List<QuestionAnswer> answers,
    required List<SLMQuestion> pendingQuestions,
    required CheckInMode mode,
  }) {
    return CheckInSessionState.collectingAnswers(
      wellnessScore: wellnessScore,
      mode: mode,
      questions: pendingQuestions,
      currentIndex: answers.length,
      answers: answers,
    );
  }

  /// Atomically writes check-in, updates pet state, appends audit entry,
  /// and checks vulnerability safeguard.
  ///
  /// Returns [CompleteSessionResult] containing the new session state, updated
  /// [PetState] (for widget update), wellness score, and any milestone.
  /// The caller (notifier) is responsible for calling [updateWidgetData].
  Future<CompleteSessionResult> completeSession(
      CheckInSessionState current) async {
    final data = _requireCollecting(current, 'completeSession');
    final sessionId = _sessionId(data.wellnessScore, data.answers);
    final answersJson = _encodeAnswers(data.answers);
    final depthScore = _depth(data.answers, data.questions);

    final petRow = await petDao.getPetState();
    if (petRow == null) {
      throw StateError('Cannot complete check-in: no active pet');
    }

    final now = DateTime.now().toUtc();
    final utcDate = _isoDate(now);
    final isConsecutive = _isConsecutiveDay(petRow.lastCheckinUtc, utcDate);
    final newStreak = isConsecutive ? petRow.streak + 1 : 1;
    final newBadDays =
        data.wellnessScore <= 3 ? petRow.consecutiveBadDays + 1 : 0;

    final missedDays = _missedDays(petRow.lastCheckinUtc);
    final newVitality = calculateVitality(
      streak: newStreak,
      checkInDepthScore: depthScore,
      consecutiveMissedDays: List.generate(missedDays, (i) => i),
      isVulnerabilityFrozen: petRow.vulnerabilityFrozen,
    );
    final newVisualState = mapVitalityToState(newVitality);

    await db.transaction(() async {
      await checkInDao.insertCheckIn(
        _buildCompanion(
          sessionId: sessionId,
          wellnessScore: data.wellnessScore,
          mode: data.mode,
          answersJson: answersJson,
          depthScore: depthScore,
          isPartial: false,
        ),
      );
      await petDao.updatePetState(
        PetStateTableCompanion(
          petId: Value(petRow.petId),
          vitality: Value(newVitality),
          streak: Value(newStreak),
          lastCheckinUtc: Value(now.toIso8601String()),
          consecutiveBadDays: Value(newBadDays),
        ),
      );
      await auditLogDao.appendInTransaction(
        AuditEvent.checkinWrite(
          sessionId: sessionId,
          payloadHash: _sha256(answersJson),
        ),
      );
    });

    // Vulnerability safeguard (5+ consecutive low-wellness days).
    if (newBadDays >= 5 && !petRow.vulnerabilityCardShown) {
      await petDao.updatePetState(
        PetStateTableCompanion(
          petId: Value(petRow.petId),
          vulnerabilityFrozen: const Value(true),
          vulnerabilityCardShown: const Value(true),
        ),
      );
    }

    final milestone = detectMilestone(newStreak);
    final species = PetSpecies.values.firstWhere(
      (e) => e.name == petRow.species,
      orElse: () => PetSpecies.cat,
    );
    final updatedPet = PetState(
      petId: petRow.petId,
      name: petRow.name,
      species: species,
      vitality: newVitality,
      visualState: newVisualState,
      streak: newStreak,
      lastCheckinUtc: now.toIso8601String(),
      consecutiveBadDays: newBadDays,
      vulnerabilityFrozen: petRow.vulnerabilityFrozen,
    );

    return CompleteSessionResult(
      state: CheckInSessionState.completed(
        hadMilestone: milestone != null,
        milestone: milestone,
      ),
      updatedPet: updatedPet,
      milestone: milestone,
      wellnessScore: data.wellnessScore,
    );
  }

  /// Updates answersJson + amendedAt and appends an AMENDMENT audit entry.
  Future<void> amendSession(
    String checkInId,
    List<QuestionAnswer> updatedAnswers,
  ) async {
    final answersJson = _encodeAnswers(updatedAnswers);
    final amendedAt = DateTime.now().toUtc().toIso8601String();

    await db.transaction(() async {
      await checkInDao.amendCheckIn(checkInId, answersJson, amendedAt);
      await auditLogDao.appendInTransaction(
        AuditEvent.amendment(
          sessionId: checkInId,
          payloadHash: _sha256(answersJson),
        ),
      );
    });
  }

  // --- Private helpers ---

  ({
    int wellnessScore,
    CheckInMode mode,
    List<SLMQuestion> questions,
    int currentIndex,
    List<QuestionAnswer> answers,
  }) _requireCollecting(CheckInSessionState state, String callerName) {
    final data = state.whenOrNull(
      collectingAnswers: (wellnessScore, mode, questions, currentIndex,
              answers) =>
          (
            wellnessScore: wellnessScore,
            mode: mode,
            questions: questions,
            currentIndex: currentIndex,
            answers: answers,
          ),
    );
    if (data == null) {
      throw StateError('$callerName called in wrong state: $state');
    }
    return data;
  }

  String _sessionId(int score, List<QuestionAnswer> answers) {
    final raw =
        '${DateTime.now().toUtc().toIso8601String()}_${score}_${answers.length}';
    return sha256.convert(utf8.encode(raw)).toString().substring(0, 16);
  }

  String _sha256(String raw) => sha256.convert(utf8.encode(raw)).toString();

  String _encodeAnswers(List<QuestionAnswer> answers) =>
      jsonEncode(answers.map((a) => a.toJson()).toList());

  String _isoDate(DateTime utc) =>
      '${utc.year.toString().padLeft(4, '0')}-'
      '${utc.month.toString().padLeft(2, '0')}-'
      '${utc.day.toString().padLeft(2, '0')}';

  CheckInsCompanion _buildCompanion({
    required String sessionId,
    required int wellnessScore,
    required CheckInMode mode,
    required String answersJson,
    required double depthScore,
    required bool isPartial,
  }) {
    final now = DateTime.now().toUtc();
    final local = DateTime.now();
    return CheckInsCompanion.insert(
      id: sessionId,
      utcDate: _isoDate(now),
      localDate: _isoDate(local),
      wellnessScore: wellnessScore,
      mode: mode.index,
      answersJson: answersJson,
      depthScore: Value(depthScore),
      isPartial: Value(isPartial),
      createdAt: now.toIso8601String(),
    );
  }

  double _depth(List<QuestionAnswer> answers, List<SLMQuestion> questions) {
    if (questions.isEmpty) return answers.isEmpty ? 0.5 : 1.0;
    return (answers.length / questions.length).clamp(0.0, 1.0);
  }

  bool _isConsecutiveDay(String? lastCheckinUtc, String todayUtc) {
    if (lastCheckinUtc == null) return false;
    try {
      final last = DateTime.parse(lastCheckinUtc).toUtc();
      final today = DateTime.parse(todayUtc);
      final diff =
          today.difference(DateTime.utc(last.year, last.month, last.day));
      return diff.inDays == 1;
    } catch (_) {
      return false;
    }
  }

  int _missedDays(String? lastCheckinUtc) {
    if (lastCheckinUtc == null) return 0;
    final last = DateTime.parse(lastCheckinUtc).toUtc();
    final today = DateTime.now().toUtc();
    return (today.difference(last).inDays - 1).clamp(0, 30);
  }
}
