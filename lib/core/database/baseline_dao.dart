import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'baseline_dao.g.dart';

@DriftAccessor()
class BaselineDao extends DatabaseAccessor<AppDatabase>
    with _$BaselineDaoMixin {
  BaselineDao(super.db);

  Future<void> upsertBaseline(String domain, double value) async {
    // TODO: implement
  }

  Future<double?> getBaseline(String domain) async {
    // TODO: implement
    return null;
  }

  Future<Map<String, double>> getAllBaselines() async {
    // TODO: implement
    return {};
  }

  Future<void> upsertContextCache(String key, String value) async {
    // TODO: implement
  }

  Future<String?> getContextCache(String key) async {
    // TODO: implement
    return null;
  }
}
