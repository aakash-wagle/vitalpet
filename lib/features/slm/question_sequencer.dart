import 'package:vitalpet/features/slm/slm_client.dart';
import 'package:vitalpet/features/slm/slm_context.dart';
import 'package:vitalpet/features/slm/slm_output.dart';
import 'package:vitalpet/features/slm/rule_based_fallback.dart';

/// Builds SLMContext, calls SLMClient, and parses SLMOutput.
/// Falls back to RuleBasedFallback on SLMTimeoutException.
class QuestionSequencer {
  const QuestionSequencer({
    required SLMClient slmClient,
    required RuleBasedFallback fallback,
  })  : _slmClient = slmClient,
        _fallback = fallback;

  // ignore: unused_field — used in sequence() when implemented
  final SLMClient _slmClient;
  final RuleBasedFallback _fallback;

  Future<SLMOutput> sequence(SLMContext context) async {
    try {
      // TODO: build prompt from slm_prompt.txt + context, call _slmClient, parse output
      throw UnimplementedError();
    } on SLMTimeoutException {
      final questions = _fallback.getQuestions(context);
      return SLMOutput(questions: questions, usedFallback: true);
    }
  }
}
