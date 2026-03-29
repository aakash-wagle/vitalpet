import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// check_ins — one row per check-in session
class CheckIns extends Table {
  TextColumn get id => text()();
  TextColumn get utcDate => text()();
  TextColumn get localDate => text()();
  IntColumn get wellnessScore => integer()();
  // overall_status: 'great' | 'not_great' — derived from wellnessScore at query time,
  // not stored as a separate column (score <=6 = not_great, >=7 = great)
  IntColumn get mode => integer()();
  RealColumn get depthScore => real().withDefault(const Constant(0.0))();
  BoolColumn get isPartial => boolean().withDefault(const Constant(false))();
  TextColumn get amendedAt => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// check_in_symptoms — one row per symptom per check-in session
class CheckInSymptoms extends Table {
  TextColumn get id => text()();
  TextColumn get checkInId => text().references(CheckIns, #id)();
  TextColumn get category => text()(); // 'fever'|'pain'|'fatigue'|'nausea'|'other'
  IntColumn get onsetDay => integer().nullable()(); // computed from history after insert — never asked
  TextColumn get pattern => text().nullable()(); // category-specific enum value as string

  @override
  Set<Column> get primaryKey => {id};
}

// symptom_fever — one row per fever symptom, FK → check_in_symptoms.id
@DataClassName('SymptomFeverData')
class SymptomFever extends Table {
  TextColumn get symptomId => text().references(CheckInSymptoms, #id)();
  RealColumn get temperature => real().nullable()();
  TextColumn get unit => text().nullable()(); // 'C'|'F'
  TextColumn get method => text().nullable()(); // 'oral'|'ear'|'forehead'|'other'
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
  // skipped=true means user has no thermometer — distinct from a null temperature

  @override
  Set<Column> get primaryKey => {symptomId};
}

// symptom_pain — one row per pain symptom, FK → check_in_symptoms.id
@DataClassName('SymptomPainData')
class SymptomPain extends Table {
  TextColumn get symptomId => text().references(CheckInSymptoms, #id)();
  TextColumn get regionsJson => text()(); // JSON array of body_region strings
  TextColumn get type => text()(); // 'sharp'|'dull'|'throbbing'|'burning'|'cramping'|'aching'
  TextColumn get triggersJson => text().nullable()(); // JSON array: 'movement'|'eating'|'breathing'|'touch'|'none'

  @override
  Set<Column> get primaryKey => {symptomId};
}

// symptom_fatigue — one row per fatigue symptom, FK → check_in_symptoms.id
@DataClassName('SymptomFatigueData')
class SymptomFatigue extends Table {
  TextColumn get symptomId => text().references(CheckInSymptoms, #id)();
  TextColumn get scope => text()(); // 'functional'|'wiped_out'|'debilitating'
  BoolColumn get blocksDaily => boolean()();

  @override
  Set<Column> get primaryKey => {symptomId};
}

// symptom_nausea — one row per nausea symptom, FK → check_in_symptoms.id
@DataClassName('SymptomNauseaData')
class SymptomNausea extends Table {
  TextColumn get symptomId => text().references(CheckInSymptoms, #id)();
  BoolColumn get vomiting => boolean()();
  TextColumn get vomitFreq => text().nullable()(); // 'once'|'few_times'|'persistent' — null if vomiting=false
  TextColumn get appetite => text()(); // 'normal'|'reduced'|'none'
  TextColumn get dehydrationSignsJson => text().nullable()(); // JSON array: 'dry_mouth'|'dark_urine'|'dizziness'

  @override
  Set<Column> get primaryKey => {symptomId};
}

// symptom_other — one row per other symptom, FK → check_in_symptoms.id
@DataClassName('SymptomOtherData')
class SymptomOther extends Table {
  TextColumn get symptomId => text().references(CheckInSymptoms, #id)();
  TextColumn get freeText => text()(); // mandatory for this category
  TextColumn get extractedDetailsJson => text().nullable()(); // best-effort SLM parse

  @override
  Set<Column> get primaryKey => {symptomId};
}

// check_in_subjective — one row per check-in, all fields optional, FK → check_ins.id
@DataClassName('CheckInSubjectiveData')
class CheckInSubjective extends Table {
  TextColumn get checkInId => text().references(CheckIns, #id)();
  TextColumn get freeNotes => text().nullable()();
  TextColumn get slmTagsJson => text().nullable()(); // JSON array of keyword strings
  TextColumn get followUpExchangesJson => text().nullable()();
  // JSON array of { role: 'user'|'assistant', content: string, timestamp: ISO8601 }

  @override
  Set<Column> get primaryKey => {checkInId};
}

// pet_state — single-row table (current active pet)
class PetStateTable extends Table {
  TextColumn get petId => text()();
  TextColumn get name => text()();
  TextColumn get species => text()();
  IntColumn get vitality => integer().withDefault(const Constant(60))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  TextColumn get lastCheckinUtc => text().nullable()();
  BoolColumn get calmMode => boolean().withDefault(const Constant(false))();
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
  CheckInSymptoms,
  SymptomFever,
  SymptomPain,
  SymptomFatigue,
  SymptomNausea,
  SymptomOther,
  CheckInSubjective,
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
