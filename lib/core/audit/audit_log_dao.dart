import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'audit_log_dao.g.dart';

/// Event types recorded in the append-only audit log.
enum AuditEvent {
  checkinWrite,
  amendment,
  filterTrigger,
  handoffExport,
  dataExport,
  deleteInitiated,
}

/// Append-only audit log DAO.
/// No update or delete operations are exposed.
@DriftAccessor()
class AuditLogDao extends DatabaseAccessor<AppDatabase>
    with _$AuditLogDaoMixin {
  AuditLogDao(super.db);

  Future<void> append(AuditEvent event, {Map<String, dynamic>? payload}) async {
    // TODO: implement insert into audit_log table
  }

  Future<void> appendInTransaction(
    AuditEvent event, {
    Map<String, dynamic>? payload,
  }) async {
    // TODO: implement — called inside an existing db.transaction()
  }
}
