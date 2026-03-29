---
name: vitalpet-slm-layer
description: >
  Use when working on anything in lib/features/slm/ — the SLM client, question sequencer,
  medical content filter, baseline tracker, rule-based fallback, or narrative generator.
  Also use when tuning config/slm_prompt.txt, config/symptom_taxonomy.json, or
  config/medical_filter_patterns.json. Covers the full on-device AI inference pipeline.
---

# VitalPet SLM Layer

## Stack
- **Package**: `flutter_gemma` (pub.dev) → wraps MediaPipe LLM Inference API
- **Model**: `gemma-3n-E2B-it-int4.task` — downloaded at first launch, stored in app-private storage
- **Runtime**: MediaPipe on Neural Engine (iOS A12+) or Snapdragon NPU (Android)
- **Timeout**: 3 000 ms — enforced via `Future.timeout()`; on `TimeoutException`, use `RuleBasedFallback`

## Files you are likely working with
```
lib/features/slm/
├── slm_client.dart             # flutter_gemma wrapper, 3s timeout, SLMTimeoutException
├── question_sequencer.dart     # builds Dart context object → calls SLMClient → parses output
├── medical_content_filter.dart # post-processing filter — MANDATORY before any SLM display
├── baseline_tracker.dart       # 14-day rolling mean/stddev, 1.5 SD deviation detection
├── rule_based_fallback.dart    # cold-start (days 1–7) deterministic question order
└── narrative_generator.dart    # separate SLM call for handoff PDF headline + context

config/
├── slm_prompt.txt              # system prompt (edit here — not in Dart code)
├── symptom_taxonomy.json       # question domains
├── cold_start_rules.json       # per-condition fallback sequences
└── medical_filter_patterns.json
```

## SLMClient usage
```dart
// lib/features/slm/slm_client.dart
final class SLMClient {
  static const _timeout = Duration(milliseconds: 3000);

  /// Throws [SLMTimeoutException] if inference exceeds 3 seconds.
  Future<SLMOutput> generateQuestions(SLMContext context) async {
    final prompt = _buildPrompt(context);
    final raw = await FlutterGemma.instance
        .getResponseAsync(prompt)
        .timeout(_timeout, onTimeout: () => throw SLMTimeoutException());
    return _parseOutput(raw); // validates against SLMOutput schema
  }
}
```

## SLMOutput schema (always validate — throw if malformed, use fallback)
```dart
class SLMOutput {
  final List<SLMQuestion> questions;
  final String reasoning; // NEVER show to user — dev/debug only

  // questions contains 3–5 items for Mode 2, variable for Mode 3
}

class SLMQuestion {
  final String id;
  final SymptomDomain domain; // from symptom_taxonomy.json
  final QuestionType type;    // binary | slider | bodyMap | text
  final String prompt;        // displayed to user — MUST pass MedicalContentFilter
  final List<String>? options; // for binary type only
}
```

## Context fed to the model
```dart
class SLMContext {
  final int wellnessScore;
  final CheckInMode mode;
  final List<CheckInSummary> recentCheckins; // last 7 days
  final BaselineStats baselineStats;          // 14-day means
  final HealthSnapshot? healthSnapshot;       // optional
  final String? conditionFocus;               // from onboarding
  final String? streakFreezeReason;           // if today follows a freeze
}
```

## Medical content filter — non-negotiable
```dart
// EVERY SLM-generated string shown to the user MUST go through this:
final result = MedicalContentFilter.filter(rawSLMOutput);
if (!result.safe) {
  await auditLogDao.append(AuditEvent.filterTrigger(
    payloadHash: sha256(rawSLMOutput),
  ));
}
// Use result.text — NEVER rawSLMOutput directly
```

## Baseline tracker
- Runs as a post-transaction callback after every `CheckInDao.insertCheckIn()`
- Computes 14-day rolling mean + stddev per metric: `wellness`, `sleep_hours`, `steps`
- Triggers `DeviationAlert` when a metric is >1.5 SD below mean for 3 consecutive days
- Alert is written to `pet_state.pendingAlertJson` — home screen polls this on mount

## Narrative generator (handoff — separate SLM call)
- Receives a de-identified `NarrativeContext` (no names, no device IDs)
- Returns 3 parts: bolded headline sentence, context paragraph, "Questions to raise" list
- Output MUST pass `MedicalContentFilter` even for the handoff narrative
- Load system prompt from `config/slm_prompt.txt` at app startup via `rootBundle.loadString()`

## Cold start fallback
- Days 1–7: always use `RuleBasedFallback.getQuestions(context)` — ignore SLM output
- Fallback loads from `config/cold_start_rules.json` keyed on `conditionFocus`
- Default order: `pain → fatigue → sleep → appetite → mood`

## flutter_gemma initialisation (in main.dart)
```dart
await FlutterGemma.initialize();
final modelManager = FlutterGemma.instance.modelManager;
// Model is NOT bundled — downloaded on first launch:
if (!await modelManager.isModelInstalled('gemma-3n-E2B-it-int4.task')) {
  await modelManager.installModel(
    modelType: ModelType.gemmaIt,
  ).fromNetwork(
    'https://huggingface.co/google/gemma-3n-E2B-it-litert-preview/resolve/main/gemma-3n-E2B-it-int4.task',
    token: const String.fromEnvironment('HF_TOKEN'),
    // Pass at build time: flutter run --dart-define=HF_TOKEN=hf_your_token_here
    // NEVER hardcode the token. NEVER commit it to git.
  ).install();
}
```

## iOS memory constraint — important
The gemma-3n-E2B-it-int4.task file is ~3.1 GB. iOS enforces a per-app
memory limit that is lower than the device's total RAM. On devices with
less than 8 GB RAM this will crash with:
  Cannot allocate memory [type.googleapis.com/mediapipe.StatusList]

If this crash occurs, switch to the smaller Gemma 3 1B model instead:
  URL: https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1B-IT-int4.task
  modelType: ModelType.gemmaIt
  Size: ~0.7 GB — fits comfortably within iOS memory limits
  Trade-off: lower quality responses but reliable on all modern iPhones

To switch models, change both the URL and filename in the installModel call.
The rest of the SLM pipeline (MedicalContentFilter, RuleBasedFallback,
timeout handling) is unchanged.

## Testing
```dart
// All SLM tests mock SLMClient — never call flutter_gemma in unit tests
final mockClient = MockSLMClient();
when(() => mockClient.generateQuestions(any())).thenAnswer((_) async => testOutput);

// Test MedicalContentFilter with known blocked phrases:
test('blocks diagnostic claim', () {
  final result = MedicalContentFilter.filter('You have fibromyalgia.');
  expect(result.safe, isFalse);
  expect(result.text, equals(MedicalContentFilter.safeFallback));
});
```
