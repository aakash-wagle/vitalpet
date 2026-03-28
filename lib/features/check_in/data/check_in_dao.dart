import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'check_in_dao.g.dart';

@DriftAccessor()
class CheckInDao extends DatabaseAccessor<AppDatabase>
    with _$CheckInDaoMixin {
  CheckInDao(super.db);

  Future<void> insertCheckIn(Map<String, dynamic> data) async {
    // TODO: implement
  }

  Future<List<Map<String, dynamic>>> findByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    // TODO: implement
    return [];
  }

  Future<Map<String, dynamic>?> findLatest() async {
    // TODO: implement
    return null;
  }

  Future<void> amendCheckIn(int id, Map<String, dynamic> updates) async {
    // TODO: implement — writes AMENDMENT audit event
  }

  Future<Map<String, dynamic>> getStreakData() async {
    // TODO: implement
    return {};
  }
}
