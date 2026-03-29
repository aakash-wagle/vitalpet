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
    final questions = <SLMQuestion>[];

    // For "not_great" status, ask about symptom categories
    if (context.overallStatus == 'not_great') {
      // First ask if they're in pain (binary gate)
      questions.add(const SLMQuestion(
        domain: 'pain',
        type: QuestionType.binary,
        prompt: 'Are you experiencing any pain?',
        options: {'yes': 'Yes', 'no': 'No'},
      ));

      questions.add(const SLMQuestion(
        domain: 'fatigue',
        type: QuestionType.binary,
        prompt: 'Are you feeling unusually tired or fatigued?',
        options: {'yes': 'Yes', 'no': 'No'},
      ));

      questions.add(const SLMQuestion(
        domain: 'nausea',
        type: QuestionType.binary,
        prompt: 'Are you experiencing any nausea or vomiting?',
        options: {'yes': 'Yes', 'no': 'No'},
      ));

      // Free-text for anything else
      questions.add(const SLMQuestion(
        domain: 'other',
        type: QuestionType.text,
        prompt: 'Is there anything else you\'d like to note about how you\'re feeling?',
      ));
    }

    return questions;
  }

  /// Loads rules from assets/config/cold_start_rules.json.
  static Future<RuleBasedFallback> load() async {
    // TODO: implement rootBundle load
    return const RuleBasedFallback({});
  }
}
