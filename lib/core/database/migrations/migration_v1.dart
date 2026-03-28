import 'package:drift/drift.dart';

/// Schema v1 onCreate — creates all tables from scratch.
Future<void> migrateV1(Migrator m) async {
  await m.createAll();
}
