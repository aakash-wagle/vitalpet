import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/slm/rule_based_fallback.dart';
import 'package:vitalpet/features/slm/slm_context.dart';

void main() {
  group('RuleBasedFallback', () {
    const fallback = RuleBasedFallback({});

    test('asks only selected symptom domains', () {
      const context = SLMContext(
        overallStatus: 'not_great',
        activeDomains: ['pain', 'nausea'],
        baselines: {},
      );

      final questions = fallback.getQuestions(context);

      expect(questions.map((q) => q.domain), ['pain', 'nausea']);
    });

    test('does not ask gate questions for unselected domains', () {
      const context = SLMContext(
        overallStatus: 'not_great',
        activeDomains: ['fatigue'],
        baselines: {},
      );

      final questions = fallback.getQuestions(context);

      expect(questions.length, 1);
      expect(questions.first.domain, 'fatigue');
      expect(questions.first.prompt, isNot('Are you experiencing any pain?'));
    });

    test('returns empty list when no domains selected', () {
      const context = SLMContext(
        overallStatus: 'not_great',
        activeDomains: [],
        baselines: {},
      );

      final questions = fallback.getQuestions(context);
      expect(questions, isEmpty);
    });

    test('returns empty list for great status', () {
      const context = SLMContext(
        overallStatus: 'great',
        activeDomains: ['pain', 'fatigue', 'nausea'],
        baselines: {},
      );

      final questions = fallback.getQuestions(context);
      expect(questions, isEmpty);
    });
  });
}
