import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitalpet/core/database/app_database.dart';
import 'package:vitalpet/core/database/database_provider.dart';
import 'package:vitalpet/core/encryption/encryption_service.dart';
import 'package:vitalpet/presentation/router/app_router.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_theme.dart';

/// Set to true via --dart-define=SIMULATOR=true when running on the iOS
/// simulator. flutter_gemma requires Metal GPU (real device only) — skipping
/// initialisation on simulator allows full UI development without the model.
const _isSimulator = bool.fromEnvironment('SIMULATOR', defaultValue: false);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // flutter_gemma uses MediaPipe LLM Inference, which requires Metal GPU.
  // The iOS simulator runs on Mac CPU and does not expose Metal in the same
  // way a real device does — initialising here would crash the simulator.
  // Pass --dart-define=SIMULATOR=true to skip on simulator.
  if (!_isSimulator) {
    await FlutterGemma.initialize();
  }

  // Open the AES-256 encrypted SQLite database.
  // The key lives in iOS Keychain / Android Keystore — never logged or cached.
  final dbKey = await EncryptionService.getOrCreateKey();
  final database = openEncryptedDatabase(dbKey);

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const VitalPetApp(),
    ),
  );
}

/// Root application widget.
///
/// Implements [WidgetsBindingObserver] to overlay a blur when the app
/// transitions to the background, preventing the OS from capturing
/// a screenshot containing sensitive health data (NFR-S-08).
class VitalPetApp extends StatefulWidget {
  const VitalPetApp({super.key});

  @override
  State<VitalPetApp> createState() => _VitalPetAppState();
}

class _VitalPetAppState extends State<VitalPetApp>
    with WidgetsBindingObserver {
  bool _shouldBlur = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final blur =
        state == AppLifecycleState.inactive || state == AppLifecycleState.paused;
    if (blur != _shouldBlur) {
      setState(() => _shouldBlur = blur);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp.router(
      title: 'VitalPet',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );

    if (!_shouldBlur) return app;

    // Overlay an opaque ColoredBox so the OS app-switcher snapshot never shows
    // health data. Uses ImageFilter.blur for a frosted-glass effect.
    return Stack(
      children: [
        app,
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const ColoredBox(
              color: AppColors.background,
            ),
          ),
        ),
      ],
    );
  }
}
