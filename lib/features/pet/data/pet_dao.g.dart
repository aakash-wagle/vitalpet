// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_dao.dart';

// ignore_for_file: type=lint
mixin _$PetDaoMixin on DatabaseAccessor<AppDatabase> {
  $PetStateTableTable get petStateTable => attachedDatabase.petStateTable;
  PetDaoManager get managers => PetDaoManager(this);
}

class PetDaoManager {
  final _$PetDaoMixin _db;
  PetDaoManager(this._db);
  $$PetStateTableTableTableManager get petStateTable =>
      $$PetStateTableTableTableManager(_db.attachedDatabase, _db.petStateTable);
}
