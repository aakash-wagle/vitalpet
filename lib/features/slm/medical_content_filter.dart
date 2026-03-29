import 'dart:convert';

import 'package:flutter/services.dart';

/// Result of running [MedicalContentFilter.filter].
class FilterResult {
  const FilterResult({required this.safe, required this.text});

  final bool safe;

  /// Use this text — never raw SLM output.
  final String text;
}

/// Post-processes SLM-generated text to block prohibited medical content.
///
/// MANDATORY — every SLM-generated string shown to the user must pass through
/// [filter] before display. See security rule 01-security-hipaa.mdc.
class MedicalContentFilter {
  const MedicalContentFilter(this._patterns);

  final List<String> _patterns;

  /// Safe, generic fallback shown whenever a phrase is blocked.
  /// Never contains PHI or diagnostic language.
  static const String safeFallback =
      "I'm here to help you remember — please speak to your doctor.";

  /// Returns [FilterResult] with safe=false and [safeFallback] text if any
  /// loaded pattern matches [raw] (case-insensitive).
  /// Callers must write a FILTER_TRIGGER audit event when safe=false.
  FilterResult filter(String raw) {
    final lower = raw.toLowerCase();
    for (final pattern in _patterns) {
      if (lower.contains(pattern.toLowerCase())) {
        return const FilterResult(safe: false, text: safeFallback);
      }
    }
    return FilterResult(safe: true, text: raw);
  }

  /// Loads patterns from `assets/config/medical_filter_patterns.json`
  /// via [rootBundle] at app start. Returns a [MedicalContentFilter] ready for use.
  static Future<MedicalContentFilter> load() async {
    final raw = await rootBundle.loadString(
      'assets/config/medical_filter_patterns.json',
    );
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final patterns = (decoded['patterns'] as List).cast<String>();
    return MedicalContentFilter(patterns);
  }
}
