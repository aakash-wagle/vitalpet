/// Symptom categories matching DATA_TO_COLLECT.md schema.
/// Each category has its own set of fields and pattern values.
enum SymptomCategory {
  fever,
  pain,
  fatigue,
  nausea,
  other;

  static SymptomCategory fromString(String value) {
    return SymptomCategory.values.firstWhere(
      (d) => d.name == value,
      orElse: () => throw ArgumentError('Unknown category: $value'),
    );
  }

  String get label => switch (this) {
        fever => 'Fever',
        pain => 'Pain',
        fatigue => 'Fatigue',
        nausea => 'Nausea / Vomiting',
        other => 'Something else',
      };
}

/// Pattern values per category (from DATA_TO_COLLECT.md).
const feverPatterns = ['constant', 'intermittent', 'night_only'];
const painPatterns = ['constant', 'comes_and_goes', 'worsening', 'improving'];
const fatiguePatterns = [
  'morning_only',
  'afternoon_crash',
  'all_day',
  'post_exertion'
];
const nauseaPatterns = ['constant', 'after_eating', 'morning', 'wave_like'];

/// Pain type values.
const painTypes = [
  'sharp',
  'dull',
  'throbbing',
  'burning',
  'cramping',
  'aching'
];

/// Pain trigger values.
const painTriggers = ['movement', 'eating', 'breathing', 'touch', 'none'];

/// Fatigue scope values.
const fatigueScopes = ['functional', 'wiped_out', 'debilitating'];

/// Nausea vomit frequency values.
const vomitFrequencies = ['once', 'few_times', 'persistent'];

/// Appetite levels.
const appetiteLevels = ['normal', 'reduced', 'none'];

/// Dehydration signs.
const dehydrationSigns = ['dry_mouth', 'dark_urine', 'dizziness'];

/// Fever measurement methods.
const feverMethods = ['oral', 'ear', 'forehead', 'other'];
