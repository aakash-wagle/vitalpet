import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'pet_archive_dao.g.dart';

@DriftAccessor()
class PetArchiveDao extends DatabaseAccessor<AppDatabase>
    with _$PetArchiveDaoMixin {
  PetArchiveDao(super.db);

  Future<void> insertArchive(Map<String, dynamic> archivedPet) async {
    // TODO: implement
  }

  Future<List<Map<String, dynamic>>> getArchive() async {
    // TODO: implement
    return [];
  }
}
