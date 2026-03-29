import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'check_in_dao.g.dart';

/// A lightweight view used for streak calculation.
/// [utcDate] is the "yyyy-MM-dd" UTC date; [completed] is true when the
/// check-in is not partial.
class StreakDay {
  final String utcDate;
  final bool completed;

  const StreakDay({required this.utcDate, required this.completed});
}

@DriftAccessor(tables: [CheckIns])
class CheckInDao extends DatabaseAccessor<AppDatabase>
    with _$CheckInDaoMixin {
  CheckInDao(super.db);

  /// Insert a new check-in.
  /// Must always be called inside a [db.transaction()] block.
  Future<void> insertCheckIn(CheckInsCompanion companion) async {
    await into(checkIns).insert(companion);
  }

  /// Find all check-ins whose UTC date falls within [start]..[end] (inclusive).
  /// [start] and [end] are "yyyy-MM-dd" strings.
  Future<List<CheckIn>> findByDateRange(String start, String end) {
    return (select(checkIns)
          ..where((tbl) =>
              tbl.utcDate.isBiggerOrEqualValue(start) &
              tbl.utcDate.isSmallerOrEqualValue(end))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.utcDate)]))
        .get();
  }

  /// Find the [n] most recent check-ins ordered newest-first.
  Future<List<CheckIn>> findLatest(int n) {
    return (select(checkIns)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
          ..limit(n))
        .get();
  }

  /// Update the [amendedAt] timestamp for a check-in by [id].
  /// Structured symptom data lives in the symptom tables — use [SymptomDao]
  /// to update those rows in the same transaction.
  /// Caller must write an AMENDMENT audit entry inside the same transaction.
  Future<void> amendCheckIn(String id, String amendedAt) async {
    await (update(checkIns)..where((tbl) => tbl.id.equals(id))).write(
      CheckInsCompanion(
        amendedAt: Value(amendedAt),
      ),
    );
  }

  /// Return one [StreakDay] per calendar day over the last [days] UTC days,
  /// newest-first. A day is "completed" when a non-partial check-in exists.
  Future<List<StreakDay>> getStreakData(int days) async {
    final now = DateTime.now().toUtc();
    final streakDays = <StreakDay>[];

    for (var i = 0; i < days; i++) {
      final day = now.subtract(Duration(days: i));
      final dateStr =
          '${day.year.toString().padLeft(4, '0')}-'
          '${day.month.toString().padLeft(2, '0')}-'
          '${day.day.toString().padLeft(2, '0')}';

      final row = await (select(checkIns)
            ..where((tbl) =>
                tbl.utcDate.equals(dateStr) &
                tbl.isPartial.equals(false))
            ..limit(1))
          .getSingleOrNull();

      streakDays.add(StreakDay(utcDate: dateStr, completed: row != null));
    }

    return streakDays;
  }
}
