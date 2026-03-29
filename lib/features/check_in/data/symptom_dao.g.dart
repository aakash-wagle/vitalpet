// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_dao.dart';

// ignore_for_file: type=lint
mixin _$SymptomDaoMixin on DatabaseAccessor<AppDatabase> {
  $CheckInsTable get checkIns => attachedDatabase.checkIns;
  $CheckInSymptomsTable get checkInSymptoms => attachedDatabase.checkInSymptoms;
  $SymptomFeverTable get symptomFever => attachedDatabase.symptomFever;
  $SymptomPainTable get symptomPain => attachedDatabase.symptomPain;
  $SymptomFatigueTable get symptomFatigue => attachedDatabase.symptomFatigue;
  $SymptomNauseaTable get symptomNausea => attachedDatabase.symptomNausea;
  $SymptomOtherTable get symptomOther => attachedDatabase.symptomOther;
  $CheckInSubjectiveTable get checkInSubjective =>
      attachedDatabase.checkInSubjective;
  SymptomDaoManager get managers => SymptomDaoManager(this);
}

class SymptomDaoManager {
  final _$SymptomDaoMixin _db;
  SymptomDaoManager(this._db);
  $$CheckInsTableTableManager get checkIns =>
      $$CheckInsTableTableManager(_db.attachedDatabase, _db.checkIns);
  $$CheckInSymptomsTableTableManager get checkInSymptoms =>
      $$CheckInSymptomsTableTableManager(
        _db.attachedDatabase,
        _db.checkInSymptoms,
      );
  $$SymptomFeverTableTableManager get symptomFever =>
      $$SymptomFeverTableTableManager(_db.attachedDatabase, _db.symptomFever);
  $$SymptomPainTableTableManager get symptomPain =>
      $$SymptomPainTableTableManager(_db.attachedDatabase, _db.symptomPain);
  $$SymptomFatigueTableTableManager get symptomFatigue =>
      $$SymptomFatigueTableTableManager(
        _db.attachedDatabase,
        _db.symptomFatigue,
      );
  $$SymptomNauseaTableTableManager get symptomNausea =>
      $$SymptomNauseaTableTableManager(_db.attachedDatabase, _db.symptomNausea);
  $$SymptomOtherTableTableManager get symptomOther =>
      $$SymptomOtherTableTableManager(_db.attachedDatabase, _db.symptomOther);
  $$CheckInSubjectiveTableTableManager get checkInSubjective =>
      $$CheckInSubjectiveTableTableManager(
        _db.attachedDatabase,
        _db.checkInSubjective,
      );
}
