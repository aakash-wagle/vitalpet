/// Demo seed toggle for local showcase runs.
///
/// Set to `true` to wipe + reseed check-ins and pet state on app startup
/// (debug builds only). Set back to `false` for normal behavior.
const bool kEnableDemoScenarioSeed = true; /// fase;

/// Change this path to switch scenarios, then rerun the app.
///
/// Available files:
/// - assets/demo/scenarios/logged_50_days_yesterday.json
/// - assets/demo/scenarios/logged_50_days_missed_3.json
/// - assets/demo/scenarios/logged_50_days_missed_9.json
const String kDemoScenarioAssetPath =
    'assets/demo/scenarios/logged_50_days_missed_9.json';
