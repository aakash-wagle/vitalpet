import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/core/database/app_database.dart';

/// Provides the open [AppDatabase] instance to the widget tree.
///
/// This provider is overridden in [main] with the encrypted database opened
/// via [EncryptionService.getOrCreateKey] before [runApp] is called.
/// Never read this provider without the override in place.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(
    'databaseProvider must be overridden in main() via ProviderScope.overrides.',
  ),
);
