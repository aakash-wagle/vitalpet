import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'pet_dao.g.dart';

@DriftAccessor()
class PetDao extends DatabaseAccessor<AppDatabase> with _$PetDaoMixin {
  PetDao(super.db);

  Future<Map<String, dynamic>?> getPetState() async {
    // TODO: implement
    return null;
  }

  Future<void> updatePetState(Map<String, dynamic> state) async {
    // TODO: implement
  }

  Future<void> deletePetState() async {
    // TODO: implement
  }
}
