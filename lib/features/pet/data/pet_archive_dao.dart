import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'pet_archive_dao.g.dart';

@DriftAccessor(tables: [PetArchive])
class PetArchiveDao extends DatabaseAccessor<AppDatabase>
    with _$PetArchiveDaoMixin {
  PetArchiveDao(super.db);

  /// Insert a deceased pet into the archive.
  Future<void> insertArchive(PetArchiveCompanion companion) async {
    await into(petArchive).insert(companion);
  }

  /// Return all archived pets ordered by most recently deceased first.
  Future<List<PetArchiveData>> getArchive() {
    return (select(petArchive)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.diedAtUtc)]))
        .get();
  }
}
