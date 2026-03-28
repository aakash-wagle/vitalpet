import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// All drift tables are declared here.
/// schemaVersion and MigrationStrategy are defined below.
/// Open this database only via EncryptionService — never unencrypted.
@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
      );
}
