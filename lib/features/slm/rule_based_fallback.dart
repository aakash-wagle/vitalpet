import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vitalpet/core/constants/symptom_domains.dart';
import 'package:vitalpet/features/slm/slm_context.dart';
import 'package:vitalpet/features/slm/slm_output.dart';

/// Returns deterministic question sequences from `assets/config/cold_start_rules.json`.
/// Used during days 1–7 (cold start) and whenever [SLMClient] times out.
class RuleBasedFallback {
  const RuleBasedFallback(this._rules);

  /// Keyed by condition name (or "default"). Values are ordered SymptomCategory names.
  final Map<String, List<String>> _rules;

  /// Returns questions ordered by priority for the given [context].
  ///
  /// Uses [SLMContext.conditionFocus] to select the rule order; falls back to
  /// "default" if the condition is unknown or null.
  List<SLMQuestion> getQuestions(SLMContext context) {
    final key = context.conditionFocus ?? 'default';
    final categoryNames =
        _rules[key] ?? _rules['default'] ?? _defaultOrder;

    return categoryNames
        .map(SymptomCategory.fromString)
        .map(_questionForCategory)
        .toList();
  }

  /// Loads rules from `assets/config/cold_start_rules.json` via [rootBundle].
  static Future<RuleBasedFallback> load() async {
    final raw = await rootBundle.loadString(
      'assets/config/cold_start_rules.json',
    );
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final rules = decoded.map<String, List<String>>(
      (key, value) => MapEntry(key, (value as List).cast<String>()),
    );
    return RuleBasedFallback(rules);
  }

  static const _defaultOrder = [
    'pain',
    'fatigue',
    'fever',
    'nausea',
    'other',
  ];

  static SLMQuestion _questionForCategory(SymptomCategory category) {
    return switch (category) {
      SymptomCategory.fever => const SLMQuestion(
          category: SymptomCategory.fever,
          type: QuestionType.binary,
          prompt: 'Have you had a fever? If so, what was your temperature?',
          fieldName: 'temperature',
        ),
      SymptomCategory.pain => const SLMQuestion(
          category: SymptomCategory.pain,
          type: QuestionType.bodyMap,
          prompt: 'Where are you experiencing pain?',
          fieldName: 'regions',
        ),
      SymptomCategory.fatigue => const SLMQuestion(
          category: SymptomCategory.fatigue,
          type: QuestionType.slider,
          prompt: 'How would you describe your energy level today?',
          fieldName: 'scope',
        ),
      SymptomCategory.nausea => const SLMQuestion(
          category: SymptomCategory.nausea,
          type: QuestionType.binary,
          prompt: 'Have you felt nauseous or had any stomach issues?',
          fieldName: 'vomiting',
        ),
      SymptomCategory.other => const SLMQuestion(
          category: SymptomCategory.other,
          type: QuestionType.text,
          prompt: 'Are there any other symptoms you would like to mention?',
          fieldName: null,
        ),
    };
  }
}
