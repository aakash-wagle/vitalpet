import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitalpet/core/audit/audit_log_dao.dart';
import 'package:vitalpet/core/database/app_database.dart';
import 'package:vitalpet/features/check_in/data/check_in_dao.dart';
import 'package:vitalpet/features/check_in/domain/check_in_engine.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_state.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/health/health_adapter.dart';
import 'package:vitalpet/features/pet/data/pet_dao.dart';
import 'package:vitalpet/features/slm/question_sequencer.dart';
import 'package:vitalpet/features/slm/slm_context.dart';
import 'package:vitalpet/features/slm/slm_output.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockCheckInDao extends Mock implements CheckInDao {}

class MockPetDao extends Mock implements PetDao {}

class MockAuditLogDao extends Mock implements AuditLogDao {}

class MockAppDatabase extends Mock implements AppDatabase {}

class MockHealthAdapter extends Mock implements HealthAdapter {}

class MockQuestionSequencer extends Mock implements QuestionSequencer {}

/// A Fake AppDatabase that executes the transaction callback synchronously,
/// avoiding the need to mock the generic [transaction] method.
class FakeAppDatabase extends Fake implements AppDatabase {
  @override
  Future<T> transaction<T>(
    Future<T> Function() action, {
    bool requireNew = false,
  }) =>
      action();
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

CheckInEngine _buildEngine({
  CheckInDao? checkInDao,
  PetDao? petDao,
  AuditLogDao? auditLogDao,
  AppDatabase? db,
  HealthAdapter? health,
  QuestionSequencer? sequencer,
}) {
  return CheckInEngine(
    checkInDao: checkInDao ?? MockCheckInDao(),
    petDao: petDao ?? MockPetDao(),
    auditLogDao: auditLogDao ?? MockAuditLogDao(),
    db: db ?? MockAppDatabase(),
    healthAdapter: health ?? MockHealthAdapter(),
    questionSequencer: sequencer ?? MockQuestionSequencer(),
  );
}

SLMQuestion _stubQuestion(String domain) => SLMQuestion(
      domain: domain,
      type: QuestionType.binary,
      prompt: 'Test question for $domain?',
      options: {'yes': 'Yes', 'no': 'No'},
    );

// Extracts data from collectingAnswers state — throws if wrong state.
({
  int wellnessScore,
  CheckInMode mode,
  List<SLMQuestion> questions,
  int currentIndex,
  List<QuestionAnswer> answers,
}) _extractCollecting(CheckInSessionState state) {
  final data = state.whenOrNull(
    collectingAnswers:
        (wellnessScore, mode, questions, currentIndex, answers) => (
          wellnessScore: wellnessScore,
          mode: mode,
          questions: questions,
          currentIndex: currentIndex,
          answers: answers,
        ),
  );
  if (data == null) throw StateError('Not collectingAnswers: $state');
  return data;
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const SLMContext(
        wellnessScore: 5,
        activeDomains: [],
        baselines: {},
      ),
    );
    registerFallbackValue(
      AuditEvent.checkinWrite(
        sessionId: 'test',
        payloadHash: 'hash',
      ),
    );
    registerFallbackValue(
      CheckInsCompanion.insert(
        id: 'fallback',
        utcDate: '2024-01-01',
        localDate: '2024-01-01',
        wellnessScore: 5,
        mode: 0,
        answersJson: '[]',
        createdAt: '2024-01-01T00:00:00.000Z',
      ),
    );
  });

  group('CheckInEngine.startSession', () {
    test('returns collectingScore state', () async {
      final health = MockHealthAdapter();
      when(() => health.fetchSummary(
                start: any(named: 'start'),
                end: any(named: 'end'),
              ))
          .thenAnswer((_) async => null);

      final engine = _buildEngine(health: health);
      final state = await engine.startSession();

      final isCollectingScore = state.when(
        idle: () => false,
        collectingScore: () => true,
        collectingAnswers: (_, __, ___, ____, _____) => false,
        partial: (_, __, ___) => false,
        completing: () => false,
        completed: (_, __) => false,
      );
      expect(isCollectingScore, isTrue);
    });
  });

  group('CheckInEngine.submitWellnessScore', () {
    test('score 7–10 → light mode, no SLM call, empty questions', () async {
      final sequencer = MockQuestionSequencer();
      final engine = _buildEngine(sequencer: sequencer);

      final state = await engine.submitWellnessScore(8);

      verifyNever(() => sequencer.sequence(any()));
      final data = _extractCollecting(state);
      expect(data.mode, equals(CheckInMode.light));
      expect(data.questions, isEmpty);
      expect(data.wellnessScore, equals(8));
    });

    test('score 4–6 → standard mode, calls sequencer, returns questions',
        () async {
      final sequencer = MockQuestionSequencer();
      when(() => sequencer.sequence(any())).thenAnswer(
        (_) async => SLMOutput(
          questions: [_stubQuestion('pain'), _stubQuestion('sleep')],
          usedFallback: false,
        ),
      );

      final engine = _buildEngine(sequencer: sequencer);
      final state = await engine.submitWellnessScore(5);

      verify(() => sequencer.sequence(any())).called(1);
      final data = _extractCollecting(state);
      expect(data.mode, equals(CheckInMode.standard));
      expect(data.questions.length, equals(2));
    });

    test('score 1–3 → companion mode, calls sequencer', () async {
      final sequencer = MockQuestionSequencer();
      when(() => sequencer.sequence(any())).thenAnswer(
        (_) async => SLMOutput(questions: [_stubQuestion('mood')]),
      );

      final engine = _buildEngine(sequencer: sequencer);
      final state = await engine.submitWellnessScore(2);

      final data = _extractCollecting(state);
      expect(data.mode, equals(CheckInMode.companion));
    });

    test('boundary: score 3 → companion, score 4 → standard', () async {
      final sequencer = MockQuestionSequencer();
      when(() => sequencer.sequence(any()))
          .thenAnswer((_) async => const SLMOutput(questions: []));
      final engine = _buildEngine(sequencer: sequencer);

      final companion = _extractCollecting(await engine.submitWellnessScore(3));
      final standard = _extractCollecting(await engine.submitWellnessScore(4));

      expect(companion.mode, CheckInMode.companion);
      expect(standard.mode, CheckInMode.standard);
    });

    test('boundary: score 6 → standard, score 7 → light', () async {
      final sequencer = MockQuestionSequencer();
      when(() => sequencer.sequence(any()))
          .thenAnswer((_) async => const SLMOutput(questions: []));
      final engine = _buildEngine(sequencer: sequencer);

      final standard = _extractCollecting(await engine.submitWellnessScore(6));
      final light = _extractCollecting(await engine.submitWellnessScore(7));

      expect(standard.mode, CheckInMode.standard);
      expect(light.mode, CheckInMode.light);
    });
  });

  group('CheckInEngine.submitAnswer', () {
    test('advances currentIndex and appends answer', () {
      final engine = _buildEngine();
      final questions = [_stubQuestion('pain'), _stubQuestion('sleep')];

      final state0 = CheckInSessionState.collectingAnswers(
        wellnessScore: 5,
        mode: CheckInMode.standard,
        questions: questions,
        currentIndex: 0,
        answers: const [],
      );

      final answer0 = QuestionAnswer(
        domain: 'pain',
        questionType: QuestionType.binary.name,
        value: 'yes',
      );

      final state1 = engine.submitAnswer(state0, answer0);
      final data = _extractCollecting(state1);

      expect(data.currentIndex, equals(1));
      expect(data.answers.length, equals(1));
      expect(data.answers.first.domain, equals('pain'));
    });

    test('throws StateError if called in idle state', () {
      final engine = _buildEngine();
      expect(
        () => engine.submitAnswer(
          const CheckInSessionState.idle(),
          const QuestionAnswer(domain: 'd', questionType: 'binary', value: 'v'),
        ),
        throwsStateError,
      );
    });

    test('throws StateError if called in collectingScore state', () {
      final engine = _buildEngine();
      expect(
        () => engine.submitAnswer(
          const CheckInSessionState.collectingScore(),
          const QuestionAnswer(domain: 'd', questionType: 'binary', value: 'v'),
        ),
        throwsStateError,
      );
    });
  });

  group('CheckInEngine.savePartial', () {
    test('persists partial and returns partial state', () async {
      final db = FakeAppDatabase();
      final checkInDao = MockCheckInDao();
      final auditLogDao = MockAuditLogDao();

      when(() => checkInDao.insertCheckIn(any())).thenAnswer((_) async {});
      when(() => auditLogDao.appendInTransaction(any()))
          .thenAnswer((_) async {});

      final engine = _buildEngine(
        db: db,
        checkInDao: checkInDao,
        auditLogDao: auditLogDao,
      );

      final collecting = CheckInSessionState.collectingAnswers(
        wellnessScore: 4,
        mode: CheckInMode.standard,
        questions: [_stubQuestion('pain')],
        currentIndex: 0,
        answers: const [],
      );

      final result = await engine.savePartial(collecting);

      final isPartial = result.when(
        idle: () => false,
        collectingScore: () => false,
        collectingAnswers: (_, __, ___, ____, _____) => false,
        partial: (_, __, ___) => true,
        completing: () => false,
        completed: (_, __) => false,
      );
      expect(isPartial, isTrue);
      verify(() => checkInDao.insertCheckIn(any())).called(1);
      verify(() => auditLogDao.appendInTransaction(any())).called(1);
    });

    test('throws StateError if called in wrong state', () async {
      final engine = _buildEngine();
      await expectLater(
        () => engine.savePartial(const CheckInSessionState.idle()),
        throwsStateError,
      );
    });
  });
}
