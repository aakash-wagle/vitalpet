import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/features/slm/medical_content_filter.dart';
import 'package:vitalpet/features/slm/narrative_generator.dart';
import 'package:vitalpet/features/slm/slm_providers.dart';

/// Provides [MedicalContentFilter] loaded from config assets.
/// Falls back to an empty-pattern filter if the asset load fails.
final medicalContentFilterProvider = FutureProvider<MedicalContentFilter>(
  (ref) => MedicalContentFilter.load(),
);

/// Provides [NarrativeGenerator] wired to the SLM client and content filter.
/// Uses the rule-based fallback until [kUseSlmNarrative] is set to true.
final narrativeGeneratorProvider = Provider<NarrativeGenerator>((ref) {
  final slmClient = ref.watch(slmClientProvider);
  final filter = ref.watch(medicalContentFilterProvider).value ??
      const MedicalContentFilter([]);
  return NarrativeGenerator(slmClient: slmClient, filter: filter);
});
