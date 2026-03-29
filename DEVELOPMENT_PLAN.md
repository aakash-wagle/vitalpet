# VitalPet — Development Plan

Each phase is a self-contained unit of work. Each sprint is a single Cursor chat. Start the chat with the provided prompt, then continue yourself based on Cursor's output. Never carry implementation work from one sprint into another chat — start fresh each time.

---

## Phase 0 — Scaffold & Tooling

**Goal:** Working Flutter project that compiles, with all dependencies, empty feature stubs, and the drift schema generated. No logic yet — just structure.

**Duration estimate:** 2–3 hours  
**Dependencies:** None

### Sprint 0.1 — Project scaffold

**What gets built:** `pubspec.yaml`, `analysis_options.yaml`, `lib/main.dart`, all empty feature directories, empty stub files for every `.dart` file listed in `REPO_STRUCTURE.md`, `assets/config/` files with placeholder content.

**Cursor prompt:**

```
Read REPO_STRUCTURE.md in full. Then:

PREREQUISITE CHECK — do this before anything else:
1. Run: flutter channel
   If the output does not show "master", run:
   flutter channel master && flutter upgrade
2. Run: flutter config --enable-native-assets
3. Confirm both completed without error before proceeding.
4. Add connectivity_plus: ^6.0.0 to pubspec.yaml under dependencies.

1. Create pubspec.yaml with these exact dependencies:
   flutter_riverpod: ^3.0.0, riverpod_annotation: ^3.0.0,
   go_router: ^14.0.0, drift: ^2.22.0, sqlcipher_flutter_libs: ^0.8.0,
   drift_flutter: ^0.2.0, flutter_gemma: ^2.0.0,
   confetti: ^0.7.0, health: ^12.0.0, pdf: ^3.11.0, printing: ^5.13.0,
   flutter_local_notifications: ^18.0.0, home_widget: ^0.5.0,
   flutter_secure_storage: ^9.2.0, freezed_annotation: ^2.4.0,
   json_annotation: ^4.9.0, flutter_svg: ^2.0.0, crypto: ^3.0.0,
   intl: ^0.19.0, connectivity_plus: ^6.0.0
   dev: build_runner, riverpod_generator, freezed, drift_dev, json_serializable, mocktail

2. Create analysis_options.yaml with strict linting (include: package:flutter_lints/flutter.yaml, prefer_final_locals, avoid_print).

3. Create lib/main.dart as an empty stub with ProviderScope wrapping a placeholder MyApp widget.

4. Create every directory and empty .dart stub file listed in REPO_STRUCTURE.md. Each stub should have the correct import statements and an empty class or function signature matching the description, but no implementation body.

5. Create assets/config/slm_prompt.txt with this exact content:
   "You are a symptom-tracking assistant. The user has reported feeling unwell (overall_status = not_great).
   Ask structured follow-up questions to capture one or more symptoms from these categories: fever, pain, fatigue, nausea, other.
   For each symptom, capture the fields defined in DATA_TO_COLLECT.md.
   Output ONLY valid JSON. Do not diagnose. Do not recommend medication."

6. Create assets/config/symptom_taxonomy.json with this content:
   {
     "categories": ["fever", "pain", "fatigue", "nausea", "other"],
     "fever_patterns": ["constant", "intermittent", "night_only"],
     "pain_types": ["sharp", "dull", "throbbing", "burning", "cramping", "aching"],
     "pain_patterns": ["constant", "comes_and_goes", "worsening", "improving"],
     "pain_triggers": ["movement", "eating", "breathing", "touch", "none"],
     "fatigue_scope": ["functional", "wiped_out", "debilitating"],
     "fatigue_patterns": ["morning_only", "afternoon_crash", "all_day", "post_exertion"],
     "nausea_patterns": ["constant", "after_eating", "morning", "wave_like"],
     "dehydration_signs": ["dry_mouth", "dark_urine", "dizziness"],
     "body_regions": ["head", "chest", "abdomen", "upper_limb_l", "upper_limb_r", "lower_limb_l", "lower_limb_r", "back"]
   }

7. Create assets/config/cold_start_rules.json with this content:
   {
     "default": ["pain", "fatigue", "fever", "nausea"],
     "chronic_pain": ["pain", "fatigue", "fever", "nausea"],
     "post_surgery": ["pain", "fever", "fatigue", "nausea"],
     "mental_health": ["fatigue", "nausea", "pain", "fever"],
     "general_wellness": ["pain", "fatigue", "fever", "nausea"]
   }

8. Create assets/config/medical_filter_patterns.json as {"patterns":["diagnose","you have","prescription","take this"]}
9. Create demo/seed_data.json as an empty array: []
10. Create test/helpers/test_database.dart as an empty stub.
11. Create scripts/audit_deps.sh that greps pubspec.yaml for firebase_analytics, amplitude, mixpanel, segment and exits 1 if found.

After creating all files, run: flutter pub get
Report which files were created and the result of flutter pub get.

```

---

### Sprint 0.2 — Database schema and code generation

**What gets built:** drift tables, DAOs, migrations, encryption service, audit log DAO — all generated and compiling.

**Cursor prompt:**

```
We are building VitalPet, a Flutter app. The database layer uses drift 2.x + sqlcipher_flutter_libs.

Read these files before writing any code:
- REPO_STRUCTURE.md (for file locations)
- lib/core/database/app_database.dart (current stub)
- .cursor/rules/05-data-layer.mdc (drift schema and conventions)

Implement the following — no presentation layer, no business logic, data layer only:

Step 0 — Create ios/Podfile (REQUIRED for flutter_gemma on iOS):

Create the file ios/Podfile with exactly this content:

  platform :ios, '16.0'

  target 'Runner' do
    use_frameworks!
    pod 'MediaPipeTasksGenAI', '~> 0.10.24'
    pod 'MediaPipeTasksGenAIC', '~> 0.10.24'
  end

Then run:
  cd ios && pod install && cd ..

Confirm pod install succeeded and report the installed pod versions.
Only proceed to step 1 (drift schema) after pod install succeeds.

1. lib/core/database/app_database.dart — implement all 6 drift Table classes (CheckIns, PetStateTable, BaselineStats, AuditLog, SlmContextCache, PetArchive) exactly as specified in .cursor/rules/05-data-layer.mdc. Add @DriftDatabase annotation with schemaVersion: 1 and MigrationStrategy(onCreate: (m) => m.createAll()).

2. lib/core/encryption/encryption_service.dart — implement getOrCreateKey() and destroyKey() using flutter_secure_storage with IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device).

3. lib/core/audit/audit_log_dao.dart — implement AuditLogDao with append() and appendInTransaction() only. Include an AuditEvent class with named constructors: checkinWrite, amendment, filterTrigger, handoffExport, dataExport, deleteInitiated.

4. lib/core/database/baseline_dao.dart — implement upsertBaseline, getBaseline, getAllBaselines, upsertContextCache, getContextCache.

5. lib/features/check_in/data/check_in_dao.dart — implement insertCheckIn, findByDateRange, findLatest, amendCheckIn, getStreakData.

6. lib/features/pet/data/pet_dao.dart — implement getPetState, updatePetState, deletePetState.

7. lib/features/pet/data/pet_archive_dao.dart — implement insertArchive, getArchive.

8. lib/core/database/migrations/migration_v1.dart — onCreate only.

After implementing, run:
dart run build_runner build --delete-conflicting-outputs

Then run: flutter analyze --no-pub
Fix any errors. Report the final analyze result.

```

---

### Sprint 0.2b — Check-in schema rewrite

**What gets built:** The `CheckIns` table and its flat `answersJson` field are replaced with a normalised symptom schema. New tables: `CheckInSymptoms`, `SymptomFever`, `SymptomPain`, `SymptomFatigue`, `SymptomNausea`, `SymptomOther`, `CheckInSubjective`. New DAO: `SymptomDao`.

**Dependencies:** Sprint 0.2 complete (existing DB compiles but has no data).

**Cursor prompt:**

```
We are building VitalPet. Sprint 0.2 (database scaffold) is complete but the
CheckIns table is being replaced. There is no existing data — breaking changes
are intentional. Rewrite the schema from scratch; do not preserve any fields
from the current CheckIns table that are not listed below.

Read before writing any code:
- REPO_STRUCTURE.md
- lib/core/database/app_database.dart (current schema — replace, do not extend)
- DATA_TO_COLLECT.md (authoritative source for all field names and enum values)

Implement the following — data layer only. No domain logic, no UI, no Riverpod providers.

1. Replace CheckIns table in app_database.dart.

   Remove the current CheckIns definition entirely and replace with:

   class CheckIns extends Table {
     TextColumn get id => text()();
     TextColumn get utcDate => text()();
     TextColumn get localDate => text()();
     IntColumn get wellnessScore => integer()();
     // overall_status: 'great' | 'not_great' — derived from wellnessScore at query time,
     // not stored as a separate column (score <=6 = not_great, >=7 = great)
     IntColumn get mode => integer()();
     RealColumn get depthScore => real().withDefault(const Constant(0.0))();
     BoolColumn get isPartial => boolean().withDefault(const Constant(false))();
     TextColumn get amendedAt => text().nullable()();
     TextColumn get createdAt => text()();

     @override
     Set<Column> get primaryKey => {id};
   }

   Note: answersJson is removed entirely. Structured data lives in the tables below.

2. Add new tables to app_database.dart.

   CheckInSymptoms — one row per symptom per check-in session:
   class CheckInSymptoms extends Table {
     TextColumn get id => text()();
     TextColumn get checkInId => text().references(CheckIns, #id)();
     TextColumn get category => text()(); // 'fever'|'pain'|'fatigue'|'nausea'|'other'
     IntColumn get onsetDay => integer().nullable()(); // computed from history after insert — never asked
     TextColumn get pattern => text().nullable()(); // category-specific enum value as string

     @override
     Set<Column> get primaryKey => {id};
   }

   SymptomFever — one row per fever symptom, FK → CheckInSymptoms.id:
   class SymptomFever extends Table {
     TextColumn get symptomId => text().references(CheckInSymptoms, #id)();
     RealColumn get temperature => real().nullable()();
     TextColumn get unit => text().nullable()(); // 'C'|'F'
     TextColumn get method => text().nullable()(); // 'oral'|'ear'|'forehead'|'other'
     BoolColumn get skipped => boolean().withDefault(const Constant(false))();
     // skipped=true means user has no thermometer — distinct from a null temperature

     @override
     Set<Column> get primaryKey => {symptomId};
   }

   SymptomPain — one row per pain symptom, FK → CheckInSymptoms.id:
   class SymptomPain extends Table {
     TextColumn get symptomId => text().references(CheckInSymptoms, #id)();
     TextColumn get regionsJson => text()(); // JSON array of body_region strings
     TextColumn get type => text()(); // 'sharp'|'dull'|'throbbing'|'burning'|'cramping'|'aching'
     TextColumn get triggersJson => text().nullable()(); // JSON array: 'movement'|'eating'|'breathing'|'touch'|'none'

     @override
     Set<Column> get primaryKey => {symptomId};
   }

   SymptomFatigue — one row per fatigue symptom, FK → CheckInSymptoms.id:
   class SymptomFatigue extends Table {
     TextColumn get symptomId => text().references(CheckInSymptoms, #id)();
     TextColumn get scope => text()(); // 'functional'|'wiped_out'|'debilitating'
     BoolColumn get blocksDaily => boolean()();

     @override
     Set<Column> get primaryKey => {symptomId};
   }

   SymptomNausea — one row per nausea symptom, FK → CheckInSymptoms.id:
   class SymptomNausea extends Table {
     TextColumn get symptomId => text().references(CheckInSymptoms, #id)();
     BoolColumn get vomiting => boolean()();
     TextColumn get vomitFreq => text().nullable()(); // 'once'|'few_times'|'persistent' — null if vomiting=false
     TextColumn get appetite => text()(); // 'normal'|'reduced'|'none'
     TextColumn get dehydrationSignsJson => text().nullable()(); // JSON array: 'dry_mouth'|'dark_urine'|'dizziness'

     @override
     Set<Column> get primaryKey => {symptomId};
   }

   SymptomOther — one row per other symptom, FK → CheckInSymptoms.id:
   class SymptomOther extends Table {
     TextColumn get symptomId => text().references(CheckInSymptoms, #id)();
     TextColumn get freeText => text()(); // mandatory for this category
     TextColumn get extractedDetailsJson => text().nullable()(); // best-effort SLM parse

     @override
     Set<Column> get primaryKey => {symptomId};
   }

   CheckInSubjective — one row per check-in, all fields optional, FK → CheckIns.id:
   class CheckInSubjective extends Table {
     TextColumn get checkInId => text().references(CheckIns, #id)();
     TextColumn get freeNotes => text().nullable()();
     TextColumn get slmTagsJson => text().nullable()(); // JSON array of keyword strings
     TextColumn get followUpExchangesJson => text().nullable()();
     // JSON array of { role: 'user'|'assistant', content: string, timestamp: ISO8601 }

     @override
     Set<Column> get primaryKey => {checkInId};
   }

3. Update the @DriftDatabase annotation to include all new tables:

   @DriftDatabase(tables: [
     CheckIns,
     CheckInSymptoms,
     SymptomFever,
     SymptomPain,
     SymptomFatigue,
     SymptomNausea,
     SymptomOther,
     CheckInSubjective,
     PetStateTable,
     BaselineStats,
     AuditLog,
     SlmContextCache,
     PetArchive,
   ])

   Keep schemaVersion: 1 — this is a clean install rewrite, not an upgrade.

4. Update MigrationStrategy — onCreate only:

   @override
   MigrationStrategy get migration => MigrationStrategy(
     onCreate: (m) async {
       await m.createAll();
     },
   );

   No onUpgrade needed — there is no existing data to migrate.

5. Rewrite lib/core/database/migrations/migration_v1.dart to reflect the new schema.
   onCreate only — no upgrade paths.

6. Create lib/features/check_in/data/symptom_dao.dart.

   Implement SymptomDao with these methods only:
   - insertSymptom(CheckInSymptomsCompanion) → Future<void>
   - insertFever(SymptomFeverCompanion) → Future<void>
   - insertPain(SymptomPainCompanion) → Future<void>
   - insertFatigue(SymptomFatigueCompanion) → Future<void>
   - insertNausea(SymptomNauseaCompanion) → Future<void>
   - insertOther(SymptomOtherCompanion) → Future<void>
   - insertSubjective(CheckInSubjectiveCompanion) → Future<void>
   - getSymptomsForCheckIn(String checkInId) → Future<List<CheckInSymptom>>
   - getFullCheckIn(String checkInId) — fetches the base CheckInSymptoms rows then
     joins each detail table in a single drift transaction; returns a plain Dart
     data class (FullCheckIn) grouping all results.

   Register SymptomDao in AppDatabase with @DriftAccessor(tables: [...]).

7. Update lib/features/check_in/data/check_in_dao.dart.

   Remove any reference to answersJson. All other methods (insertCheckIn,
   findByDateRange, findLatest, amendCheckIn, getStreakData) stay — ensure their
   CheckInsCompanion usage no longer references the removed field.

8. After implementing, run:
   dart run build_runner build --delete-conflicting-outputs

   Then run: flutter analyze --no-pub
   Fix any errors. Report the final analyze result and confirm app_database.g.dart
   was regenerated.

Do not modify PetStateTable, BaselineStats, AuditLog, SlmContextCache, or PetArchive.
Do not implement any domain logic, UI, or Riverpod providers — data layer only.
Do not add any Firebase, analytics, or remote dependencies.

```

---

### Sprint 0.2c — Schema migration: update all old-schema references in the codebase

**What gets built:** Every file generated or written during Sprint 0.2 that references `answersJson`, the old flat symptom domain list, or `QuestionAnswer {domain, type, value}` is updated to match the new schema from Sprint 0.2b.

**Dependencies:** Sprint 0.2b complete and compiling.

**Cursor prompt:**

```
We are building VitalPet. Sprint 0.2b introduced a new normalised symptom schema.
The schema change was: answersJson removed from CheckIns; structured symptom data
now lives in CheckInSymptoms + SymptomFever/Pain/Fatigue/Nausea/Other + CheckInSubjective.

Sprint 0.2 generated code that still references the old schema. This sprint finds
and fixes every such reference. No new features — only correctness fixes.

Read before making any changes:
- DATA_TO_COLLECT.md (authoritative field names and enum values)
- lib/core/database/app_database.dart (current correct schema)
- lib/features/check_in/data/symptom_dao.dart (new DAO)
- assets/config/symptom_taxonomy.json (current correct category list)

STEP 1 — Scan for stale answersJson references.

Run this command and report every match:
  grep -rn "answersJson\|answers_json" lib/ test/ --include="*.dart"

For each match:
- If in a Companion object or table reference: remove the field entirely.
- If in a method that reads check-in data for processing: replace with a call to
  SymptomDao.getFullCheckIn(checkInId) which returns the structured FullCheckIn object.
- If in a SHA-256 hash for audit logging: hash the structured symptom data as JSON
  instead: jsonEncode(fullCheckIn.toJson()).

STEP 2 — Scan for stale flat symptom domain references.

Run this command and report every match:
  grep -rn "SymptomDomain\|symptom_domains\|'pain'\|'fatigue'\|'sleep'\|'appetite'\|'nausea'\|'mood'\|'cognitive'\|'medication'" lib/ test/ assets/config/ --include="*.dart" --include="*.json"

For each match:
- In Dart enum or class definitions: replace SymptomDomain with SymptomCategory
  using values: fever, pain, fatigue, nausea, other — per DATA_TO_COLLECT.md.
  Remove: sleep, appetite, mood, cognitive, medication (these are not top-level
  categories in the new schema).
- In assets/config/symptom_taxonomy.json: this was already updated in Sprint 0.1
  with the correct category list. Verify it matches; fix if it does not.
- In assets/config/cold_start_rules.json: verify the arrays contain only values
  from [fever, pain, fatigue, nausea, other]. Fix any that use old domain names.

STEP 3 — Scan for stale QuestionAnswer shape.

Run this command and report every match:
  grep -rn "QuestionAnswer\|question_answer" lib/ test/ --include="*.dart"

QuestionAnswer is defined in lib/features/check_in/domain/question_answer.dart.
The OLD shape was: QuestionAnswer {domain, type, value} where domain was a
SymptomDomain string.

Update the shape to:
  @freezed
  class QuestionAnswer with _$QuestionAnswer {
    const factory QuestionAnswer({
      required SymptomCategory category,  // fever|pain|fatigue|nausea|other
      required String fieldName,          // the specific field being answered, e.g. 'type', 'scope', 'temperature'
      required dynamic value,             // the answer value — bool, String, double, or List<String>
    }) = _QuestionAnswer;
  }

Update every call site that constructs or pattern-matches a QuestionAnswer to use
the new shape.

STEP 4 — Scan for stale CheckInSessionState shape.

Run this command and report every match:
  grep -rn "CheckInSessionState\|check_in_session_state\|collectingAnswers" lib/ test/ --include="*.dart"

In lib/features/check_in/domain/check_in_session_state.dart, the
collectingAnswers variant holds a list of answers. Ensure it is typed as:
  collectingAnswers({
    required CheckInMode mode,
    required List<SLMQuestion> questions,
    required List<QuestionAnswer> answers,
    required SymptomCategory? currentCategory, // which category is being collected right now
  })

STEP 5 — Scan for stale SLMContext or SLMOutput shape.

Run this command and report every match:
  grep -rn "SLMContext\|slm_context\|SLMOutput\|slm_output\|recentCheckins\|recent_checkins" lib/ test/ --include="*.dart"

SLMContext feeds the SLM. The old shape assumed recentCheckins was a flat list
of CheckIn objects with answersJson. Update the shape so recentCheckins is a
list of FullCheckIn objects (from SymptomDao.getFullCheckIn), which carry the
structured symptom data instead of raw JSON.

Specifically in lib/features/slm/slm_context.dart:
  @freezed
  class SLMContext with _$SLMContext {
    const factory SLMContext({
      required int wellnessScore,
      required CheckInMode mode,
      required List<FullCheckIn> recentCheckins,  // was List<CheckIn>
      required BaselineStats baselineStats,
      HealthSnapshot? healthSnapshot,
      String? conditionFocus,
      String? streakFreezeReason,
    }) = _SLMContext;
  }

STEP 6 — Scan for stale BaselineTracker signature.

Run this command and report every match:
  grep -rn "computeBaselines\|BaselineTracker" lib/ test/ --include="*.dart"

In lib/features/slm/baseline_tracker.dart, the old signature was:
  computeBaselines(List<CheckIn> recent)

Update to:
  computeBaselines(List<FullCheckIn> recent)

The baseline metrics that can be computed from the new schema are:
- wellness_score: from CheckIn.wellnessScore
- pain_frequency: proportion of sessions with a pain symptom
- fatigue_frequency: proportion of sessions with a fatigue symptom
- fever_frequency: proportion of sessions with a fever symptom
- nausea_frequency: proportion of sessions with a nausea symptom
Update the method body to derive these metrics from FullCheckIn.symptoms
rather than from answersJson parsing.

STEP 7 — Verify isValidCheckin signature.

Run this command and report every match:
  grep -rn "isValidCheckin" lib/ test/ --include="*.dart"

In lib/features/pet/domain/streak_manager.dart, the old signature was:
  isValidCheckin(int wellnessScore, int answersCount)

The answersCount parameter counted flat JSON answers. Replace with:
  isValidCheckin(int wellnessScore, int symptomsCollected)

Where symptomsCollected is the count of CheckInSymptoms rows inserted for
this session. The validity rule is unchanged: at least 1 symptom collected
OR mode == CheckInMode.quick (wellnessScore >= 7).

STEP 8 — Run final checks.

  dart run build_runner build --delete-conflicting-outputs
  flutter analyze --no-pub
  flutter test

Fix any remaining errors. Report a list of every file changed and the
final flutter analyze result. There should be zero errors.

```

---

## Phase 1 — Domain Logic (no UI)

**Goal:** All pure Dart business logic implemented and tested. Nothing shown on screen yet.

**Duration estimate:** 3–4 hours  
**Dependencies:** Phase 0 complete (all three Sprint 0.2 sub-sprints done), DB schema generated and codebase consistent.

### Sprint 1.1 — Check-in domain

**What gets built:** `ModeSelector`, `VitalityCalculator`, `StreakManager`, `MilestoneDetector`, `CheckInSessionState`, and their unit tests.

**Cursor prompt:**

```
We are building VitalPet. Phase 0 (scaffold + DB schema + schema migration) is complete.

Read before writing any code:
- .cursor/rules/03-feature-logic.mdc
- .cursor/skills/check-in-engine/SKILL.md
- .cursor/skills/pet-engine/SKILL.md
- DATA_TO_COLLECT.md (symptom categories and fields)

Implement pure Dart domain logic only — no Flutter widgets, no screens, no Riverpod providers yet.

1. lib/features/check_in/domain/mode_selector.dart
   - selectMode(int score) → CheckInMode
   - CheckInMode enum: quick, guided, companion
   - Boundaries: score <=3 → companion, <=6 → guided, else quick

2. lib/features/pet/domain/vitality_calculator.dart
   - calculateVitality({streak, checkInDepthScore, consecutiveMissedDays, isVulnerabilityFrozen}) → int
   - Implement graduated penalty (day 1: -8, day 2: -10, day 3+: -12), base 60, streak bonus capped at +30, depth bonus 0–10

3. lib/features/pet/domain/streak_manager.dart
   - activateFreeze(String reason) — sets freeze fields in PetState
   - isValidCheckin(int wellnessScore, int symptomsCollected) → bool
     Rule: returns true if (mode == quick AND wellnessScore >= 7) OR symptomsCollected >= 1
   - All calculations UTC-date keyed

4. lib/features/pet/domain/milestone_detector.dart
   - detectMilestone(int streak) → MilestoneType? — checks 7, 14, 30, 90

5. lib/features/check_in/domain/check_in_session_state.dart
   - freezed union: idle | collectingScore | collectingAnswers | partial | completing
   - collectingAnswers variant fields:
       required CheckInMode mode,
       required List<SLMQuestion> questions,
       required List<QuestionAnswer> answers,
       required SymptomCategory? currentCategory

6. lib/features/check_in/domain/question_answer.dart
   - freezed: QuestionAnswer {required SymptomCategory category, required String fieldName, required dynamic value}
   - category: one of fever|pain|fatigue|nausea|other
   - fieldName: the specific field being captured, e.g. 'type', 'scope', 'temperature', 'regions'
   - value: bool, String, double, or List<String> depending on the field

7. lib/core/constants/symptom_domains.dart
   - Define SymptomCategory enum: fever, pain, fatigue, nausea, other
   - Remove any pre-existing SymptomDomain enum if present

Then write unit tests for all of the above in test/features/:
- test/features/check_in/mode_selector_test.dart — test score 1, 3, 4, 6, 7, 10
- test/features/pet/vitality_calculator_test.dart — zero streak, max streak, 1/2/3+ missed days, vulnerability freeze, depth bonus
- test/features/pet/streak_manager_test.dart — isValidCheckin: quick mode score 7 with 0 symptoms = valid; not_great with 1 symptom = valid; not_great with 0 symptoms = invalid
- test/features/pet/milestone_detector_test.dart — 7, 14, 30, 90 hit; 8, 15 miss

Run: flutter test test/features/
Report test results. Fix any failures.

```

---

### Sprint 1.2 — SLM domain

**What gets built:** `SLMClient`, `MedicalContentFilter`, `RuleBasedFallback`, `BaselineTracker`, `QuestionSequencer` stubs, and their unit tests.

**Cursor prompt:**

```
We are building VitalPet. Phase 0 complete, Sprint 1.1 (check-in + pet domain) complete.

Read before writing any code:
- .cursor/rules/03-feature-logic.mdc
- .cursor/skills/slm-layer/SKILL.md
- DATA_TO_COLLECT.md (symptom categories and field names the SLM must ask about)

Implement SLM domain logic only — no screens, no UI.

1. lib/features/slm/slm_client.dart
   - Wraps FlutterGemma.instance.getResponseAsync()
   - 3000ms timeout via Future.timeout — throws SLMTimeoutException on timeout
   - Validates output against SLMOutput schema, throws SLMParseException on malformed JSON

2. lib/features/slm/slm_output.dart and slm_context.dart
   - freezed data classes per .cursor/skills/slm-layer/SKILL.md schema
   - SLMContext.recentCheckins must be List<FullCheckIn> (not List<CheckIn>)
   - SLMQuestion.category must be SymptomCategory (fever|pain|fatigue|nausea|other)
   - SLMQuestion.fieldName identifies the specific field to capture

3. lib/features/slm/medical_content_filter.dart
   - Loads patterns from assets/config/medical_filter_patterns.json via rootBundle at init
   - filter(String raw) → FilterResult
   - FilterResult: {bool safe, String text}
   - Static constant: safeFallback = "I'm here to help you remember — please speak to your doctor."

4. lib/features/slm/rule_based_fallback.dart
   - Loads cold_start_rules.json at init
   - getQuestions(SLMContext context) → List<SLMQuestion>
   - cold_start_rules.json values are SymptomCategory names (fever|pain|fatigue|nausea|other)
   - Uses context.conditionFocus to pick question order; falls back to default order

5. lib/features/slm/baseline_tracker.dart
   - computeBaselines(List<FullCheckIn> recent) → Map<String, BaselineStats>
   - Baseline metrics derived from structured data (not answersJson):
       wellness_score: mean of CheckIn.wellnessScore over recent sessions
       pain_frequency: proportion of sessions with a pain symptom in CheckInSymptoms
       fatigue_frequency: proportion of sessions with a fatigue symptom
       fever_frequency: proportion of sessions with a fever symptom
       nausea_frequency: proportion of sessions with a nausea symptom
   - checkDeviation(String metric, List<double> values, BaselineStats baseline) → DeviationAlert?
   - Trigger: >1.5 SD below mean for 3 consecutive values

Then write tests:
- test/features/slm/medical_content_filter_test.dart — blocked phrases fail, safe content passes, safeFallback is correct string
- test/features/slm/rule_based_fallback_test.dart — correct category order for chronic_pain, post_surgery, default; categories are from SymptomCategory enum only
- test/features/slm/baseline_tracker_test.dart — deviation detected at exactly 3 sessions, not at 2; no alert when within 1.5 SD; test uses FullCheckIn fixtures, not CheckIn with answersJson

Run: flutter test test/features/slm/
Fix any failures. Report results.

```

---

## Phase 2 — Navigation & Shell

**Goal:** App runs on device/simulator with navigation skeleton. No real data — placeholder screens.

**Duration estimate:** 2 hours  
**Dependencies:** Phase 1 complete

### Sprint 2.1 — Router, theme, and app shell

**Cursor prompt:**

```
We are building VitalPet. Phases 0–1 complete. Now build the navigation shell.

Read before writing any code:
- .cursor/rules/00-project-context.mdc
- .cursor/rules/02-flutter-ui.mdc
- lib/presentation/router/app_router.dart (current stub)

Implement:

1. lib/presentation/theme/app_colors.dart — define AppColors with:
   background, surface, primary (#0D7377 teal), primaryLight, accent, danger, warning, success,
   textPrimary, textSecondary, textTertiary — both light and dark variants

2. lib/presentation/theme/app_text_styles.dart — define AppTextStyles with:
   displayLarge, headlineMedium, headlineSmall, bodyLarge, bodyMedium, labelLarge, labelSmall

3. lib/presentation/theme/app_theme.dart — ThemeData light() and dark() using above tokens

4. lib/presentation/router/app_router.dart — GoRouter with these routes:
   / → HomeScreen (placeholder)
   /onboarding → OnboardingScreen (placeholder)
   /checkin → CheckInScreen (placeholder)
   /handoff → HandoffScreen (placeholder)
   /settings → SettingsScreen (placeholder)
   Deep-link scheme: vitalpet://checkin → /checkin

5. lib/main.dart — implement fully:
   - ProviderScope wrapping MaterialApp.router
   - FlutterGemma.initialize() before runApp
   - Open encrypted drift DB via EncryptionService.getOrCreateKey()
   - Register DB as a Riverpod provider
   - AppLifecycleState listener for screen blur (overlay a ColoredBox on inactive/paused)

6. Each placeholder screen: just a Scaffold with an AppBar title and a centered Text('Coming soon'). No logic.

Run: flutter run -d ios
Report that the app launches, navigates between placeholder screens, and deep-link works.
Fix any errors. Run: flutter analyze --no-pub

```

---

## Phase 3 — Pet Engine & Home Screen

**Goal:** The pet lives on screen, animated with simple PNGs (slight rocking), streak visible, pet can die.

**Duration estimate:** 3–4 hours  
**Dependencies:** Phase 2 complete, PNG files in assets/images/pets/

### Sprint 3.1 — Riverpod providers + PetRenderer

**Cursor prompt:**

```
We are building VitalPet. Phases 0–2 complete. Now build the pet engine and home screen.

Read before writing any code:
- .cursor/rules/02-flutter-ui.mdc
- .cursor/rules/03-feature-logic.mdc
- .cursor/skills/pet-engine/SKILL.md

The pet UI uses static PNGs in assets/images/pets/ with simple Flutter animations:
- State changes (vitality, isDead) swap out the PNG asset shown.
- A simple rocking animation is applied continuously using a Flutter Tween or AnimatedBuilder.
- TimeOfDay changes can affect background colors and lighting, independent of the pet PNG.

Implement:

1. lib/features/pet/domain/pet_state.dart — freezed PetState with all fields from drift PetStateTable

2. lib/features/pet/domain/pet_notifier.dart — AsyncNotifier<PetState?>:
   - build(): loads from PetDao
   - recalculateVitality(): calls calculateVitality(), updates DB, checks milestone, checks critical notification trigger
   - triggerDeath(): archives pet, deletes pet_state row, navigates to /death
   - All writes inside db.transaction() with audit log

3. lib/features/pet/domain/widget_data_writer.dart:
   - updateWidgetData(PetState pet, List<int> sparkline) using home_widget package

4. lib/features/pet/presentation/widgets/pet_renderer.dart:
   - Displays a PNG image corresponding to the pet's species and vitality state
   - Wraps the image with an AnimatedBuilder/Tween for a slight, continuous rocking effect
   - Handles disableAnimations: strips the rocking effect leaving a static image
   - accessibilityLabel: "${pet.name} the ${pet.species}, ${pet.stateName}"

5. lib/features/pet/presentation/widgets/streak_badge.dart — displays streak count

6. lib/features/pet/presentation/home_screen.dart — ConsumerWidget:
   - PetRenderer centred
   - StreakBadge
   - DeviationAlertCard (if pendingAlert in pet_state)
   - "Show my doctor" button → /handoff
   - FAB or tap → /checkin

7. lib/features/pet/presentation/death_screen.dart:
   - Greyscale pet image, name in past tense, lifespan days, "Start again" → /onboarding

Run: flutter analyze --no-pub && flutter test test/features/pet/
Report results. Fix any failures.

```

---

## Phase 4 — Check-In Flow

**Goal:** Full working check-in: Mode 1/2/3, SLM inference with fallback, body map, structured symptom collection, completion triggers pet update.

**Duration estimate:** 5–6 hours  
**Dependencies:** Phase 3 complete

### Sprint 4.1 — Check-in screens and session notifier

**Cursor prompt:**

```
We are building VitalPet. Phases 0–3 complete. Now build the full check-in flow.

Read before writing any code:
- .cursor/rules/02-flutter-ui.mdc
- .cursor/rules/03-feature-logic.mdc
- .cursor/skills/check-in-engine/SKILL.md
- .cursor/skills/slm-layer/SKILL.md
- DATA_TO_COLLECT.md (every field the UI must collect per symptom category)

Implement:

1. lib/features/check_in/domain/check_in_engine.dart — CheckInEngine class:
   - startSession(): loads health snapshot via HealthAdapter, initialises session state
   - submitWellnessScore(int score): determines overall_status (score <=6 = not_great, >=7 = great).
     If great (Mode 1): no symptom questions asked.
     If not_great (Mode 2/3): calls SLMClient with 3s timeout, falls back to RuleBasedFallback on SLMTimeoutException.
   - submitAnswer(QuestionAnswer answer): adds to session state; answer.category + answer.fieldName
     identify which symptom table and field to populate on commit.
   - savePartial(): persists partial session to DB with isPartial=true; flushes any complete
     QuestionAnswer groups to SymptomDao as partial rows.
   - completeSession(): atomic db.transaction():
       a. CheckInDao.insertCheckIn(companion) — no answersJson
       b. For each collected symptom: SymptomDao.insertSymptom() + insertFever/Pain/Fatigue/Nausea/Other()
       c. SymptomDao.insertSubjective() if freeNotes or followUpExchanges exist
       d. PetDao.updatePetState()
       e. AuditLogDao.appendInTransaction(CHECKIN_WRITE, payloadHash of symptom IDs)
     Then: recalculateVitality(), updateWidgetData(), check vulnerabilitySafeguard,
           compute onsetDay for each new symptom and update CheckInSymptoms.onsetDay.
   - amendSession(String id): re-inserts updated symptom rows (delete old, insert new),
     sets CheckIns.amendedAt, appends AMENDMENT audit entry.

2. lib/features/check_in/domain/check_in_session_notifier.dart — AsyncNotifier wrapping
   CheckInEngine, one method per engine call.

3. lib/features/check_in/presentation/check_in_screen.dart — ConsumerWidget:
   Watches check_in_session state, renders:
   - CheckInSessionState.idle / collectingScore → WellnessSlider
   - If wellnessScore >= 7: show Mode 1 completion immediately (no symptom questions)
   - If wellnessScore <= 6: show CheckInSessionState.collectingAnswers →
       QuestionCard list (one field at a time within the current category)
   - Mode 3: CompanionBubble instead of QuestionCard
   - "Save and come back" button always visible in Mode 2/3
   - "I'm done" always visible in Mode 3

4. lib/features/check_in/presentation/widgets/wellness_slider.dart:
   - Slider from 1–10, step 1
   - HapticFeedback.lightImpact() on each integer (iOS only)
   - Semantics(slider: true, value: '$score', min: '1', max: '10')

5. lib/features/check_in/presentation/widgets/question_card.dart:
   - Renders a single field question for the current symptom category
   - Input types: binary yes/no buttons, 1–5 or enumerated slider, body map tap, free text
   - Which input type to render is determined by the QuestionAnswer.fieldName:
       'temperature' → numeric text input
       'skipped' → binary yes/no
       'regions' → body map widget
       'type', 'scope', 'appetite', 'vomitFreq', 'method', 'pattern' → enumerated choice buttons
       'blocksDaily', 'vomiting' → binary yes/no
       'triggersJson', 'dehydrationSignsJson' → multi-select chips
       'freeText' → free text input
   - Each rendered string from SLM must go through MedicalContentFilter before display

6. lib/features/check_in/presentation/widgets/body_map.dart:
   - flutter_svg silhouette, tap regions with min 44×44 targets
   - Max 3 selected, deselects oldest on 4th tap
   - Selected regions stored as List<String> matching body_regions in symptom_taxonomy.json

7. lib/features/check_in/presentation/widgets/companion_bubble.dart:
   - Speech bubble styled widget, attributed to pet
   - Text relies on a "typing out" animated effect
   - Text is always MedicalContentFilter.filter(rawText).text

On completion: pet reaction animation triggers (a single happy bounce of the PNG image), confetti if milestone.

Run: flutter analyze --no-pub && flutter test test/features/check_in/
Fix any errors. Report results.

```

---

## Phase 5 — Onboarding

**Goal:** Complete onboarding flow: species selection, pet naming, loss mechanic explainer, notification permission, first check-in trigger.

**Duration estimate:** 2–3 hours  
**Dependencies:** Phase 4 complete

### Sprint 5.1 — Onboarding screens

**Cursor prompt:**

```
We are building VitalPet. Phases 0–4 complete. Now build the onboarding flow.

Read before writing any code:
- .cursor/rules/02-flutter-ui.mdc

The onboarding covers FR-OB-01 through FR-OB-09 from the SRS. Implement:

1. lib/features/onboarding/onboarding_notifier.dart — StateNotifier<OnboardingState>:
   - OnboardingState: {species, petName, conditionFocus, step}
   - selectSpecies, setPetName, setConditionFocus, advance, complete
   - complete(): creates PetState row in DB with selected species + name, vitality=60, streak=0

2. lib/features/onboarding/presentation/onboarding_screen.dart — PageView with 3 pages:
   Page 1: "You forget how you felt. Your doctor guesses." + Skip button
   Page 2: PetSelector (4 species grid — cat, dog, rabbit, dragon)
   Page 3: Pet name input (2–20 chars) + condition focus dropdown (chronic_pain, post_surgery, mental_health, general_wellness, other)

3. lib/features/onboarding/presentation/widgets/pet_selector.dart:
   - 2x2 grid of species cards
   - Each shows static PNG + species name
   - Selected state indicated by border (not colour alone)

4. lib/features/onboarding/presentation/widgets/pet_name_input.dart:
   - TextField, 2–20 chars, validates on change
   - Shows character count

After species + name confirmed:
   - Show vulnerability safeguard screen (one-time): "If you're going through a hard time, you can always pause your streak without penalty."
   - Request notification permission via flutter_local_notifications
   - Navigate to /checkin for first check-in

After onboarding complete, check that GoRouter guard redirects to /onboarding on first launch (no pet in DB) and to / on subsequent launches.

Run: flutter analyze --no-pub
Test manually that full onboarding flow runs and pet appears on home screen after completion.

```

---

## Phase 6 — Doctor Handoff

**Goal:** Complete PDF handoff: narrative, trend chart, heatmap, health correlation, share sheet.

**Duration estimate:** 3–4 hours  
**Dependencies:** Phases 1–5 complete (domain logic, check-in data exists in DB)

### Sprint 6.1 — Handoff PDF generation

**Cursor prompt:**

```
We are building VitalPet. Phases 0–5 complete.

Read before writing any code:
- .cursor/skills/handoff/SKILL.md
- .cursor/rules/01-security-hipaa.mdc (de-identification rules)
- DATA_TO_COLLECT.md (to understand what symptom data is available for the narrative)

Implement the doctor handoff using the pdf 3.x + printing 5.x packages (pure Dart, no native bridge).

1. lib/features/handoff/handoff_generator.dart — generateAndShare(DateRange, WidgetRef):
   - Read check-ins from CheckInDao.findByDateRange
   - For each check-in, call SymptomDao.getFullCheckIn(id) to get structured symptom data
   - Optionally fetch health summary via HealthAdapter
   - Call NarrativeGenerator.generate(NarrativeContext) — de-identified, no user name
   - Build pw.Document with 2–3 pages (see SKILL.md structure)
   - Write HANDOFF_EXPORT audit entry before calling Printing.sharePdf()
   - Use Printing.sharePdf(bytes: await pdf.save(), filename: '...')

2. lib/features/handoff/chart_data_builder.dart:
   - buildTrendChart: List<TrendPoint> with score, date, type (normal|missed|freeze)
   - buildHeatmap: Map<String, int?> of date → score for calendar grid
   - buildSymptomFrequency: Map<SymptomCategory, int> — count of sessions each category appeared

3. PDF page 1:
   - Disclaimer footer on every page (non-removable): "This summary was generated by VitalPet and is not a medical record."
   - Narrative: bolded headline, context paragraph, "Questions to raise"
   - Summary stats: date range, check-in count/total, avg wellness score,
     top 3 symptom categories by frequency (from CheckInSymptoms.category counts)
   - Trend line chart via pw.Chart

4. PDF page 2:
   - Calendar heatmap (6 weeks × 7 days grid, cell colour from wellness score gradient)
   - Notable events list: days with score <=4 OR fever recorded OR 2+ symptom categories in one session

5. PDF page 3 (conditional, if health data available):
   - Dual-axis chart: wellness score vs sleep duration
   - Dual-axis chart: wellness score vs step count

6. NarrativeContext passed to SLM must be de-identified and must summarise
   symptom data structurally. Include:
   - avgWellnessScore, trendDirection
   - symptomFrequency: Map<SymptomCategory, int>
   - mostFrequentPainRegions: List<String> (from SymptomPain.regionsJson across sessions)
   - fatigueBlockedDailyCount: int (sessions where SymptomFatigue.blocksDaily = true)
   - No patient name, no device ID, no raw free text from SymptomOther or CheckInSubjective

7. lib/features/handoff/presentation/handoff_screen.dart:
   - Date range selector (7d / 30d / 90d)
   - "Generate & Share" button — triggers generateAndShare()
   - Loading state while generating

Run: flutter analyze --no-pub
Test manually: generate a handoff from the demo seed data. Verify PDF opens, shows all pages, disclaimer is present, share sheet appears.

```

---

## Phase 7 — Notifications & Widgets

**Goal:** Push notifications scheduled, home screen widgets showing pet + streak + sparkline.

**Duration estimate:** 3–4 hours  
**Dependencies:** Phase 6 complete

### Sprint 7.1 — Notifications

**Cursor prompt:**

```
We are building VitalPet. Phases 0–6 complete. Now implement notifications.

Read before writing any code:
- .cursor/rules/00-project-context.mdc (notification payload rules — no PHI)

Implement lib/features/notifications/notification_scheduler.dart:

1. schedulePrimary(String petName, int petStateIndex, TimeOfDay reminderTime):
   - Daily at reminderTime
   - Title: "[petName] misses you."
   - Body: "How are you feeling today?"
   - Payload: JSON {petState: petStateIndex} — no wellness scores, no symptoms

2. scheduleSecondary(String petName):
   - Daily at 21:00 local time
   - Only if primary was not acted on (check using flutter_local_notifications pending list)
   - Body: "Last chance — [petName] is waiting for you tonight."

3. scheduleCritical(String petName, int daysMissed):
   - Fires immediately, overrides quiet hours (importance: Importance.max, priority: Priority.max)
   - Body: "[petName] is very unwell. They haven't heard from you in [N] days."
   - Called when vitality < 20

4. scheduleMilestone(String petName, int streakDays):
   - Fires once at current time
   - Body: "You and [petName] have been together for [N] days! They're glowing."

5. cancelAll(): cancels all scheduled notifications (called on pet death)

Then implement lib/features/notifications/pattern_adapter.dart:
   - After 7 days of usage, compares user's actual open times to their reminder setting
   - If user consistently opens 2+ hours before/after reminder → surfaces a suggestion card on home screen
   - Does NOT auto-change the reminder time

Run: flutter analyze --no-pub
Test on device that primary notification fires at set time and critical fires immediately when triggered.

```

---

### Sprint 7.2 — Home screen widgets (native)

**Cursor prompt:**

```
We are building VitalPet. Sprint 7.1 (notifications) complete. Now build the home screen widgets.

Read before writing any code:
- .cursor/rules/04-native-widgets.mdc
- .cursor/skills/native-widgets/SKILL.md

IMPORTANT: This sprint involves native Swift code only. The Flutter side is already done via the
home_widget package. This sprint is ONLY the iOS WidgetKit native target.
Android Glance is OUT OF SCOPE for this MVP — do not implement native/android/widget/.

For iOS (native/ios/VitalPetWidget/):
1. VitalPetWidget.swift — WidgetBundle + Widget configuration, supports .systemSmall and .systemMedium
2. WidgetDataProvider.swift — TimelineProvider reading from UserDefaults(suiteName: "group.com.vitalpet.shared")
3. VitalPetEntryView.swift — SwiftUI views:
   - Small (2×2): pet image (from assets/images/pets/) + streak count + "Check in" widgetURL link
   - Medium (4×2): same + WellnessSparkline
4. WellnessSparkline.swift — SwiftUI Path: 7 bars, height proportional to score (1–10), grey for nil/missed
5. VitalPetWidget.entitlements — App Group: group.com.vitalpet.shared

After implementing native code:
- Open the Xcode project, add the widget extension target, set the App Group entitlement on
  BOTH the main app and widget targets. Verify the widget appears in the home screen widget picker.

Note: The pet images used in widgets are the same static PNGs from assets/images/pets/,
      copied into the widget extension's asset catalog in Xcode.

Document any manual Xcode steps required (entitlements, target membership, etc.).

```

---

## Phase 8 — Settings, Data Management & Calm Mode

**Goal:** Settings screen complete, data export, deletion with 7-day window, Calm Mode toggle.

**Duration estimate:** 2–3 hours  
**Dependencies:** Phases 0–7 complete

### Sprint 8.1 — Settings and data management

**Cursor prompt:**

```
We are building VitalPet. Phases 0–7 complete. Now build settings and data management.

Implement:

1. lib/presentation/screens/settings_screen.dart — Scaffold with ListTile sections:
   - Reminder time picker (shows current time, opens TimeOfDay picker, calls notification_scheduler.schedulePrimary)
   - Calm Mode toggle (switch — calls petNotifier to flip calmMode in DB)
   - Health platform connection toggle (shows health package permission status, opens settings if denied)
   - Export My Data (calls ExportService.exportAllData() → writes JSON to temp file → Share.shareXFiles)
   - Delete All Data (two-step confirmation AlertDialog → calls EncryptionService.destroyKey() after 7-day window)
   - Pet archive ("Your companions") → ListView of pet_archive rows

2. lib/core/database/export_service.dart — exportAllData() → String (JSON):
   - Includes: check_ins, check_in_symptoms, symptom_fever, symptom_pain, symptom_fatigue,
     symptom_nausea, symptom_other, check_in_subjective, pet_state, pet_archive, baseline_stats
   - Excludes: audit_log, slm_context_cache
   - Pretty-printed with const JsonEncoder.withIndent('  ')
   - Root includes exportedAt UTC timestamp and schemaVersion: 2

3. Calm Mode integration:
   - When calmMode=true: all loss-aversion copy replaced ("critical" → "needs attention", death screen hidden, streak-only UI)
   - VulnerabilityCard surfaces Calm Mode toggle directly (not just in settings)
   - Toggle is in both settings and on VulnerabilityCard

4. Deletion flow:
   - "Delete All Data" in settings → AlertDialog "Are you sure? You have 7 days to change your mind."
   - On confirm: set deletionScheduledAt in pet_state + write DELETE_INITIATED audit entry
   - On next app launch (in main.dart): check if 7 days elapsed → call EncryptionService.destroyKey()
   - After key destruction: navigate to /onboarding (app behaves like first launch)

5. lib/features/health/health_adapter.dart:
   - fetchSummary(DateRange) → HealthSnapshot? using health package
   - Requests: HealthDataType.STEPS, HealthDataType.SLEEP_ASLEEP, HealthDataType.RESTING_HEART_RATE
   - Read only — never request write types
   - Returns null if permissions denied or data unavailable (graceful degradation)

Run: flutter analyze --no-pub && flutter test
Fix any errors. Report final results.

```

---

## Phase 9 — Demo Seed Data & Hackathon Polish

**Goal:** Demo mode seeded, handoff PDF hero artefact ready, edge cases handled, app store-ready build.

**Duration estimate:** 2–3 hours  
**Dependencies:** Phases 0–8 complete

### Sprint 9.1 — Demo seed and final polish

**Cursor prompt:**

```
We are building VitalPet. Phases 0–8 complete. Final sprint: demo seed data, polish, and build.

1. scripts/seed_demo.dart — implement fully.

   Creates a pet named "Mochi", species "cat", streak=23, vitality=85.
   Inserts 30 days of structured check-ins using the new symptom schema:

   Days 1–2 (flare days, Mode 3, wellnessScore 1–2):
   - CheckIn: wellnessScore=2, mode=3, depthScore=0.9
   - CheckInSymptoms: fever (pattern=intermittent), pain (pattern=worsening), fatigue (pattern=all_day)
   - SymptomFever: temperature=38.5, unit='C', method='oral', skipped=false
   - SymptomPain: regionsJson='["lower_limb_l","lower_limb_r","back"]', type='aching'
   - SymptomFatigue: scope='debilitating', blocksDaily=true
   - CheckInSubjective: freeNotes='Really struggling today.'

   Days 3–10 (moderate days, Mode 2, wellnessScore 4–5):
   - CheckIn: wellnessScore=4 or 5, mode=2, depthScore=0.6
   - CheckInSymptoms: pain, fatigue
   - SymptomPain: regionsJson='["back"]', type='dull'
   - SymptomFatigue: scope='functional', blocksDaily=false

   Days 11–30 (good days, Mode 1, wellnessScore 7–9):
   - CheckIn: wellnessScore=7 to 9, mode=1, depthScore=0.1
   - No CheckInSymptoms rows — overall_status is implicitly 'great'

   Mocks health data: sleep avg 6.8h, steps avg 4200/day.
   Run with: dart scripts/seed_demo.dart

2. Implement a --demo flag in GoRouter:
   - If --demo dart-define is set: load seed data on launch, skip onboarding
   - Run with: flutter run --dart-define=DEMO=true

3. SLM warm-up for demo:
   - On demo launch, pre-warm the SLM with Mochi's 30-day structured context so the first
     question appears in <1 second when wellness score 2 is submitted.

4. Polish pass:
   - Verify all notification copy uses pet name (no "your pet" fallback visible)
   - Verify all Flutter rocking/bouncing animations and typing text effects respect MediaQuery.disableAnimations
   - Verify body map minimum touch targets 44×44 everywhere
   - Verify handoff PDF disclaimer is on every page
   - Verify flutter analyze --no-pub reports zero errors

5. iOS 26 compatibility check:
   - Confirm UIDesignRequiresCompatibility = YES is set in ios/Runner/Info.plist
   - Run the app on the physical iOS 26 device (not just simulator)
   - Verify: navigation works, wellness slider renders correctly, pet PNG animation plays,
     check-in flow completes end to end, handoff PDF generates and share sheet opens
   - Verify: no visual regressions from Liquid Glass system chrome
     (the opt-out flag should prevent any system-imposed glass effects)
   - If any stock Alert dialogs or action sheets look inconsistent with the rest of the
     app's design, replace them with custom Flutter equivalents (showDialog with a custom
     widget) rather than using CupertinoAlertDialog

6. Build release candidate:
   - flutter build ios --release (iOS) — or flutter build ipa if signing configured
   - Report build sizes. Target: < 150 MB total including model weights

7. Run /audit command and report all PASS/WARN/FAIL.

Final report: list every FR from the SRS and whether it is implemented, partial, or out of scope for this build.

```

---

## Checklist before hackathon demo

- App launches cold in < 2 seconds
- Mode 1 check-in completable in < 20 seconds (3 taps: slider → submit → done)
- Mode 2/3 check-in collects at least one structured symptom and commits to DB correctly
- SLM inference completes in < 3 seconds on demo device
- Handoff PDF generates in < 10 seconds for 30-day dataset
- Handoff PDF shows top 3 symptom categories (not old flat domains)
- Widget shows on home screen with correct pet state and streak
- Notifications fire at scheduled time
- No `flutter analyze` errors
- All tests pass
- /audit command returns 0 FAIL
- Demo device has no notification banners from other apps, full battery
- Seed data loaded and handoff PDF pre-generated for pitch

---

## Post-hackathon: Android parity

These sprints are explicitly out of scope for the hackathon build. Run them after the iOS version is stable and submitted.

### Sprint A.1 — Android Glance widget

Implement native/android/widget/ using Kotlin + Glance. Reference: .cursor/skills/native-widgets/[SKILL.md](http://SKILL.md) (Android section).

### Sprint A.2 — Health Connect integration

The health package already supports Health Connect. Add Health Connect permissions to AndroidManifest.xml. Test on Android 14+ emulator.

### Sprint A.3 — Android notification channels

flutter_local_notifications requires explicit channel setup on Android. Add notification channel creation in main.dart for Android.

### Sprint A.4 — Android E2E testing

Run integration_test suite on Android emulator. Test model download over cellular warning on Android. Verify widget updates on Android 14+.