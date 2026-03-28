# VitalPet — Repository Structure

> Give this file to Cursor and ask it to create the scaffold:
> "Read REPO_STRUCTURE.md and create every file and directory listed. For code files, create empty stubs with the correct imports and class/function signatures but no implementation. For config and asset files, create them with placeholder content."

---

## Stack summary
- **Framework**: Flutter 3.x + Dart (Impeller renderer)
- **State**: Riverpod 3.x (`flutter_riverpod`, `riverpod_annotation`)
- **Navigation**: go_router 14.x
- **Database**: drift 2.x + sqlcipher_flutter_libs (AES-256)
- **SLM inference**: flutter_gemma → MediaPipe (Gemma 3n E2B int4, on-device only)
- **Animations**: rive 0.13.x (pet state machine) + confetti 0.7.x (milestones)
- **Health**: health 12.x (unified HealthKit + Health Connect)
- **PDF**: pdf 3.x + printing 5.x (pure Dart, no native bridge)
- **Notifications**: flutter_local_notifications 18.x
- **Widgets**: WidgetKit Swift (iOS) + Glance Kotlin (Android) — mandatory native
- **Widget data bridge**: home_widget 0.5.x

---

## Full directory tree

```
vitalpet/                                          # Flutter project root
│
├── pubspec.yaml                                   # all dependencies declared here
├── analysis_options.yaml                          # strict linting rules
├── .gitignore                                     # includes assets/models/
├── REPO_STRUCTURE.md                              # this file
├── DEVELOPMENT_PLAN.md                            # phase-by-phase build plan
│
├── lib/
│   ├── main.dart                                  # app entry: initialises flutter_gemma, opens DB, sets up Riverpod, runs app
│   │
│   ├── core/                                      # shared infrastructure — no feature logic
│   │   ├── database/
│   │   │   ├── app_database.dart                  # @DriftDatabase: all tables, schemaVersion, MigrationStrategy
│   │   │   ├── app_database.g.dart                # GENERATED — do not edit
│   │   │   ├── baseline_dao.dart                  # upsertBaseline, getBaseline, getAllBaselines, upsertContextCache, getContextCache
│   │   │   └── migrations/
│   │   │       └── migration_v1.dart              # onCreate: m.createAll()
│   │   │
│   │   ├── encryption/
│   │   │   └── encryption_service.dart            # getOrCreateKey(), destroyKey() via flutter_secure_storage
│   │   │
│   │   ├── audit/
│   │   │   └── audit_log_dao.dart                 # append(), appendInTransaction() — no update/delete
│   │   │
│   │   └── constants/
│   │       ├── symptom_domains.dart               # SymptomDomain enum loaded from config/symptom_taxonomy.json
│   │       └── app_constants.dart                 # SLM_TIMEOUT_MS, MAX_MISSED_DAYS_BEFORE_DEATH, etc.
│   │
│   ├── features/
│   │   │
│   │   ├── check_in/
│   │   │   ├── data/
│   │   │   │   ├── check_in_dao.dart              # insertCheckIn, findByDateRange, findLatest, amendCheckIn, getStreakData
│   │   │   │   └── check_in_dao.g.dart            # GENERATED
│   │   │   ├── domain/
│   │   │   │   ├── check_in_engine.dart           # CheckInEngine: orchestrates full session lifecycle
│   │   │   │   ├── mode_selector.dart             # selectMode(int score) → CheckInMode (pure function)
│   │   │   │   ├── check_in_session_notifier.dart # AsyncNotifier<CheckInSessionState>: submitWellnessScore, submitAnswer, savePartial, resumePartial, completeSession, amendSession
│   │   │   │   ├── session_store.dart             # in-memory partial session state
│   │   │   │   ├── streak_manager.dart            # activateFreeze, isStreakValid, resetStreak
│   │   │   │   ├── check_in_session_state.dart    # freezed union: idle | collecting | partial | completing
│   │   │   │   └── question_answer.dart           # freezed: QuestionAnswer with domain, type, value
│   │   │   └── presentation/
│   │   │       ├── check_in_screen.dart           # ConsumerWidget: WellnessSlider → questions → done
│   │   │       └── widgets/
│   │   │           ├── wellness_slider.dart        # full-screen 1–10 slider with haptic feedback
│   │   │           ├── question_card.dart          # binary | slider | body_map | text input
│   │   │           ├── companion_bubble.dart       # Mode 3 chat bubble attributed to pet
│   │   │           └── body_map.dart              # SVG silhouette tap widget (flutter_svg)
│   │   │
│   │   ├── pet/
│   │   │   ├── data/
│   │   │   │   ├── pet_dao.dart                   # getPetState, updatePetState, deletePetState
│   │   │   │   ├── pet_dao.g.dart                 # GENERATED
│   │   │   │   ├── pet_archive_dao.dart           # insertArchive, getArchive
│   │   │   │   └── pet_archive_dao.g.dart         # GENERATED
│   │   │   ├── domain/
│   │   │   │   ├── vitality_calculator.dart       # calculateVitality() pure function
│   │   │   │   ├── pet_state_mapper.dart          # mapVitalityToState(int) → PetStateEnum
│   │   │   │   ├── milestone_detector.dart        # detectMilestone(int streak) → MilestoneType?
│   │   │   │   ├── pet_notifier.dart              # AsyncNotifier<PetState>: recalculate, triggerDeath, archivePet
│   │   │   │   ├── widget_data_writer.dart        # updateWidgetData() via home_widget package
│   │   │   │   └── pet_state.dart                 # freezed: PetState data class
│   │   │   └── presentation/
│   │   │       ├── home_screen.dart               # ConsumerWidget: PetRenderer + streak + deviation alert card
│   │   │       ├── death_screen.dart              # greyscale fade, lifespan, "Start again"
│   │   │       └── widgets/
│   │   │           ├── pet_renderer.dart           # Rive widget driven by vitality + boolean inputs
│   │   │           ├── streak_badge.dart           # streak count display
│   │   │           └── deviation_alert_card.dart   # surfaces 1.5 SD deviation alerts
│   │   │
│   │   ├── slm/
│   │   │   ├── slm_client.dart                    # flutter_gemma wrapper, 3s timeout, throws SLMTimeoutException
│   │   │   ├── question_sequencer.dart            # builds SLMContext, calls SLMClient, parses SLMOutput
│   │   │   ├── medical_content_filter.dart        # filter(String raw) → FilterResult — MANDATORY before display
│   │   │   ├── baseline_tracker.dart              # computeBaselines(), checkAllMetrics() → DeviationAlert?
│   │   │   ├── rule_based_fallback.dart           # getQuestions(SLMContext) from cold_start_rules.json
│   │   │   ├── narrative_generator.dart           # generate(NarrativeContext) → HandoffNarrative (separate SLM call)
│   │   │   ├── slm_context.dart                   # freezed: SLMContext data class
│   │   │   └── slm_output.dart                    # freezed: SLMOutput, SLMQuestion, QuestionType
│   │   │
│   │   ├── handoff/
│   │   │   ├── handoff_generator.dart             # generateAndShare(): reads DB → SLM narrative → builds pdf.Document → Printing.sharePdf()
│   │   │   ├── chart_data_builder.dart            # buildTrendChart(), buildHeatmap(), buildHealthCorrelation()
│   │   │   ├── narrative_context.dart             # freezed: de-identified NarrativeContext for SLM
│   │   │   └── presentation/
│   │   │       └── handoff_screen.dart            # date range picker + "Generate" button + preview
│   │   │
│   │   ├── health/
│   │   │   └── health_adapter.dart                # fetchSummary(DateRange) → HealthSnapshot? via health package
│   │   │
│   │   ├── notifications/
│   │   │   ├── notification_scheduler.dart        # schedulePrimary, scheduleSecondary, scheduleCritical, scheduleMilestone
│   │   │   └── pattern_adapter.dart               # analyses open history, suggests reminder time change after 7 days
│   │   │
│   │   └── onboarding/
│   │       ├── onboarding_notifier.dart           # manages onboarding state, persists condition focus
│   │       └── presentation/
│   │           ├── onboarding_screen.dart         # 3 screens: problem → pet selection → pet naming
│   │           └── widgets/
│   │               ├── pet_selector.dart           # 4 species grid
│   │               └── pet_name_input.dart         # 2–20 char name field
│   │
│   └── presentation/
│       ├── screens/
│       │   └── settings_screen.dart               # reminder time, calm mode, health connection, export, delete
│       ├── widgets/
│       │   └── vulnerability_card.dart            # surfaces after 5 consecutive bad days; includes Calm Mode toggle
│       ├── theme/
│       │   ├── app_theme.dart                     # ThemeData light + dark
│       │   ├── app_colors.dart                    # all colour constants
│       │   └── app_text_styles.dart               # all text style constants
│       └── router/
│           └── app_router.dart                    # GoRouter: routes, deep-link vitalpet://checkin, guards
│
├── native/                                        # ONLY mandatory native code — widgets
│   ├── ios/
│   │   └── VitalPetWidget/                        # Xcode widget extension target
│   │       ├── VitalPetWidget.swift               # @main WidgetBundle, Widget configuration
│   │       ├── VitalPetEntryView.swift            # SwiftUI views for .systemSmall + .systemMedium
│   │       ├── WidgetDataProvider.swift           # TimelineProvider: reads App Group UserDefaults
│   │       ├── WellnessSparkline.swift            # SwiftUI Path mini bar chart (7 bars)
│   │       ├── VitalPetWidget.entitlements        # App Group: group.com.vitalpet.shared
│   │       └── Info.plist                         # widget extension plist
│   │
│   └── android/
│       └── widget/                                # Kotlin Glance widget
│           ├── VitalPetWidget.kt                  # GlanceAppWidget + GlanceAppWidgetReceiver
│           ├── PetWidgetContent.kt                # @Composable for small + medium sizes
│           ├── WidgetDataProvider.kt              # reads FlutterSharedPreferences (home_widget format)
│           └── WellnessSparkline.kt               # Glance Row of colored Box composables (7 bars)
│
├── assets/
│   ├── animations/
│   │   ├── cat.riv                                # Rive file: PetStateMachine, vitality/checkInComplete/isDead/timeOfDay inputs
│   │   ├── dog.riv
│   │   ├── rabbit.riv
│   │   └── dragon.riv
│   ├── widget_sprites/
│   │   ├── cat_1.png … cat_5.png                 # static PNGs for widget (Rive not usable in widgets)
│   │   ├── dog_1.png … dog_5.png
│   │   ├── rabbit_1.png … rabbit_5.png
│   │   └── dragon_1.png … dragon_5.png
│   ├── models/                                    # .gitignored — Gemma 3n E2B downloaded at first launch
│   │   └── .gitkeep
│   ├── fonts/                                     # app typeface
│   └── config/                                    # loaded at runtime via rootBundle
│       ├── slm_prompt.txt                         # SLM system prompt — edit here, not in Dart (NFR-M-01)
│       ├── symptom_taxonomy.json                  # question domains — edit here, not in Dart (NFR-M-02)
│       ├── cold_start_rules.json                  # per-condition fallback sequences (FR-AI-02)
│       └── medical_filter_patterns.json           # blocked phrase patterns (FR-AI-12)
│
├── test/                                          # mirrors lib/ structure
│   ├── core/
│   │   └── database/
│   │       └── vitality_calculator_test.dart      # all boundary values, missed-day escalation, freeze
│   ├── features/
│   │   ├── check_in/
│   │   │   ├── mode_selector_test.dart            # boundary values 3, 4, 6, 7
│   │   │   └── check_in_engine_test.dart          # session lifecycle, partial session, amendment
│   │   ├── pet/
│   │   │   ├── streak_manager_test.dart           # UTC day boundaries, freeze logic, clock tamper
│   │   │   └── milestone_detector_test.dart       # 7, 14, 30, 90 day milestones
│   │   ├── slm/
│   │   │   ├── medical_content_filter_test.dart   # blocked phrases return safe=false, safe content passes
│   │   │   ├── rule_based_fallback_test.dart      # correct domain order per condition focus
│   │   │   └── baseline_tracker_test.dart         # deviation detection with mock time series
│   │   └── handoff/
│   │       └── chart_data_builder_test.dart       # trend chart, heatmap, missed day handling
│   └── helpers/
│       └── test_database.dart                     # in-memory drift DB for tests
│
├── demo/
│   ├── seed_data.json                             # 30-day synthetic check-ins: Maya, Mochi the cat, 3 flare days
│   └── mock_health_data.json                      # mocked steps, sleep, resting HR
│
└── scripts/
    ├── seed_demo.dart                             # dart run scripts/seed_demo.dart — loads demo data
    ├── download_models.sh                         # fetches gemma-3n-E2B-it-int4.task from HuggingFace
    └── audit_deps.sh                              # checks pubspec.yaml for banned packages
```

---

## Key conventions

### Feature-first structure
Each feature owns its full vertical slice: `data/` (DAOs) → `domain/` (logic, notifiers) → `presentation/` (screens, widgets). Cross-feature dependencies go downward only: `presentation` → `domain` → `data` → `core`.

### Code generation
drift and Riverpod use `build_runner`. After modifying annotated files:
```bash
dart run build_runner build --delete-conflicting-outputs
```
Generated files (`*.g.dart`, `*.freezed.dart`) are committed. Never edit them manually.

### What is NOT in this repo
- No backend, no API server, no cloud function
- No Firebase, no Amplitude, no Mixpanel, no Sentry (unless crash-only with user opt-in)
- No React Native, no TypeScript, no JavaScript (except the two `.cursor/hooks/*.js` Node scripts)
- No raw SQL outside of drift DAOs
- No SLM model weights in git (`assets/models/` is gitignored)

### Native code scope
The **only** native code is the two widget targets. Everything else is pure Flutter/Dart:
- SLM inference → `flutter_gemma`
- Database → `drift` + `sqlcipher_flutter_libs`
- Health → `health` package
- PDF → `pdf` + `printing`
- Notifications → `flutter_local_notifications`
- Widget data bridge → `home_widget`
