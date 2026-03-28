// printing package used in generateAndShare() when implemented.

/// Generates the doctor handoff PDF and shares it via the native share sheet.
/// Pure Dart — no native bridge required.
/// Writes HANDOFF_EXPORT audit event on completion.
class HandoffGenerator {
  const HandoffGenerator();

  /// Reads DB for [dayCount] days → generates SLM narrative →
  /// builds pdf.Document → calls Printing.sharePdf().
  Future<void> generateAndShare({required int dayCount}) async {
    // TODO: implement full pipeline
    // 1. Load check-ins via CheckInDao
    // 2. Build NarrativeContext (de-identified)
    // 3. Call NarrativeGenerator.generate()
    // 4. Build pdf.Document with charts + narrative
    // 5. Printing.sharePdf(bytes: ...) — VitalPet never observes share destination
    // 6. Write HANDOFF_EXPORT audit event
    throw UnimplementedError();
  }
}
