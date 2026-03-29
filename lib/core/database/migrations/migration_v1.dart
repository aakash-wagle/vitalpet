import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

/// Schema version 1 — initial database creation.
///
/// Creates all thirteen tables defined in [AppDatabase]:
/// - check_ins
/// - check_in_symptoms
/// - symptom_fever
/// - symptom_pain
/// - symptom_fatigue
/// - symptom_nausea
/// - symptom_other
/// - check_in_subjective
/// - pet_state_table
/// - baseline_stats
/// - audit_log
/// - slm_context_cache
/// - pet_archive
///
/// This migration is invoked by [AppDatabase.migration] → onCreate.
/// Future schema changes should be added as migration_v2.dart, etc.
/// Never drop or rename columns — always add new ones with defaults.
Future<void> migrateV1onCreate(Migrator m, AppDatabase db) async {
  await m.createAll();
}
