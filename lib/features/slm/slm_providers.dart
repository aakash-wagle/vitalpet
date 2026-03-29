import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/features/slm/question_sequencer.dart';
import 'package:vitalpet/features/slm/rule_based_fallback.dart';
import 'package:vitalpet/features/slm/slm_client.dart';

/// Provides the [SLMClient] backed by the on-device Gemma plugin.
/// Lazily initialised — will use the fallback until the model is loaded.
final slmClientProvider = Provider<SLMClient>((ref) {
  return SLMClient(FlutterGemmaPlugin.instance);
});

/// Loads [RuleBasedFallback] from assets/config/cold_start_rules.json.
final ruleBasedFallbackProvider = FutureProvider<RuleBasedFallback>(
  (ref) => RuleBasedFallback.load(),
);

/// Provides [QuestionSequencer] wired to the SLM client and fallback.
/// Falls back to rule-based questions if the model is not loaded or times out.
final questionSequencerProvider = Provider<QuestionSequencer>((ref) {
  final fallback =
      ref.watch(ruleBasedFallbackProvider).value ??
      const RuleBasedFallback({});
  return QuestionSequencer(
    slmClient: ref.watch(slmClientProvider),
    fallback: fallback,
  );
});
