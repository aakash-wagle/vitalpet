import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'symptom_dao.g.dart';

/// A single symptom row paired with its category-specific detail record.
///
/// Exactly one of [fever], [pain], [fatigue], [nausea], [other] will be
/// non-null, matching the [symptom]'s category value.
class SymptomWithDetail {
  final CheckInSymptom symptom;
  final SymptomFeverData? fever;
  final SymptomPainData? pain;
  final SymptomFatigueData? fatigue;
  final SymptomNauseaData? nausea;
  final SymptomOtherData? other;

  const SymptomWithDetail({
    required this.symptom,
    this.fever,
    this.pain,
    this.fatigue,
    this.nausea,
    this.other,
  });
}

/// All structured data for one completed (or partial) check-in session.
class FullCheckIn {
  final CheckIn checkIn;
  final List<SymptomWithDetail> symptoms;
  final CheckInSubjectiveData? subjective;

  const FullCheckIn({
    required this.checkIn,
    required this.symptoms,
    this.subjective,
  });
}

@DriftAccessor(tables: [
  CheckIns,
  CheckInSymptoms,
  SymptomFever,
  SymptomPain,
  SymptomFatigue,
  SymptomNausea,
  SymptomOther,
  CheckInSubjective,
])
class SymptomDao extends DatabaseAccessor<AppDatabase>
    with _$SymptomDaoMixin {
  SymptomDao(super.db);

  Future<void> insertSymptom(CheckInSymptomsCompanion companion) async {
    await into(checkInSymptoms).insert(companion);
  }

  Future<void> insertFever(SymptomFeverCompanion companion) async {
    await into(symptomFever).insert(companion);
  }

  Future<void> insertPain(SymptomPainCompanion companion) async {
    await into(symptomPain).insert(companion);
  }

  Future<void> insertFatigue(SymptomFatigueCompanion companion) async {
    await into(symptomFatigue).insert(companion);
  }

  Future<void> insertNausea(SymptomNauseaCompanion companion) async {
    await into(symptomNausea).insert(companion);
  }

  Future<void> insertOther(SymptomOtherCompanion companion) async {
    await into(symptomOther).insert(companion);
  }

  Future<void> insertSubjective(
      CheckInSubjectiveCompanion companion) async {
    await into(checkInSubjective).insert(companion);
  }

  Future<List<CheckInSymptom>> getSymptomsForCheckIn(
      String checkInId) {
    return (select(checkInSymptoms)
          ..where((t) => t.checkInId.equals(checkInId)))
        .get();
  }

  /// Fetches the [CheckIn] header, all [CheckInSymptom] rows, their
  /// category-specific detail records, and the optional [CheckInSubjectiveData]
  /// — all inside a single drift transaction.
  Future<FullCheckIn> getFullCheckIn(String checkInId) {
    return db.transaction(() async {
      final checkIn = await (select(checkIns)
            ..where((t) => t.id.equals(checkInId)))
          .getSingle();

      final symptomRows = await (select(checkInSymptoms)
            ..where((t) => t.checkInId.equals(checkInId)))
          .get();

      final symptomsWithDetail = <SymptomWithDetail>[];
      for (final symptom in symptomRows) {
        final fever = await (select(symptomFever)
              ..where((t) => t.symptomId.equals(symptom.id)))
            .getSingleOrNull();
        final pain = await (select(symptomPain)
              ..where((t) => t.symptomId.equals(symptom.id)))
            .getSingleOrNull();
        final fatigue = await (select(symptomFatigue)
              ..where((t) => t.symptomId.equals(symptom.id)))
            .getSingleOrNull();
        final nausea = await (select(symptomNausea)
              ..where((t) => t.symptomId.equals(symptom.id)))
            .getSingleOrNull();
        final other = await (select(symptomOther)
              ..where((t) => t.symptomId.equals(symptom.id)))
            .getSingleOrNull();

        symptomsWithDetail.add(SymptomWithDetail(
          symptom: symptom,
          fever: fever,
          pain: pain,
          fatigue: fatigue,
          nausea: nausea,
          other: other,
        ));
      }

      final subjective = await (select(checkInSubjective)
            ..where((t) => t.checkInId.equals(checkInId)))
          .getSingleOrNull();

      return FullCheckIn(
        checkIn: checkIn,
        symptoms: symptomsWithDetail,
        subjective: subjective,
      );
    });
  }
}
