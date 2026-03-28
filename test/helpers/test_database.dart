import 'package:drift/native.dart';
import 'package:vitalpet/core/database/app_database.dart';

/// Creates an in-memory AppDatabase for unit tests.
/// Does NOT use SQLCipher — encryption is skipped in test environments.
AppDatabase createTestDatabase() {
  return AppDatabase(NativeDatabase.memory());
}
