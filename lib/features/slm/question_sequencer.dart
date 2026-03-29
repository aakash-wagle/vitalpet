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
      final prompt = _buildPrompt(context);
      final raw = await _slmClient.generate(
        prompt,
        timeout: const Duration(milliseconds: 3000),
      );
      return _parseOutput(raw);
    } on SLMTimeoutException {
      final questions = _fallback.getQuestions(context);
      return SLMOutput(questions: questions, usedFallback: true);
    } catch (_) {
      // Any other failure (model not loaded, parse error) → fallback.
      final questions = _fallback.getQuestions(context);
      return SLMOutput(questions: questions, usedFallback: true);
    }
  }

  String _buildPrompt(SLMContext context) {
    // TODO: load system prompt from config/slm_prompt.txt via rootBundle.
    return 'status:${context.overallStatus} '
        'domains:${context.activeDomains.join(",")}';
  }

  SLMOutput _parseOutput(String raw) {
    // TODO: implement JSON parsing against SLMOutput schema.
    // Throw on malformed output — caught above and routed to fallback.
    throw FormatException('SLM output parsing not yet implemented: $raw');
  }
}
