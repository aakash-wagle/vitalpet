import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages the AES-256 SQLCipher key stored in iOS Keychain / Android Keystore.
///
/// Key lifecycle:
/// - [getOrCreateKey]: read or generate a 256-bit hex key on first launch.
/// - [destroyKey]: delete the key — the database becomes permanently unreadable.
///
/// Never log, cache in SharedPreferences, or serialise the key.
class EncryptionService {
  static const _keyAlias = 'vitalpet_db_key';

  static FlutterSecureStorage get _storage => const FlutterSecureStorage(
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );

  /// Returns the existing 256-bit hex key, or generates and stores one.
  static Future<String> getOrCreateKey() async {
    final existing = await _storage.read(key: _keyAlias);
    if (existing != null) return existing;

    final newKey = _generateSecureKey();
    await _storage.write(key: _keyAlias, value: newKey);
    return newKey;
  }

  /// Deletes the key from secure storage.
  /// After this call the drift database is cryptographically inaccessible.
  /// This is the final step of the 7-day data-deletion flow.
  static Future<void> destroyKey() async {
    await _storage.delete(key: _keyAlias);
  }

  /// Generates a 64-character hex string (256 bits of entropy).
  static String _generateSecureKey() {
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
