import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'baseline_dao.g.dart';

@DriftAccessor(tables: [BaselineStats, SlmContextCache])
class BaselineDao extends DatabaseAccessor<AppDatabase>
    with _$BaselineDaoMixin {
  BaselineDao(super.db);

  /// Insert or replace a baseline stats row for [companion.metric].
  Future<void> upsertBaseline(BaselineStatsCompanion companion) async {
    await into(baselineStats).insertOnConflictUpdate(companion);
  }

  /// Retrieve the baseline stats for a single [metric], or null if absent.
  Future<BaselineStat?> getBaseline(String metric) {
    return (select(baselineStats)
          ..where((tbl) => tbl.metric.equals(metric)))
        .getSingleOrNull();
  }

  /// Retrieve all baseline stats rows as a map keyed by metric name.
  Future<Map<String, BaselineStat>> getAllBaselines() async {
    final rows = await select(baselineStats).get();
    return {for (final row in rows) row.metric: row};
  }

  /// Insert or replace the SLM context snapshot for a given [date].
  Future<void> upsertContextCache(String date, String snapshot) async {
    await into(slmContextCache).insertOnConflictUpdate(
      SlmContextCacheCompanion.insert(
        date: date,
        contextSnapshot: snapshot,
      ),
    );
  }

  /// Retrieve the SLM context snapshot for [date], or null if not cached.
  Future<String?> getContextCache(String date) async {
    final row = await (select(slmContextCache)
          ..where((tbl) => tbl.date.equals(date)))
        .getSingleOrNull();
    return row?.contextSnapshot;
  }
}
