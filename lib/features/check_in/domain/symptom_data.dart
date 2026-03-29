import 'dart:convert';

import 'package:vitalpet/core/constants/symptom_domains.dart';

/// A single symptom entry matching DATA_TO_COLLECT.md SymptomBase + category fields.
class SymptomEntry {
  SymptomEntry({
    required this.category,
    required this.pattern,
    this.onsetDay,
    this.details = const {},
  });

  final SymptomCategory category;
  final String pattern;
  final int? onsetDay; // computed, never asked
  final Map<String, dynamic> details; // category-specific fields

  Map<String, dynamic> toJson() => {
        'category': category.name,
        'pattern': pattern,
        if (onsetDay != null) 'onset_day': onsetDay,
        ...details,
      };

  factory SymptomEntry.fromJson(Map<String, dynamic> json) {
    final category = SymptomCategory.fromString(json['category'] as String);
    final pattern = json['pattern'] as String;
    final onsetDay = json['onset_day'] as int?;
    final details = Map<String, dynamic>.from(json)
      ..remove('category')
      ..remove('pattern')
      ..remove('onset_day');
    return SymptomEntry(
      category: category,
      pattern: pattern,
      onsetDay: onsetDay,
      details: details,
    );
  }

  static String encodeList(List<SymptomEntry> symptoms) =>
      jsonEncode(symptoms.map((s) => s.toJson()).toList());

  static List<SymptomEntry> decodeList(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map((e) => SymptomEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
