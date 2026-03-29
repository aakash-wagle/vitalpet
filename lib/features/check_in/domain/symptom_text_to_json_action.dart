import 'dart:convert';

import 'package:vitalpet/core/constants/symptom_domains.dart';
import 'package:vitalpet/features/check_in/domain/symptom_data.dart';
import 'package:vitalpet/features/slm/slm_client.dart';

/// Converts free-form patient text into structured symptom JSON.
///
/// The returned JSON object shape is:
/// {
///   "overall_status": "not_great",
///   "symptoms": [<SymptomEntry JSON>, ...]
/// }
class SymptomTextToJsonAction {
  SymptomTextToJsonAction({required SLMClient slmClient})
    : _slmClient = slmClient;

  final SLMClient _slmClient;

  Future<String> extractSymptomsJsonObject(String patientMessage) async {
    final message = patientMessage.trim();
    if (message.isEmpty) {
      return _encodeObject(_fallbackSymptoms('I feel unwell.'));
    }

    try {
      final prompt = _buildPrompt(message);
      final raw = await _slmClient.generate(
        prompt,
        timeout: const Duration(seconds: 8),
      );
      final decoded = _decodeJsonObject(raw);
      final symptoms = _normaliseSymptoms(decoded, originalMessage: message);
      return _encodeObject(
        symptoms.isEmpty ? _fallbackSymptoms(message) : symptoms,
      );
    } catch (_) {
      return _encodeObject(_fallbackSymptoms(message));
    }
  }

  static List<SymptomEntry> decodeSymptomsFromJsonObject(String jsonObject) {
    final decoded = jsonDecode(jsonObject);
    if (decoded is! Map<String, dynamic>) return const [];
    final symptoms = decoded['symptoms'];
    if (symptoms is! List) return const [];
    return SymptomEntry.decodeList(jsonEncode(symptoms));
  }

  String _encodeObject(List<SymptomEntry> symptoms) {
    return jsonEncode({
      'overall_status': 'not_great',
      'symptoms': symptoms.map((s) => s.toJson()).toList(),
    });
  }

  String _buildPrompt(String message) {
    return '''
$_systemPrompt

Patient message:
"""
$message
"""

Return JSON only.
''';
  }

  Map<String, dynamic> _decodeJsonObject(String raw) {
    final trimmed = raw.trim();
    final fenced = _stripCodeFence(trimmed);
    final candidate = _extractBalancedJsonObject(fenced) ?? fenced;
    final decoded = jsonDecode(candidate);

    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is List<dynamic>) return {'symptoms': decoded};
    throw const FormatException('Model response is not a JSON object');
  }

  String _stripCodeFence(String raw) {
    if (!raw.startsWith('```')) return raw;
    final lines = raw.split('\n');
    if (lines.length < 3) return raw;
    final first = lines.first.trim();
    final last = lines.last.trim();
    if (!first.startsWith('```') || last != '```') return raw;
    return lines.sublist(1, lines.length - 1).join('\n').trim();
  }

  String? _extractBalancedJsonObject(String text) {
    final start = text.indexOf('{');
    if (start < 0) return null;

    var depth = 0;
    for (var i = start; i < text.length; i++) {
      final char = text[i];
      if (char == '{') depth++;
      if (char == '}') depth--;
      if (depth == 0) return text.substring(start, i + 1);
    }
    return null;
  }

  List<SymptomEntry> _normaliseSymptoms(
    Map<String, dynamic> decoded, {
    required String originalMessage,
  }) {
    final dynamic symptomsNode = decoded['symptoms'];
    if (symptomsNode is! List) return const [];

    final normalised = <SymptomEntry>[];
    for (final symptom in symptomsNode) {
      final entry = _normaliseOne(symptom);
      if (entry != null) normalised.add(entry);
    }

    if (normalised.isEmpty && originalMessage.isNotEmpty) {
      return _fallbackSymptoms(originalMessage);
    }

    return normalised;
  }

  SymptomEntry? _normaliseOne(dynamic symptomNode) {
    if (symptomNode is! Map) return null;
    final symptom = Map<String, dynamic>.from(symptomNode);

    final category = _parseCategory(symptom['category']);
    if (category == null) return null;

    final pattern = _normalisePattern(category, symptom['pattern']);
    final onsetDay = _asInt(symptom['onset_day']);

    final details = switch (category) {
      SymptomCategory.fever => _normaliseFeverDetails(symptom),
      SymptomCategory.pain => _normalisePainDetails(symptom),
      SymptomCategory.fatigue => _normaliseFatigueDetails(symptom),
      SymptomCategory.nausea => _normaliseNauseaDetails(symptom),
      SymptomCategory.other => _normaliseOtherDetails(symptom),
    };

    return SymptomEntry(
      category: category,
      pattern: pattern,
      onsetDay: onsetDay,
      details: details,
    );
  }

  Map<String, dynamic> _normaliseFeverDetails(Map<String, dynamic> symptom) {
    final measurement = symptom['measurement'];

    bool? skipped;
    double? temperature;
    String? unit;

    if (measurement is Map) {
      final m = Map<String, dynamic>.from(measurement);
      final hasThermometer = _asBool(m['has_thermometer']);
      if (hasThermometer != null) skipped = !hasThermometer;
      temperature = _asDouble(m['value']);
      unit = _normalizeUpper(_asString(m['unit']));
    }

    skipped ??= _asBool(symptom['skipped']);
    temperature ??= _asDouble(symptom['temperature']);
    unit ??= _normalizeUpper(_asString(symptom['unit']));

    final method = _pickEnum(_asString(symptom['method']), feverMethods);

    return _withoutNulls({
      'temperature': temperature,
      'unit': _pickEnum(unit, const ['C', 'F']),
      'method': method,
      'skipped': skipped,
    });
  }

  Map<String, dynamic> _normalisePainDetails(Map<String, dynamic> symptom) {
    final type = _pickEnum(_asString(symptom['type']), painTypes);
    final triggers = _stringList(symptom['triggers'])
        .map((t) => _pickEnum(t, painTriggers))
        .whereType<String>()
        .toSet()
        .toList();

    return _withoutNulls({
      'regions': _stringList(symptom['regions']),
      'type': type,
      if (triggers.isNotEmpty) 'triggers': triggers,
    });
  }

  Map<String, dynamic> _normaliseFatigueDetails(Map<String, dynamic> symptom) {
    final scope = _pickEnum(_asString(symptom['scope']), fatigueScopes);
    final blocksDaily = _asBool(symptom['blocks_daily']);
    return _withoutNulls({'scope': scope, 'blocks_daily': blocksDaily});
  }

  Map<String, dynamic> _normaliseNauseaDetails(Map<String, dynamic> symptom) {
    final vomiting = _asBool(symptom['vomiting']);
    final vomitFreq = _pickEnum(
      _asString(symptom['vomit_freq']),
      vomitFrequencies,
    );
    final appetite = _pickEnum(_asString(symptom['appetite']), appetiteLevels);

    final dehydrationSignList = _stringList(symptom['dehydration_signs'])
        .map((s) => _pickEnum(s, dehydrationSigns))
        .whereType<String>()
        .toSet()
        .toList();

    return _withoutNulls({
      'vomiting': vomiting,
      if (vomiting == true && vomitFreq != null) 'vomit_freq': vomitFreq,
      'appetite': appetite,
      if (dehydrationSignList.isNotEmpty)
        'dehydration_signs': dehydrationSignList,
    });
  }

  Map<String, dynamic> _normaliseOtherDetails(Map<String, dynamic> symptom) {
    final freeText =
        _asString(symptom['free_text']) ?? _asString(symptom['notes']) ?? '';

    final extracted = symptom['extracted_details'];
    return _withoutNulls({
      'free_text': freeText,
      if (extracted is Map)
        'extracted_details': Map<String, dynamic>.from(extracted),
    });
  }

  SymptomCategory? _parseCategory(dynamic value) {
    final v = _normalize(_asString(value));
    return switch (v) {
      'fever' => SymptomCategory.fever,
      'pain' => SymptomCategory.pain,
      'fatigue' => SymptomCategory.fatigue,
      'nausea' => SymptomCategory.nausea,
      'nausea_vomiting' => SymptomCategory.nausea,
      'nausea/vomiting' => SymptomCategory.nausea,
      'other' => SymptomCategory.other,
      _ => null,
    };
  }

  String _normalisePattern(SymptomCategory category, dynamic value) {
    final raw = _normalize(_asString(value));

    final allowed = switch (category) {
      SymptomCategory.fever => feverPatterns,
      SymptomCategory.pain => painPatterns,
      SymptomCategory.fatigue => fatiguePatterns,
      SymptomCategory.nausea => nauseaPatterns,
      SymptomCategory.other => const <String>['free_text'],
    };

    if (allowed.contains(raw)) return raw!;

    return switch (category) {
      SymptomCategory.fever => 'intermittent',
      SymptomCategory.pain => 'comes_and_goes',
      SymptomCategory.fatigue => 'all_day',
      SymptomCategory.nausea => 'wave_like',
      SymptomCategory.other => 'free_text',
    };
  }

  List<SymptomEntry> _fallbackSymptoms(String message) {
    final lower = message.toLowerCase();
    final detected = <SymptomEntry>[];

    if (lower.contains('fever') ||
        lower.contains('temperature') ||
        lower.contains('hot')) {
      detected.add(
        SymptomEntry(
          category: SymptomCategory.fever,
          pattern: 'intermittent',
          details: const {'skipped': true},
        ),
      );
    }

    if (lower.contains('pain') ||
        lower.contains('hurt') ||
        lower.contains('ache') ||
        lower.contains('sore')) {
      detected.add(
        SymptomEntry(category: SymptomCategory.pain, pattern: 'comes_and_goes'),
      );
    }

    if (lower.contains('tired') ||
        lower.contains('fatigue') ||
        lower.contains('exhausted') ||
        lower.contains('energy')) {
      detected.add(
        SymptomEntry(category: SymptomCategory.fatigue, pattern: 'all_day'),
      );
    }

    if (lower.contains('nausea') ||
        lower.contains('vomit') ||
        lower.contains('queasy') ||
        lower.contains('throw up')) {
      detected.add(
        SymptomEntry(category: SymptomCategory.nausea, pattern: 'wave_like'),
      );
    }

    if (detected.isEmpty) {
      detected.add(
        SymptomEntry(
          category: SymptomCategory.other,
          pattern: 'free_text',
          details: {'free_text': message},
        ),
      );
    }

    return detected;
  }

  String? _pickEnum(String? value, List<String> allowed) {
    if (value == null || value.isEmpty) return null;
    final normalized = _normalize(value);
    for (final item in allowed) {
      if (_normalize(item) == normalized) return item;
    }
    return null;
  }

  List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((e) => _asString(e))
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> _withoutNulls(Map<String, dynamic> input) {
    final out = <String, dynamic>{};
    for (final entry in input.entries) {
      final value = entry.value;
      if (value == null) continue;
      if (value is String && value.trim().isEmpty) continue;
      out[entry.key] = value;
    }
    return out;
  }

  String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  double? _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  bool? _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final v = value.trim().toLowerCase();
      if (v == 'true' || v == 'yes' || v == 'y') return true;
      if (v == 'false' || v == 'no' || v == 'n') return false;
    }
    return null;
  }

  String? _normalize(String? value) {
    if (value == null) return null;
    return value.trim().toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');
  }

  String? _normalizeUpper(String? value) {
    if (value == null) return null;
    return value.trim().toUpperCase();
  }
}

const String _systemPrompt = '''
You are VitalPet's symptom extraction engine.

Task:
Convert one patient free-text message into a strict JSON object for downstream app logic.

Output contract:
- Return exactly one JSON object.
- No markdown, no prose, no extra keys except those listed below.
- JSON shape:
  {
    "overall_status": "not_great",
    "symptoms": [
      {
        "category": "fever|pain|fatigue|nausea|other",
        "pattern": "category-specific enum",
        "onset_day": <integer optional>,
        ... category-specific fields ...
      }
    ]
  }

Allowed enums:
- fever.pattern: constant | intermittent | night_only
- pain.pattern: constant | comes_and_goes | worsening | improving
- fatigue.pattern: morning_only | afternoon_crash | all_day | post_exertion
- nausea.pattern: constant | after_eating | morning | wave_like
- pain.type: sharp | dull | throbbing | burning | cramping | aching
- pain.triggers[]: movement | eating | breathing | touch | none
- fatigue.scope: functional | wiped_out | debilitating
- nausea.vomit_freq: once | few_times | persistent
- nausea.appetite: normal | reduced | none
- nausea.dehydration_signs[]: dry_mouth | dark_urine | dizziness
- fever.unit: C | F
- fever.method: oral | ear | forehead | other

Category fields:
- fever: temperature?, unit?, method?, skipped?
- pain: regions[]?, type?, triggers[]?
- fatigue: scope?, blocks_daily?
- nausea: vomiting?, vomit_freq?, appetite?, dehydration_signs[]?
- other: free_text (required), extracted_details? (optional object)

Rules:
- Capture all symptoms explicitly mentioned or strongly implied.
- Never invent numeric values.
- If uncertainty exists, keep fields nullable/omitted rather than guessing.
- If content does not map well, emit category=other with free_text.
- If multiple symptoms exist, include multiple entries.

Examples:
Input: "I've had a fever since last night, 101.8 F orally, and a throbbing headache that is getting worse."
Output:
{
  "overall_status": "not_great",
  "symptoms": [
    {
      "category": "fever",
      "pattern": "night_only",
      "temperature": 101.8,
      "unit": "F",
      "method": "oral",
      "skipped": false
    },
    {
      "category": "pain",
      "pattern": "worsening",
      "regions": ["head"],
      "type": "throbbing"
    }
  ]
}

Input: "Nausea all morning. I threw up twice and feel dizzy with dry mouth."
Output:
{
  "overall_status": "not_great",
  "symptoms": [
    {
      "category": "nausea",
      "pattern": "morning",
      "vomiting": true,
      "vomit_freq": "few_times",
      "dehydration_signs": ["dizziness", "dry_mouth"]
    }
  ]
}

Input: "Completely wiped out for 3 days, can't do normal chores, crashes after small effort."
Output:
{
  "overall_status": "not_great",
  "symptoms": [
    {
      "category": "fatigue",
      "pattern": "post_exertion",
      "scope": "wiped_out",
      "blocks_daily": true
    }
  ]
}

Input: "I feel off and weird, kind of spacey, hard to explain."
Output:
{
  "overall_status": "not_great",
  "symptoms": [
    {
      "category": "other",
      "pattern": "free_text",
      "free_text": "I feel off and weird, kind of spacey, hard to explain."
    }
  ]
}
''';
