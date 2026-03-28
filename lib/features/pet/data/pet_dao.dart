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
    await into(petStateTable).insertOnConflictUpdate(companion);
  }

  /// Delete the active pet state row (used during archive + restart flow).
  Future<void> deletePetState() async {
    await delete(petStateTable).go();
  }
}
