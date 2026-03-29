/// Symptom categories for structured check-in data.
/// Matches the category column in check_in_symptoms and assets/config/symptom_taxonomy.json.
/// Values: fever | pain | fatigue | nausea | other — per DATA_TO_COLLECT.md.
enum SymptomCategory {
  fever,
  pain,
  fatigue,
  nausea,
  other;

  static SymptomCategory fromString(String value) {
    return SymptomCategory.values.firstWhere(
      (c) => c.name == value,
      orElse: () => throw ArgumentError('Unknown category: $value'),
    );
  }
}
