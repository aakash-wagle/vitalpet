import 'package:vitalpet/features/slm/slm_context.dart';
import 'package:vitalpet/features/slm/slm_output.dart';

/// Returns deterministic question sequences from cold_start_rules.json.
/// Used when [SLMClient] is unavailable or times out.
class RuleBasedFallback {
  const RuleBasedFallback(this._rules);

  // ignore: unused_field — used in getQuestions() when implemented
  final Map<String, List<String>> _rules;

  /// Returns questions ordered by priority for the given context.
  List<SLMQuestion> getQuestions(SLMContext context) {
    if (context.overallStatus != 'not_great') return const [];

    // Requirement: ask follow-up questions only for domains selected earlier
    // in symptom multi-select. Never re-ask category gate questions.
    final active = context.activeDomains.toSet();
    final questions = <SLMQuestion>[];

    if (active.contains('pain')) {
      questions.add(
        const SLMQuestion(
          domain: 'pain',
          type: QuestionType.text,
          prompt: 'What is the hardest part of the pain right now?',
        ),
      );
    }

    if (active.contains('fatigue')) {
      questions.add(
        const SLMQuestion(
          domain: 'fatigue',
          type: QuestionType.text,
          prompt: 'How is fatigue affecting your day-to-day activities?',
        ),
      );
    }

    if (active.contains('nausea')) {
      questions.add(
        const SLMQuestion(
          domain: 'nausea',
          type: QuestionType.text,
          prompt: 'Any specific triggers or patterns with nausea today?',
        ),
      );
    }

    if (active.contains('fever')) {
      questions.add(
        const SLMQuestion(
          domain: 'fever',
          type: QuestionType.text,
          prompt: 'How has your temperature pattern changed through the day?',
        ),
      );
    }

    if (active.contains('other')) {
      questions.add(
        const SLMQuestion(
          domain: 'other',
          type: QuestionType.text,
          prompt:
              'Is there anything else you\'d like to note about how you\'re feeling?',
        ),
      );
    }

    return questions;
  }

  /// Loads rules from assets/config/cold_start_rules.json.
  static Future<RuleBasedFallback> load() async {
    // TODO: implement rootBundle load
    return const RuleBasedFallback({});
  }
}
