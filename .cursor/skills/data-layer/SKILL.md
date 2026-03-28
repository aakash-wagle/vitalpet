---
name: vitalpet-data-layer
description: >
  Use when working on lib/core/database/ (drift schema, migrations, DAOs), lib/core/encryption/
  (SQLCipher key management), lib/core/audit/ (audit log), or the JSON export service.
  Also use when debugging drift code generation or adding new DB migrations.
---

# VitalPet Data Layer (drift + SQLCipher)

## Quick reference — DAO methods

### CheckInDao (`lib/features/check_in/data/check_in_dao.dart`)
```dart
Future<void> insertCheckIn(CheckInsCompanion companion)    // always inside transaction
Future<List<CheckIn>> findByDateRange(String start, String end)
Future<List<CheckIn>> findLatest(int n)
Future<void> amendCheckIn(String id, String newAnswersJson, String amendedAt)
Future<List<StreakDay>> getStreakData(int days)
```

### PetDao (`lib/features/pet/data/pet_dao.dart`)
```dart
Future<PetStateTableData?> getPetState()
Future<void> updatePetState(PetStateTableCompanion companion)
Future<void> deletePetState()

### PetArchiveDao (`lib/features/pet/data/pet_archive_dao.dart`)
Future<void> insertArchive(PetArchiveCompanion companion)
Future<List<PetArchive>> getArchive()
```

### BaselineDao (`lib/core/database/baseline_dao.dart`)
```dart
Future<void> upsertBaseline(BaselineStatsCompanion companion)
Future<BaselineStats?> getBaseline(String metric)
Future<Map<String, BaselineStats>> getAllBaselines()
Future<void> upsertContextCache(String date, String snapshot)
Future<String?> getContextCache(String date)
```

### AuditLogDao (`lib/core/audit/audit_log_dao.dart`)
```dart
Future<void> append(AuditEvent event)                             // ONLY public write method
Future<void> appendInTransaction(Transaction tx, AuditEvent event)
// No update(), no delete()
```

## Running code generation
After modifying any drift-annotated class or Riverpod-annotated file:
```bash
dart run build_runner build --delete-conflicting-outputs
```
The generated files (`*.g.dart`, `*.freezed.dart`) are committed to the repo. Never edit them manually.

## Adding a migration
```dart
// lib/core/database/migrations/migration_vN.dart
// Step 1: Add the new column to the drift table class in app_database.dart
// Step 2: Register in MigrationStrategy.onUpgrade:
if (from < N) {
  await m.addColumn(petStateTable, petStateTable.newColumn);
}
// Step 3: Run: dart run build_runner build --delete-conflicting-outputs
// Step 4: Increment schemaVersion in @DriftDatabase annotation
// NEVER drop or rename — always add with a default value
```

## Encryption key lifecycle
```dart
// lib/core/encryption/encryption_service.dart
class EncryptionService {
  static const _keyAlias = 'vitalpet_db_key';

  static Future<String> getOrCreateKey() async {
    final storage = FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
    var key = await storage.read(key: _keyAlias);
    if (key == null) {
      key = _generateSecureKey(); // 64 hex chars = 256-bit
      await storage.write(key: _keyAlias, value: key);
    }
    return key;
  }

  static Future<void> destroyKey() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: _keyAlias);
    // DB is now permanently unreadable — app shows first-launch screen
  }
}
```

## Atomic write pattern
```dart
// ALWAYS wrap check-in commits in a transaction:
await db.transaction(() async {
  await checkInDao.insertCheckIn(companion);
  await petDao.updatePetState(petCompanion);
  await auditLogDao.appendInTransaction(
    AuditEvent.checkinWrite(
      sessionId: companion.id.value,
      payloadHash: sha256Hex(companion.answersJson.value),
    ),
  );
});
// After transaction:
await baselineTracker.checkAllMetrics();   // post-commit hook
await widgetDataWriter.updateWidgetData(); // update home screen widgets
```

## Timestamp discipline
```dart
// ALL stored timestamps — use these helpers:
String nowUtcIso()   => DateTime.now().toUtc().toIso8601String(); // "2025-06-15T14:30:00.000Z"
String todayUtc()    => DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc()); // "2025-06-15"
String todayLocal()  => DateFormat('yyyy-MM-dd').format(DateTime.now()); // device local date
// Never use millisecondsSinceEpoch for storage — always ISO strings
```

## JSON export
```dart
// lib/core/database/export_service.dart
Future<String> exportAllData() async {
  final checkins = await checkInDao.findAll();
  final pet = await petDao.getPetState();
  final archive = await petArchiveDao.getArchive();
  final baselines = await baselineDao.getAllBaselines();

  final data = {
    'exportedAt': nowUtcIso(),
    'version': '1.0',
    'pet_state': pet?.toJson(),
    'check_ins': checkins.map((c) => c.toJson()).toList(),
    'pet_archive': archive.map((a) => a.toJson()).toList(),
    'baseline_stats': baselines.map((k, v) => MapEntry(k, v.toJson())),
    // NOT included: audit_log (internal), slm_context_cache (reconstructable)
  };
  return const JsonEncoder.withIndent('  ').convert(data);
}
```

## Deletion flow
```dart
// Step 1: Schedule (7-day recovery window)
await petDao.updatePetState(PetStateTableCompanion(
  deletionScheduledAt: Value(nowUtcIso()),
));
await auditLogDao.append(AuditEvent.deleteInitiated());

// Step 2: On each app launch, check:
final pet = await petDao.getPetState();
if (pet?.deletionScheduledAt != null) {
  final scheduledAt = DateTime.parse(pet!.deletionScheduledAt!);
  if (DateTime.now().difference(scheduledAt).inDays >= 7) {
    await EncryptionService.destroyKey(); // permanent — no recovery after this
  }
}
```
