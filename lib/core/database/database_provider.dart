import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/core/database/app_database.dart';

/// Provides the single [AppDatabase] instance opened with SQLCipher encryption.
///
/// Overridden at startup in [main()] via [ProviderScope.overrides] using the
/// key retrieved from [EncryptionService.getOrCreateKey()].
/// Never access the DB from a plain (unencrypted) connection.
final databaseProvider = Provider<AppDatabase>(
  (_) => throw UnimplementedError(
    'databaseProvider must be overridden at startup via ProviderScope.overrides',
  ),
);
