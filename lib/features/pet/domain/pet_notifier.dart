import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vitalpet/core/audit/audit_log_dao.dart';
import 'package:vitalpet/core/database/app_database.dart';
import 'package:vitalpet/core/database/dao_providers.dart';
import 'package:vitalpet/core/database/database_provider.dart';
import 'package:vitalpet/features/pet/domain/milestone_detector.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';
import 'package:vitalpet/features/pet/domain/pet_state_mapper.dart';
import 'package:vitalpet/features/pet/domain/vitality_calculator.dart';
import 'package:vitalpet/features/pet/domain/widget_data_writer.dart';

part 'pet_notifier.g.dart';

@riverpod
class PetNotifier extends _$PetNotifier {
  @override
  Future<PetState?> build() async {
    final petDao = ref.watch(petDaoProvider);
    final row = await petDao.getPetState();
    if (row == null) return null;
    return _rowToPetState(row);
  }

  /// Recomputes vitality from the current check-in history and persists the
  /// result. Triggers death if vitality reaches 0, and a critical notification
  /// if it drops below 20.
  ///
  /// Call after a check-in completes and at the midnight streak rollover.
  Future<void> recalculateVitality() async {
    final current = state.value;
    if (current == null) return;

    final checkInDao = ref.read(checkInDaoProvider);
    final petDao = ref.read(petDaoProvider);
    final db = ref.read(databaseProvider);

    final latestCheckins = await checkInDao.findLatest(1);
    final depthScore =
        latestCheckins.isEmpty ? 0.5 : latestCheckins.first.depthScore;

    final missedDays = _computeMissedDays(current.lastCheckinUtc);
    final consecutiveMissedDays = List.generate(missedDays, (i) => i);

    final newVitality = calculateVitality(
      streak: current.streak,
      checkInDepthScore: depthScore,
      consecutiveMissedDays: consecutiveMissedDays,
      isVulnerabilityFrozen: current.vulnerabilityFrozen,
    );

    final newVisualState = mapVitalityToState(newVitality);

    await db.transaction(() async {
      await petDao.updatePetState(PetStateTableCompanion(
        petId: Value(current.petId),
        vitality: Value(newVitality),
      ));
    });

    final updated = current.copyWith(
      vitality: newVitality,
      visualState: newVisualState,
    );
    state = AsyncData(updated);

    if (newVitality == 0) {
      await _markDead(updated);
      return;
    }

    // TODO: trigger critical notification via notificationSchedulerProvider
    // if (newVitality < 20) { ... scheduleCritical ... }

    // Milestone detection — triggers confetti/cosmetic unlock on the next
    // check-in completion event (surfaced via a separate stream provider).
    detectMilestone(current.streak);

    final sparkline =
        latestCheckins.map((c) => c.overallStatus == 'great' ? 8 : 3).toList();
    await updateWidgetData(updated, sparkline);
  }

  /// Toggles Calm Mode on/off.
  ///
  /// When enabled, loss-aversion framing is hidden and the death screen is not
  /// shown — the death mechanic still runs internally for data integrity.
  Future<void> setCalmMode({required bool enabled}) async {
    final current = state.value;
    if (current == null) return;

    final petDao = ref.read(petDaoProvider);
    final db = ref.read(databaseProvider);

    await db.transaction(() async {
      await petDao.updatePetState(PetStateTableCompanion(
        petId: Value(current.petId),
        calmMode: Value(enabled),
      ));
    });

    state = AsyncData(current.copyWith(calmMode: enabled));
  }

  /// Begins the 7-day deletion countdown.
  ///
  /// Sets [deletionScheduledAt] and writes a DELETE_INITIATED audit entry.
  /// On next app launch after 7 days [main.dart] calls
  /// [EncryptionService.destroyKey].
  Future<void> scheduleDeletion() async {
    final current = state.value;
    if (current == null) return;

    final petDao = ref.read(petDaoProvider);
    final auditLogDao = ref.read(auditLogDaoProvider);
    final db = ref.read(databaseProvider);
    final now = DateTime.now().toUtc().toIso8601String();

    await db.transaction(() async {
      await petDao.updatePetState(PetStateTableCompanion(
        petId: Value(current.petId),
        deletionScheduledAt: Value(now),
      ));
    });
    await auditLogDao.append(AuditEvent.deleteInitiated());

    state = AsyncData(current.copyWith(deletionScheduledAt: now));
  }

  /// Cancels a pending deletion within the 7-day recovery window.
  Future<void> cancelDeletion() async {
    final current = state.value;
    if (current == null) return;

    final petDao = ref.read(petDaoProvider);
    final db = ref.read(databaseProvider);

    await db.transaction(() async {
      await petDao.updatePetState(PetStateTableCompanion(
        petId: Value(current.petId),
        deletionScheduledAt: const Value(null),
      ));
    });

    state = AsyncData(current.copyWith(deletionScheduledAt: null));
  }

  /// Archives the active pet to `pet_archive` and clears `pet_state`.
  ///
  /// Call from the DeathScreen "Start again" button.
  Future<void> archivePet() async {
    final current = state.value;
    if (current == null) return;

    final checkInDao = ref.read(checkInDaoProvider);
    final petDao = ref.read(petDaoProvider);
    final archiveDao = ref.read(petArchiveDaoProvider);
    final db = ref.read(databaseProvider);

    final allCheckins = await checkInDao.findLatest(10000);

    await db.transaction(() async {
      await archiveDao.insertArchive(PetArchiveCompanion.insert(
        id: current.petId,
        name: current.name,
        species: current.species.name,
        lifespanDays: current.streak,
        totalCheckins: allCheckins.length,
        topSymptom: const Value(null),
        diedAtUtc: DateTime.now().toUtc().toIso8601String(),
      ));
      await petDao.deletePetState();
    });

    state = const AsyncData(null);
  }

  /// Sets vitality to 0 and marks the pet as dead in the DB.
  ///
  /// The pet row is kept until [archivePet] is called so the DeathScreen
  /// can display the pet's name and lifespan.
  Future<void> triggerDeath() async {
    final current = state.value;
    if (current == null) return;
    await _markDead(current);
  }

  // --- Private helpers ---

  Future<void> _markDead(PetState pet) async {
    final petDao = ref.read(petDaoProvider);
    final db = ref.read(databaseProvider);

    await db.transaction(() async {
      await petDao.updatePetState(PetStateTableCompanion(
        petId: Value(pet.petId),
        vitality: const Value(0),
      ));
    });

    state = AsyncData(pet.copyWith(
      vitality: 0,
      visualState: PetStateEnum.dead,
    ));
  }

  PetState _rowToPetState(PetStateTableData row) {
    final species = PetSpecies.values.firstWhere(
      (e) => e.name == row.species,
      orElse: () => PetSpecies.cat,
    );
    return PetState(
      petId: row.petId,
      name: row.name,
      species: species,
      vitality: row.vitality,
      visualState: mapVitalityToState(row.vitality),
      streak: row.streak,
      lastCheckinUtc: row.lastCheckinUtc,
      calmMode: row.calmMode,
      consecutiveBadDays: row.consecutiveBadDays,
      freezeAvailable: row.freezeAvailable,
      freezeLastUsedDate: row.freezeLastUsedDate,
      deletionScheduledAt: row.deletionScheduledAt,
      vulnerabilityCardShown: row.vulnerabilityCardShown,
      vulnerabilityFrozen: row.vulnerabilityFrozen,
    );
  }

  /// Returns the number of consecutive missed check-in days, capped at 30.
  ///
  /// A check-in today (0 days since last) or yesterday (1 day since) produces
  /// 0 missed days. 2 days since last → 1 missed day, etc.
  int _computeMissedDays(String? lastCheckinUtc) {
    if (lastCheckinUtc == null) return 0;
    final lastDate = DateTime.parse(lastCheckinUtc).toUtc();
    final today = DateTime.now().toUtc();
    final daysSince = today.difference(lastDate).inDays;
    return (daysSince - 1).clamp(0, 30);
  }
}
