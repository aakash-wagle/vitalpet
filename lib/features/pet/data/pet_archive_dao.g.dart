// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_archive_dao.dart';

// ignore_for_file: type=lint
mixin _$PetArchiveDaoMixin on DatabaseAccessor<AppDatabase> {
  $PetArchiveTable get petArchive => attachedDatabase.petArchive;
  PetArchiveDaoManager get managers => PetArchiveDaoManager(this);
}

class PetArchiveDaoManager {
  final _$PetArchiveDaoMixin _db;
  PetArchiveDaoManager(this._db);
  $$PetArchiveTableTableManager get petArchive =>
      $$PetArchiveTableTableManager(_db.attachedDatabase, _db.petArchive);
}
