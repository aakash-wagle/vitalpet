import 'package:vitalpet/core/database/app_database.dart';

/// Schema version 2 — add [CheckIns.overallStatus] for databases created
/// before that column existed (v1 had no [onUpgrade], so older files stayed stale).
Future<void> migrateV1ToV2(AppDatabase db) async {
  final columns = await db.customSelect('PRAGMA table_info(check_ins)').get();
  final hasOverallStatus = columns.any(
    (row) => row.data['name'] == 'overall_status',
  );
  if (hasOverallStatus) return;

  await db.customStatement(
    "ALTER TABLE check_ins ADD COLUMN overall_status TEXT NOT NULL DEFAULT 'great'",
  );
}
