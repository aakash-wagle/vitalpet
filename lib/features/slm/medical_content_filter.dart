/// Result of running [MedicalContentFilter.filter].
class FilterResult {
  const FilterResult({required this.safe, required this.text});

  final bool safe;
  final String text;
}

/// Filters SLM-generated text for prohibited medical content.
/// MANDATORY — every SLM string shown to the user must pass through this.
class MedicalContentFilter {
  const MedicalContentFilter(this._patterns);

  final List<String> _patterns;

  static const String _safeFallback =
      'I noticed something in your check-in. Please talk to your doctor if you have concerns.';

  /// Returns [FilterResult] with safe=false and fallback text if any pattern
  /// matches. Writes FILTER_TRIGGER audit event on block.
  FilterResult filter(String raw) {
    final lower = raw.toLowerCase();
    for (final pattern in _patterns) {
      if (lower.contains(pattern.toLowerCase())) {
        // TODO: write FILTER_TRIGGER audit event with payloadHash, never raw text
        return const FilterResult(safe: false, text: _safeFallback);
      }
    }
    return FilterResult(safe: true, text: raw);
  }

  /// Loads patterns from assets/config/medical_filter_patterns.json.
  static Future<MedicalContentFilter> load() async {
    // TODO: implement rootBundle load
    return const MedicalContentFilter([]);
  }
}
