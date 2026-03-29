import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/core/constants/app_constants.dart';
import 'package:vitalpet/core/database/app_database.dart';
import 'package:vitalpet/core/database/database_provider.dart';
import 'package:vitalpet/core/encryption/encryption_service.dart';
import 'package:vitalpet/features/pet/data/pet_dao.dart';
import 'package:vitalpet/presentation/router/app_router.dart';
import 'package:vitalpet/presentation/theme/app_theme.dart';

/// Entry point.
///
/// Startup sequence (order is mandatory):
///   1. Open the AES-256 encrypted drift database via [EncryptionService].
///   2. Check if the 7-day deletion window has expired — if so, destroy the
///      key and open a fresh (empty) database so onboarding is shown.
///   3. Register the database as a Riverpod override via [ProviderScope].
///   4. Launch the Flutter widget tree.
///
/// FlutterGemma model loading is intentionally deferred — the model is ~1.5 GB
/// and is downloaded over Wi-Fi on demand inside [SLMClient]. There is nothing
/// to initialize at cold start when the model has not yet been downloaded.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var dbKey = await EncryptionService.getOrCreateKey();
  var db = openEncryptedDatabase(dbKey);

  // Check if the 7-day deletion window has expired.
  // If it has, destroy the key so the old DB is permanently unreadable,
  // then open a fresh encrypted database for a clean first-launch experience.
  final petDao = PetDao(db);
  final petRow = await petDao.getPetState();
  if (petRow?.deletionScheduledAt != null) {
    final scheduledAt = DateTime.parse(petRow!.deletionScheduledAt!);
    final elapsed = DateTime.now().toUtc().difference(scheduledAt).inDays;
    if (elapsed >= AppConstants.deletionRecoveryWindowDays) {
      await db.close();
      await EncryptionService.destroyKey();
      dbKey = await EncryptionService.getOrCreateKey();
      db = openEncryptedDatabase(dbKey);
    }
  }

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWith((_) => db)],
      child: const VitalPetApp(),
    ),
  );
}

class VitalPetApp extends ConsumerStatefulWidget {
  const VitalPetApp({super.key});

  @override
  ConsumerState<VitalPetApp> createState() => _VitalPetAppState();
}

class _VitalPetAppState extends ConsumerState<VitalPetApp>
    with WidgetsBindingObserver {
  /// True while the OS may be capturing an app-switcher snapshot.
  /// A blur overlay is rendered to prevent health data from appearing there.
  bool _obscured = false;

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
    final shouldObscure =
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused;
    if (shouldObscure != _obscured) {
      setState(() => _obscured = shouldObscure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        MaterialApp.router(
          title: 'VitalPet',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: ref.watch(appRouterProvider),
          debugShowCheckedModeBanner: false,
        ),
        // Screen-blur overlay: prevents health data appearing in the
        // iOS/Android app-switcher snapshot (security rule NFR-SEC-04).
        if (_obscured)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const ColoredBox(color: Color(0x800D7377)),
            ),
          ),
      ],
    );
  }
}
