import 'package:vitalpet/features/handoff/narrative_context.dart';
import 'package:vitalpet/features/slm/slm_client.dart';
import 'package:vitalpet/features/slm/medical_content_filter.dart';

/// Returned by [NarrativeGenerator.generate].
class HandoffNarrative {
  const HandoffNarrative({required this.summary, required this.sections});

  final String summary;
  final Map<String, String> sections;
}

/// Generates a doctor-facing narrative from a de-identified [NarrativeContext].
/// Uses a separate SLM call — output is always filtered before use.
class NarrativeGenerator {
  const NarrativeGenerator({
    required SLMClient slmClient,
    required MedicalContentFilter filter,
  })  : _slmClient = slmClient,
        _filter = filter;

  // ignore: unused_field — used in generate() when implemented
  final SLMClient _slmClient;
  // ignore: unused_field
  final MedicalContentFilter _filter;

  Future<HandoffNarrative> generate(NarrativeContext context) async {
    // TODO: build prompt, call _slmClient, filter output, parse sections
    throw UnimplementedError();
  }
}
