import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// check_ins — one row per check-in session
class CheckIns extends Table {
  TextColumn get id => text()();
  TextColumn get utcDate => text()();
  TextColumn get localDate => text()();
  /// "great" or "not_great" — matches DATA_TO_COLLECT.md overall_status
  TextColumn get overallStatus => text()();
  IntColumn get streakDay => integer().withDefault(const Constant(0))();
  IntColumn get mode => integer()();
  /// JSON-encoded symptoms array (category-specific symptom objects)
  TextColumn get symptomsJson => text().withDefault(const Constant('[]'))();
  /// JSON-encoded answers array (legacy question answers)
  TextColumn get answersJson => text()();
  /// Free-text notes from the user at end of check-in
  TextColumn get freeNotes => text().nullable()();
  /// SLM-extracted tags from freeNotes
  TextColumn get slmTagsJson => text().nullable()();
  /// JSON-encoded follow-up conversation turns
  TextColumn get followUpExchangesJson => text().nullable()();
  RealColumn get depthScore =>
      real().withDefault(const Constant(0.0))();
  BoolColumn get isPartial =>
      boolean().withDefault(const Constant(false))();
  TextColumn get amendedAt => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// pet_state — single-row table (current active pet)
class PetStateTable extends Table {
  TextColumn get petId => text()();
  TextColumn get name => text()();
  TextColumn get species => text()();
  IntColumn get vitality =>
      integer().withDefault(const Constant(60))();
  IntColumn get streak =>
      integer().withDefault(const Constant(0))();
  TextColumn get lastCheckinUtc => text().nullable()();
  BoolColumn get calmMode =>
      boolean().withDefault(const Constant(false))();
  IntColumn get consecutiveBadDays =>
      integer().withDefault(const Constant(0))();
  BoolColumn get freezeAvailable =>
      boolean().withDefault(const Constant(true))();
  TextColumn get freezeLastUsedDate => text().nullable()();
  TextColumn get deletionScheduledAt => text().nullable()();
  BoolColumn get vulnerabilityCardShown =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get vulnerabilityFrozen =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {petId};
}

// baseline_stats — rolling 14-day stats per metric
class BaselineStats extends Table {
  TextColumn get metric => text()();
  RealColumn get mean14d => real()();
  RealColumn get stddev14d => real()();
  IntColumn get sampleCount => integer()();
  TextColumn get lastComputedUtc => text()();

  @override
  Set<Column> get primaryKey => {metric};
}

// audit_log — append-only
class AuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventType => text()();
  TextColumn get utcTimestamp => text()();
  TextColumn get sessionId => text().nullable()();
  TextColumn get payloadHash => text().nullable()();
}

// slm_context_cache
class SlmContextCache extends Table {
  TextColumn get date => text()();
  TextColumn get contextSnapshot => text()();

  @override
  Set<Column> get primaryKey => {date};
}

// pet_archive — deceased pets
class PetArchive extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get species => text()();
  IntColumn get lifespanDays => integer()();
  IntColumn get totalCheckins => integer()();
  TextColumn get topSymptom => text().nullable()();
  TextColumn get diedAtUtc => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  CheckIns,
  PetStateTable,
  BaselineStats,
  AuditLog,
  SlmContextCache,
  PetArchive,
])
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

/// Opens the encrypted AppDatabase using a SQLCipher key.
/// The [key] must come from [EncryptionService.getOrCreateKey].
/// Never open a plain (unencrypted) connection.
AppDatabase openEncryptedDatabase(String key) {
  return AppDatabase(
    driftDatabase(
      name: 'vitalpet',
      native: DriftNativeOptions(
        setup: (db) {
          // Apply SQLCipher encryption key before any other operation.
          db.execute("PRAGMA key = '$key'");
        },
      ),
    ),
  );
}
