import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:vitalpet/core/audit/audit_log_dao.dart';
import 'package:vitalpet/core/constants/symptom_domains.dart';
import 'package:vitalpet/core/database/app_database.dart';
import 'package:vitalpet/features/check_in/data/check_in_dao.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_state.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/check_in/domain/symptom_data.dart';
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
    required this.overallStatus,
  });

  final CheckInSessionState state;
  final PetState updatedPet;
  final MilestoneType? milestone;
  final String overallStatus;
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
    // Check for existing partial session to resume
    final partial = await checkInDao.findPartialToday();
    if (partial != null) {
      return _resumeFromPartial(partial);
    }

    final now = DateTime.now();
    await healthAdapter.fetchSummary(
      start: now.subtract(const Duration(hours: 24)),
      end: now,
    );
    return const CheckInSessionState.collectingScore();
  }

  /// Resumes a partial check-in from the database.
  Future<CheckInSessionState> _resumeFromPartial(CheckIn partial) async {
    final answers = _decodeAnswers(partial.answersJson);
    final symptoms = partial.symptomsJson.isNotEmpty
        ? SymptomEntry.decodeList(partial.symptomsJson)
        : <SymptomEntry>[];
    final activeDomains = _activeDomainsForSequencing(
      answers: answers,
      symptoms: symptoms,
    );
    final mode = selectMode(partial.overallStatus);

    // Re-fetch questions for remaining flow
    // Delete the old partial so we don't duplicate on save
    await checkInDao.deletePartial(partial.id);

    final slmCtx = SLMContext(
      overallStatus: partial.overallStatus,
      activeDomains: activeDomains,
      baselines: const {},
    );
    final output = await questionSequencer.sequence(slmCtx);

    return CheckInSessionState.collectingAnswers(
      overallStatus: partial.overallStatus,
      mode: mode,
      questions: output.questions,
      currentIndex: answers.length,
      answers: answers,
      symptoms: symptoms,
    );
  }

  /// Submits the overall status ("great" or "not_great").
  /// If "great", goes straight to collectingAnswers with no questions.
  /// If "not_great", goes to selectingSymptoms.
  Future<CheckInSessionState> submitOverallStatus(String status) async {
    if (status == 'great') {
      return CheckInSessionState.collectingAnswers(
        overallStatus: status,
        mode: CheckInMode.light,
        questions: const [],
        currentIndex: 0,
        answers: const [],
      );
    }

    return CheckInSessionState.selectingSymptoms(overallStatus: status);
  }

  /// User selected symptom categories — begin collecting details for each.
  CheckInSessionState beginSymptomDetails(
    String overallStatus,
    List<SymptomCategory> categories,
  ) {
    if (categories.isEmpty) {
      // No categories selected, skip to answers
      return CheckInSessionState.collectingAnswers(
        overallStatus: overallStatus,
        mode: CheckInMode.standard,
        questions: const [],
        currentIndex: 0,
        answers: const [],
      );
    }

    return CheckInSessionState.collectingSymptomDetails(
      overallStatus: overallStatus,
      selectedCategories: categories,
      currentCategoryIndex: 0,
      collectedSymptoms: const [],
      categoryStep: 0,
      currentCategoryData: const {},
    );
  }

  /// Uses pre-structured symptom entries (from free-text parsing) and jumps
  /// directly to follow-up questions, skipping per-category button flow.
  Future<CheckInSessionState> beginFromStructuredSymptoms(
    String overallStatus,
    List<SymptomEntry> symptoms,
  ) async {
    if (symptoms.isEmpty) {
      return beginSymptomDetails(overallStatus, const [SymptomCategory.other]);
    }

    final activeDomains = <String>[];
    for (final symptom in symptoms) {
      final domain = symptom.category.name;
      if (!activeDomains.contains(domain)) {
        activeDomains.add(domain);
      }
    }

    final slmCtx = SLMContext(
      overallStatus: overallStatus,
      activeDomains: activeDomains,
      baselines: const {},
    );
    final output = await questionSequencer.sequence(slmCtx);

    return CheckInSessionState.collectingAnswers(
      overallStatus: overallStatus,
      mode: CheckInMode.standard,
      questions: output.questions,
      currentIndex: 0,
      answers: const [],
      symptoms: symptoms,
    );
  }

  /// Submit an answer for the current symptom detail step.
  /// Returns the next state (next step, next category, or done with symptoms).
  Future<CheckInSessionState> submitSymptomDetail(
    CheckInSessionState current,
    String key,
    dynamic value,
  ) async {
    final data = current.whenOrNull(
      collectingSymptomDetails:
          (overallStatus, categories, catIdx, collected, step, catData) => (
            overallStatus: overallStatus,
            categories: categories,
            catIdx: catIdx,
            collected: collected,
            step: step,
            catData: catData,
          ),
    );
    if (data == null) {
      throw StateError('submitSymptomDetail called in wrong state');
    }

    final updatedData = Map<String, dynamic>.from(data.catData)..[key] = value;
    final category = data.categories[data.catIdx];
    final totalSteps = _stepsForCategory(category);
    final nextStep = data.step + 1;

    if (nextStep >= totalSteps) {
      // Finished this category — build SymptomEntry
      final pattern = updatedData['pattern'] as String? ?? '';
      final details = Map<String, dynamic>.from(updatedData)..remove('pattern');

      final entry = SymptomEntry(
        category: category,
        pattern: pattern,
        details: details,
      );

      final newCollected = [...data.collected, entry];
      final nextCatIdx = data.catIdx + 1;

      if (nextCatIdx >= data.categories.length) {
        // All categories done — move to SLM questions or completion
        final slmCtx = SLMContext(
          overallStatus: data.overallStatus,
          activeDomains: data.categories.map((c) => c.name).toList(),
          baselines: const {},
        );
        final output = await questionSequencer.sequence(slmCtx);

        return CheckInSessionState.collectingAnswers(
          overallStatus: data.overallStatus,
          mode: CheckInMode.standard,
          questions: output.questions,
          currentIndex: 0,
          answers: const [],
          symptoms: newCollected,
        );
      }

      return CheckInSessionState.collectingSymptomDetails(
        overallStatus: data.overallStatus,
        selectedCategories: data.categories,
        currentCategoryIndex: nextCatIdx,
        collectedSymptoms: newCollected,
        categoryStep: 0,
        currentCategoryData: const {},
      );
    }

    return CheckInSessionState.collectingSymptomDetails(
      overallStatus: data.overallStatus,
      selectedCategories: data.categories,
      currentCategoryIndex: data.catIdx,
      collectedSymptoms: data.collected,
      categoryStep: nextStep,
      currentCategoryData: updatedData,
    );
  }

  /// Adds [answer] to session and advances the question index.
  CheckInSessionState submitAnswer(
    CheckInSessionState current,
    QuestionAnswer answer,
  ) {
    return current.whenOrNull(
          collectingAnswers:
              (
                overallStatus,
                mode,
                questions,
                currentIndex,
                answers,
                symptoms,
              ) => CheckInSessionState.collectingAnswers(
                overallStatus: overallStatus,
                mode: mode,
                questions: questions,
                currentIndex: currentIndex + 1,
                answers: [...answers, answer],
                symptoms: symptoms,
              ),
        ) ??
        (throw StateError('submitAnswer called in wrong state: $current'));
  }

  /// Persists a partial session (isPartial=true) inside a DB transaction.
  Future<CheckInSessionState> savePartial(CheckInSessionState current) async {
    String overallStatus = 'great';
    List<QuestionAnswer> answers = [];
    List<SymptomEntry> symptoms = [];

    current.whenOrNull(
      collectingAnswers: (os, mode, questions, idx, ans, syms) {
        overallStatus = os;
        answers = ans;
        symptoms = syms;
      },
      collectingSymptomDetails:
          (os, categories, catIdx, collected, step, catData) {
            overallStatus = os;
            symptoms = collected;
          },
      selectingSymptoms: (os) {
        overallStatus = os;
      },
    );

    final sessionId = _sessionId(overallStatus, answers);
    final answersJson = _encodeAnswers(answers);
    final symptomsJson = SymptomEntry.encodeList(symptoms);

    await db.transaction(() async {
      await checkInDao.insertCheckIn(
        _buildCompanion(
          sessionId: sessionId,
          overallStatus: overallStatus,
          mode: selectMode(overallStatus),
          answersJson: answersJson,
          symptomsJson: symptomsJson,
          depthScore: 0.0,
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
      overallStatus: overallStatus,
      answers: answers,
      symptoms: symptoms,
      savedAt: DateTime.now(),
    );
  }

  /// Atomically writes check-in, updates pet state, appends audit entry,
  /// and checks vulnerability safeguard.
  Future<CompleteSessionResult> completeSession(
    CheckInSessionState current,
  ) async {
    String overallStatus = 'great';
    CheckInMode mode = CheckInMode.light;
    List<SLMQuestion> questions = [];
    List<QuestionAnswer> answers = [];
    List<SymptomEntry> symptoms = [];

    current.whenOrNull(
      collectingAnswers: (os, m, qs, idx, ans, syms) {
        overallStatus = os;
        mode = m;
        questions = qs;
        answers = ans;
        symptoms = syms;
      },
      collectingSymptomDetails:
          (os, categories, catIdx, collected, step, catData) {
            overallStatus = os;
            mode = CheckInMode.standard;
            symptoms = collected;
          },
    );

    final sessionId = _sessionId(overallStatus, answers);
    final answersJson = _encodeAnswers(answers);
    final symptomsJson = SymptomEntry.encodeList(symptoms);
    final depthScore = _depth(answers, questions);

    final petRow = await petDao.getPetState();
    if (petRow == null) {
      throw StateError('Cannot complete check-in: no active pet');
    }

    final now = DateTime.now().toUtc();
    final utcDate = _isoDate(now);
    final isConsecutive = _isConsecutiveDay(petRow.lastCheckinUtc, utcDate);
    final newStreak = isConsecutive ? petRow.streak + 1 : 1;
    final isNotGreat = overallStatus == 'not_great';
    final newBadDays = isNotGreat ? petRow.consecutiveBadDays + 1 : 0;

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
          overallStatus: overallStatus,
          mode: mode,
          answersJson: answersJson,
          symptomsJson: symptomsJson,
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
      overallStatus: overallStatus,
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

  int _stepsForCategory(SymptomCategory category) {
    return switch (category) {
      SymptomCategory.fever => 2, // temp+skipped, pattern
      SymptomCategory.pain => 3, // regions, type, pattern
      SymptomCategory.fatigue => 2, // scope, pattern
      SymptomCategory.nausea => 2, // vomiting+appetite, pattern
      SymptomCategory.other => 1, // free_text
    };
  }

  String _sessionId(String status, List<QuestionAnswer> answers) {
    final raw =
        '${DateTime.now().toUtc().toIso8601String()}_${status}_${answers.length}';
    return sha256.convert(utf8.encode(raw)).toString().substring(0, 16);
  }

  String _sha256(String raw) => sha256.convert(utf8.encode(raw)).toString();

  String _encodeAnswers(List<QuestionAnswer> answers) =>
      jsonEncode(answers.map((a) => a.toJson()).toList());

  List<QuestionAnswer> _decodeAnswers(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map((e) => QuestionAnswer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String _isoDate(DateTime utc) =>
      '${utc.year.toString().padLeft(4, '0')}-'
      '${utc.month.toString().padLeft(2, '0')}-'
      '${utc.day.toString().padLeft(2, '0')}';

  CheckInsCompanion _buildCompanion({
    required String sessionId,
    required String overallStatus,
    required CheckInMode mode,
    required String answersJson,
    required String symptomsJson,
    required double depthScore,
    required bool isPartial,
  }) {
    final now = DateTime.now().toUtc();
    final local = DateTime.now();
    return CheckInsCompanion.insert(
      id: sessionId,
      utcDate: _isoDate(now),
      localDate: _isoDate(local),
      overallStatus: overallStatus,
      mode: mode.index,
      answersJson: answersJson,
      symptomsJson: Value(symptomsJson),
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
      final diff = today.difference(
        DateTime.utc(last.year, last.month, last.day),
      );
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

  List<String> _activeDomainsForSequencing({
    required List<QuestionAnswer> answers,
    required List<SymptomEntry> symptoms,
  }) {
    final allowed = SymptomCategory.values.map((e) => e.name).toSet();
    final domains = <String>[];

    for (final symptom in symptoms) {
      final domain = symptom.category.name;
      if (!domains.contains(domain)) domains.add(domain);
    }

    for (final answer in answers) {
      final domain = answer.domain;
      if (allowed.contains(domain) && !domains.contains(domain)) {
        domains.add(domain);
      }
    }

    return domains;
  }
}
