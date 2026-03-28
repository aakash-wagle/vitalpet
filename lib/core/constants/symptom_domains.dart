/// Symptom domains loaded at runtime from assets/config/symptom_taxonomy.json.
/// Keep in sync with that file — do not hardcode domain strings elsewhere.
enum SymptomDomain {
  pain,
  fatigue,
  sleep,
  appetite,
  nausea,
  mood,
  cognitive,
  medication;

  static SymptomDomain fromString(String value) {
    return SymptomDomain.values.firstWhere(
      (d) => d.name == value,
      orElse: () => throw ArgumentError('Unknown domain: $value'),
    );
  }
}
