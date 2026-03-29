import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'pet_dao.g.dart';

@DriftAccessor(tables: [PetStateTable])
class PetDao extends DatabaseAccessor<AppDatabase> with _$PetDaoMixin {
  PetDao(super.db);

  /// Returns the current pet state, or null if no pet has been created yet.
  Future<PetStateTableData?> getPetState() {
    return select(petStateTable).getSingleOrNull();
  }

  /// Insert or replace the pet state row.
  /// Use a [db.transaction()] when updating state alongside a check-in write.
  Future<void> updatePetState(PetStateTableCompanion companion) async {
    if (!companion.petId.present) {
      throw ArgumentError(
        'PetStateTableCompanion.petId must be present for updatePetState',
      );
    }

    // Full companion (onboarding/new row): upsert is safe and desired.
    if (companion.name.present && companion.species.present) {
      await into(petStateTable).insertOnConflictUpdate(companion);
      return;
    }

    // Partial companion (runtime field patch): never insert, update only.
    // This avoids Drift attempting an insert with missing required fields.
    final petId = companion.petId.value;
    final updateCompanion = companion.copyWith(
      petId: const Value.absent(),
      rowid: const Value.absent(),
    );

    await (update(
      petStateTable,
    )..where((t) => t.petId.equals(petId))).write(updateCompanion);
  }

  /// Delete the active pet state row (used during archive + restart flow).
  Future<void> deletePetState() async {
    await delete(petStateTable).go();
  }
}
