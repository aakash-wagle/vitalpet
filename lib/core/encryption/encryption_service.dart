import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages the SQLCipher AES-256 key via flutter_secure_storage.
/// Key is stored in iOS Keychain (first_unlock_this_device) /
/// Android Keystore. Never logged, cached, or serialised.
class EncryptionService {
  static const _keyAlias = 'vitalpet_db_key';

  static const _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  static const _storage = FlutterSecureStorage(iOptions: _iosOptions);

  /// Returns the existing key or generates and persists a new one.
  static Future<String> getOrCreateKey() async {
    // TODO: implement key derivation (secure random + hex encoding)
    throw UnimplementedError();
  }

  /// Removes the key from secure storage, rendering the DB permanently
  /// unreadable. Called only from the 7-day deletion flow.
  static Future<void> destroyKey() async {
    await _storage.delete(key: _keyAlias, iOptions: _iosOptions);
  }
}
