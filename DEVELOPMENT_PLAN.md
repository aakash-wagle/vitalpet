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
   intl: ^0.19.0
   dev: build_runner, riverpod_generator, freezed, drift_dev, json_serializable, mocktail

2. Create analysis_options.yaml with strict linting (include: package:flutter_lints/flutter.yaml, prefer_final_locals, avoid_print).

3. Create lib/main.dart as an empty stub with ProviderScope wrapping a placeholder MyApp widget.

4. Create every directory and empty .dart stub file listed in REPO_STRUCTURE.md. Each stub should have the correct import statements and an empty class or function signature matching the description, but no implementation body.

5. Create assets/config/slm_prompt.txt with a one-line placeholder: "You are a symptom-tracking assistant."
6. Create assets/config/symptom_taxonomy.json as {"domains":["pain","fatigue","sleep","appetite","nausea","mood","cognitive","medication"]}
7. Create assets/config/cold_start_rules.json as {"default":["pain","fatigue","sleep","appetite","mood"]}
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

## Phase 1 — Domain Logic (no UI)
**Goal:** All pure Dart business logic implemented and tested. Nothing shown on screen yet.

**Duration estimate:** 3–4 hours  
**Dependencies:** Phase 0 complete, DB schema generated

### Sprint 1.1 — Check-in domain
**What gets built:** `ModeSelector`, `VitalityCalculator`, `StreakManager`, `MilestoneDetector`, `CheckInSessionState`, and their unit tests.

**Cursor prompt:**
```
We are building VitalPet. Phase 0 (scaffold + DB schema) is complete.

Read before writing any code:
- .cursor/rules/03-feature-logic.mdc
- .cursor/skills/check-in-engine/SKILL.md
- .cursor/skills/pet-engine/SKILL.md

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
   - isValidCheckin(int wellnessScore, int answersCount) → bool — anti-gaming rule
   - All calculations UTC-date keyed

4. lib/features/pet/domain/milestone_detector.dart
   - detectMilestone(int streak) → MilestoneType? — checks 7, 14, 30, 90

5. lib/features/check_in/domain/check_in_session_state.dart
   - freezed union: idle | collectingScore | collectingAnswers(mode, questions, answers) | partial | completing

6. lib/features/check_in/domain/question_answer.dart
   - freezed: QuestionAnswer {domain, type, value}

Then write unit tests for all of the above in test/features/:
- test/features/check_in/mode_selector_test.dart — test score 1,3,4,6,7,10
- test/features/pet/vitality_calculator_test.dart — zero streak, max streak, 1/2/3+ missed days, vulnerability freeze, depth bonus
- test/features/pet/milestone_detector_test.dart — 7,14,30,90 hit; 8,15 miss

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

Implement SLM domain logic only — no screens, no UI.

1. lib/features/slm/slm_client.dart
   - Wraps FlutterGemma.instance.getResponseAsync()
   - 3000ms timeout via Future.timeout — throws SLMTimeoutException on timeout
   - Validates output against SLMOutput schema, throws SLMParseException on malformed JSON

2. lib/features/slm/slm_output.dart and slm_context.dart
   - freezed data classes per .cursor/skills/slm-layer/SKILL.md schema

3. lib/features/slm/medical_content_filter.dart
   - Loads patterns from assets/config/medical_filter_patterns.json via rootBundle at init
   - filter(String raw) → FilterResult
   - FilterResult: {bool safe, String text}
   - Static constant: safeFallback = "I'm here to help you remember — please speak to your doctor."

4. lib/features/slm/rule_based_fallback.dart
   - Loads cold_start_rules.json at init
   - getQuestions(SLMContext context) → List<SLMQuestion>
   - Uses context.conditionFocus to pick question order; falls back to default order

5. lib/features/slm/baseline_tracker.dart
   - computeBaselines(List<CheckIn> recent) → Map<String, BaselineStats>
   - checkDeviation(String metric, List<double> values, BaselineStats baseline) → DeviationAlert?
   - Trigger: >1.5 SD below mean for 3 consecutive values

Then write tests:
- test/features/slm/medical_content_filter_test.dart — blocked phrases fail, safe content passes, safeFallback is correct string
- test/features/slm/rule_based_fallback_test.dart — correct domain order for chronic_pain, post_surgery, default
- test/features/slm/baseline_tracker_test.dart — deviation detected at exactly 3 days, not at 2; no alert when within 1.5 SD

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

Run: flutter run -d <device>  (or flutter build apk --debug)
Report that the app launches, navigates between placeholder screens, and deep-link works.
Fix any errors. Run: flutter analyze --no-pub
```

---

## Phase 3 — Pet Engine & Home Screen
**Goal:** The pet lives on screen, animated with simple PNGs (slight rocking), streak visible, pet can die.

**Duration estimate:** 3–4 hours  
**Dependencies:** Phase 2 complete, PNG files (or SVGs) in assets/images/pets/

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
**Goal:** Full working check-in: Mode 1/2/3, SLM inference with fallback, partial session, body map, completion triggers pet update.

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

Implement:

1. lib/features/check_in/domain/check_in_engine.dart — CheckInEngine class:
   - startSession(): loads health snapshot via HealthAdapter, initialises session state
   - submitWellnessScore(int score): calls ModeSelector, if Mode 2/3 calls SLMClient with 3s timeout, falls back to RuleBasedFallback on SLMTimeoutException
   - submitAnswer(QuestionAnswer answer): adds to session state
   - savePartial(): persists partial session to DB with isPartial=true
   - completeSession(): atomic transaction: insertCheckIn + updatePetState + auditLogDao.append(CHECKIN_WRITE), then recalculateVitality(), then updateWidgetData(), then check vulnerabilitySafeguard
   - amendSession(String id): updates answersJson + amendedAt, appends AMENDMENT audit entry

2. lib/features/check_in/domain/check_in_session_notifier.dart — AsyncNotifier wrapping CheckInEngine, one method per engine call.

3. lib/features/check_in/presentation/check_in_screen.dart — ConsumerWidget:
   Watches check_in_session state, renders:
   - CheckInSessionState.idle / collectingScore → WellnessSlider
   - CheckInSessionState.collectingAnswers → QuestionCard list (one at a time)
   - Mode 3: CompanionBubble instead of QuestionCard
   - "Save and come back" button always visible in Mode 2/3
   - "I'm done" always visible in Mode 3

4. lib/features/check_in/presentation/widgets/wellness_slider.dart:
   - Slider from 1–10, step 1
   - HapticFeedback.lightImpact() on each integer (iOS only)
   - Semantics(slider: true, value: '$score', min: '1', max: '10')

5. lib/features/check_in/presentation/widgets/question_card.dart:
   - Renders binary (two buttons), slider (1–5), bodymap (see below), or text input
   - Each rendered string from SLM must go through MedicalContentFilter before display

6. lib/features/check_in/presentation/widgets/body_map.dart:
   - flutter_svg silhouette, tap regions with min 44×44 targets
   - Max 3 selected, deselects oldest on 4th tap

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

## Phase 6 — Notifications & Widgets
**Goal:** Push notifications scheduled, home screen widgets showing pet + streak + sparkline.

**Duration estimate:** 3–4 hours  
**Dependencies:** Phase 5 complete

### Sprint 6.1 — Notifications
**Cursor prompt:**
```
We are building VitalPet. Phases 0–5 complete. Now implement notifications.

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

### Sprint 6.2 — Home screen widgets (native)
**Cursor prompt:**
```
We are building VitalPet. Sprint 6.1 (notifications) complete. Now build the home screen widgets.

Read before writing any code:
- .cursor/rules/04-native-widgets.mdc
- .cursor/skills/native-widgets/SKILL.md

IMPORTANT: This sprint involves native Swift and Kotlin code. The Flutter side is already done via home_widget package. This sprint is ONLY the native widget targets.

For iOS (native/ios/VitalPetWidget/):
1. VitalPetWidget.swift — WidgetBundle + Widget configuration, supports .systemSmall and .systemMedium
2. WidgetDataProvider.swift — TimelineProvider reading from UserDefaults(suiteName: "group.com.vitalpet.shared")
3. VitalPetEntryView.swift — SwiftUI views:
   - Small (2×2): pet sprite image (from widget_sprites/) + streak count + "Check in" widgetURL link
   - Medium (4×2): same + WellnessSparkline
4. WellnessSparkline.swift — SwiftUI Path: 7 bars, height proportional to score (1–10), grey for nil/missed
5. VitalPetWidget.entitlements — App Group: group.com.vitalpet.shared

Android Glance widget is OUT OF SCOPE for this iOS-first MVP.
Do not implement native/android/widget/.
Implement ONLY the iOS WidgetKit widget as specified above.
Document the Android Glance sprint as post-hackathon work.

After implementing native code:
- On iOS: open the Xcode project, add the widget extension target, set the App Group entitlement on BOTH the main app and widget targets. Verify the widget appears in the home screen widget picker.

Note: The pet images used in widgets mirror the identical static PNGs used in the main app from assets/images/pets/.

Document any manual Xcode steps required (entitlements, target membership, etc.).
```

---

## Phase 7 — Doctor Handoff
**Goal:** Complete PDF handoff: narrative, trend chart, heatmap, health correlation, share sheet.

**Duration estimate:** 3–4 hours  
**Dependencies:** Phases 1–4 complete (domain logic, check-in data exists in DB)

### Sprint 7.1 — Handoff PDF generation
**Cursor prompt:**
```
We are building VitalPet. Phases 0–4 complete (we are doing Phase 7 in parallel with Phase 6).

Read before writing any code:
- .cursor/skills/handoff/SKILL.md
- .cursor/rules/01-security-hipaa.mdc (de-identification rules)

Implement the doctor handoff using the pdf 3.x + printing 5.x packages (pure Dart, no native bridge).

1. lib/features/handoff/handoff_generator.dart — generateAndShare(DateRange, WidgetRef):
   - Read check-ins from CheckInDao.findByDateRange
   - Optionally fetch health summary via HealthAdapter
   - Call NarrativeGenerator.generate(NarrativeContext) — de-identified, no user name
   - Build pw.Document with 2–3 pages (see SKILL.md structure)
   - Write HANDOFF_EXPORT audit entry before calling Printing.sharePdf()
   - Use Printing.sharePdf(bytes: await pdf.save(), filename: '...')

2. lib/features/handoff/chart_data_builder.dart:
   - buildTrendChart: List<TrendPoint> with score, date, type (normal|missed|freeze)
   - buildHeatmap: Map<String, int?> of date → score for calendar grid

3. PDF page 1:
   - Disclaimer footer on every page (non-removable): "This summary was generated by VitalPet and is not a medical record."
   - Narrative: bolded headline, context paragraph, "Questions to raise"
   - Summary stats: date range, check-in count/total, avg wellness, top 3 domains
   - Trend line chart via pw.Chart

4. PDF page 2:
   - Calendar heatmap (6 weeks × 7 days grid, cell colour from wellness score gradient)
   - Notable events list (score ≤ 4, deviation alerts, >2 new domains in a day)

5. PDF page 3 (conditional):
   - Dual-axis chart: wellness vs sleep, wellness vs steps

6. lib/features/handoff/presentation/handoff_screen.dart:
   - Date range selector (7d / 30d / 90d)
   - "Generate & Share" button — triggers generateAndShare()
   - Loading state while generating

Run: flutter analyze --no-pub
Test manually: generate a handoff from the demo seed data. Verify PDF opens, shows all pages, disclaimer is present, share sheet appears.
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
   - Includes check_ins, pet_state, pet_archive, baseline_stats
   - Excludes audit_log, slm_context_cache
   - Pretty-printed with const JsonEncoder.withIndent('  ')
   - Root includes exportedAt UTC timestamp

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

1. scripts/seed_demo.dart — implement fully:
   - Creates a pet named "Mochi", species "cat", streak=23, vitality=85
   - Inserts 30 days of check-ins matching demo/seed_data.json spec:
     Days 1–2: score 1–2 (flare days, Mode 3 companion check-ins)
     Days 3–10: score 4–5 (moderate days, Mode 2)
     Days 11–30: score 7–9 (good days, Mode 1)
   - Mocks health data: sleep avg 6.8h, steps avg 4200/day
   - Run with: dart scripts/seed_demo.dart

2. Implement a --demo flag in GoRouter:
   - If --demo dart-define is set: load seed data on launch, skip onboarding
   - Run with: flutter run --dart-define=DEMO=true

3. SLM warm-up for demo:
   - On demo launch, pre-warm the SLM with Mochi's 30-day context so first question appears in <1 second when wellness score 2 is submitted

4. Polish pass:
   - Verify all notification copy uses pet name (no "your pet" fallback visible)
   - Verify all Flutter rocking/bouncing animations and typing text effects respect MediaQuery.disableAnimations
   - Verify body map minimum touch targets 44×44 everywhere
   - Verify handoff PDF disclaimer is on every page
   - Verify flutter analyze --no-pub reports zero errors

5. Build release candidate:
   - flutter build apk --release (Android)
   - flutter build ios --release (iOS) — or flutter build ipa if signing configured
   - Report build sizes. Target: < 150 MB total including model weights

6. Run /audit command and report all PASS/WARN/FAIL.

Final report: list every FR from the SRS and whether it is implemented, partial, or out of scope for this build.
```

---

## Checklist before hackathon demo

- [ ] App launches cold in < 2 seconds
- [ ] Mode 1 check-in completable in < 20 seconds (3 taps: slider → submit → done)
- [ ] SLM inference completes in < 3 seconds on demo device
- [ ] Handoff PDF generates in < 10 seconds for 30-day dataset
- [ ] Widget shows on home screen with correct pet state and streak
- [ ] Notifications fire at scheduled time
- [ ] No `flutter analyze` errors
- [ ] All tests pass
- [ ] /audit command returns 0 FAIL
- [ ] Demo device has no notification banners from other apps, full battery
- [ ] Seed data loaded and handoff PDF pre-generated for pitch

---

## Post-hackathon: Android parity
These sprints are explicitly out of scope for the hackathon build.
Run them after the iOS version is stable and submitted.

### Sprint A.1 — Android Glance widget
Implement native/android/widget/ using Kotlin + Glance.
Reference: .cursor/skills/native-widgets/SKILL.md (Android section).

### Sprint A.2 — Health Connect integration
The health package already supports Health Connect.
Add Health Connect permissions to AndroidManifest.xml.
Test on Android 14+ emulator.

### Sprint A.3 — Android notification channels
flutter_local_notifications requires explicit channel setup on Android.
Add notification channel creation in main.dart for Android.

### Sprint A.4 — Android E2E testing
Run integration_test suite on Android emulator.
Test model download over cellular warning on Android.
Verify widget updates on Android 14+.
