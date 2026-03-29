import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/core/constants/symptom_domains.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/slm/rule_based_fallback.dart';
import 'package:vitalpet/features/slm/slm_context.dart';

void main() {
  // Shared rules map — mirrors the shape of cold_start_rules.json.
  const testRules = {
    'default': ['pain', 'fatigue', 'fever', 'nausea', 'other'],
    'chronic_pain': ['pain', 'fatigue', 'nausea', 'fever', 'other'],
    'post_surgery': ['pain', 'fever', 'fatigue', 'nausea', 'other'],
  };

  late RuleBasedFallback fallback;

  setUp(() {
    fallback = const RuleBasedFallback(testRules);
  });

  SLMContext ctx({String? conditionFocus}) => SLMContext(
        wellnessScore: 4,
        mode: CheckInMode.guided,
        recentCheckins: [],
        baselineStats: {},
        conditionFocus: conditionFocus,
      );

  group('RuleBasedFallback', () {
    test('returns default domain order for unknown conditionFocus', () {
      final questions = fallback.getQuestions(ctx(conditionFocus: 'unknown'));
      final categories = questions.map((q) => q.category).toList();
      expect(categories, [
        SymptomCategory.pain,
        SymptomCategory.fatigue,
        SymptomCategory.fever,
        SymptomCategory.nausea,
        SymptomCategory.other,
      ]);
    });

    test('returns default domain order when conditionFocus is null', () {
      final questions = fallback.getQuestions(ctx());
      expect(questions.map((q) => q.category).first, SymptomCategory.pain);
    });

    test('returns chronic_pain-specific domain order', () {
      final questions =
          fallback.getQuestions(ctx(conditionFocus: 'chronic_pain'));
      final categories = questions.map((q) => q.category).toList();
      expect(categories, [
        SymptomCategory.pain,
        SymptomCategory.fatigue,
        SymptomCategory.nausea,
        SymptomCategory.fever,
        SymptomCategory.other,
      ]);
    });

    test('returns post_surgery-specific domain order', () {
      final questions =
          fallback.getQuestions(ctx(conditionFocus: 'post_surgery'));
      final categories = questions.map((q) => q.category).toList();
      expect(categories, [
        SymptomCategory.pain,
        SymptomCategory.fever,
        SymptomCategory.fatigue,
        SymptomCategory.nausea,
        SymptomCategory.other,
      ]);
    });

    test('returns non-empty list for any context', () {
      expect(fallback.getQuestions(ctx()), isNotEmpty);
      expect(fallback.getQuestions(ctx(conditionFocus: 'chronic_pain')), isNotEmpty);
    });

    test('all returned categories are valid SymptomCategory enum values', () {
      for (final conditionFocus in [null, 'chronic_pain', 'post_surgery', 'unknown']) {
        final questions = fallback.getQuestions(ctx(conditionFocus: conditionFocus));
        for (final q in questions) {
          expect(SymptomCategory.values, contains(q.category));
        }
      }
    });

    test('each question has a non-empty prompt', () {
      for (final q in fallback.getQuestions(ctx())) {
        expect(q.prompt, isNotEmpty);
      }
    });
  });
}
