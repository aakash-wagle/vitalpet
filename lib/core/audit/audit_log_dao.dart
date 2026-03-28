import 'package:drift/drift.dart';
import 'package:vitalpet/core/database/app_database.dart';

part 'audit_log_dao.g.dart';

/// Immutable record describing an auditable event.
///
/// Constructors mirror the required event types from the security rules.
/// The [payloadHash] field stores a SHA-256 hex digest — never raw content.
class AuditEvent {
  final String eventType;
  final String? sessionId;
  final String? payloadHash;

  const AuditEvent._({
    required this.eventType,
    this.sessionId,
    this.payloadHash,
  });

  /// A completed or partial check-in was committed to the database.
  factory AuditEvent.checkinWrite({
    required String sessionId,
    required String payloadHash,
  }) =>
      AuditEvent._(
        eventType: 'CHECKIN_WRITE',
        sessionId: sessionId,
        payloadHash: payloadHash,
      );

  /// The user edited a same-day check-in.
  factory AuditEvent.amendment({
    required String sessionId,
    required String payloadHash,
  }) =>
      AuditEvent._(
        eventType: 'AMENDMENT',
        sessionId: sessionId,
        payloadHash: payloadHash,
      );

  /// [MedicalContentFilter] blocked SLM output.
  /// [payloadHash] is SHA-256 of the raw (blocked) text — never the text itself.
  factory AuditEvent.filterTrigger({required String payloadHash}) =>
      AuditEvent._(
        eventType: 'FILTER_TRIGGER',
        payloadHash: payloadHash,
      );

  /// The doctor-handoff PDF was generated.
  /// [payloadHash] is SHA-256 of the date-range string, e.g. "2025-06-01/2025-06-30".
  factory AuditEvent.handoffExport({required String payloadHash}) =>
      AuditEvent._(
        eventType: 'HANDOFF_EXPORT',
        payloadHash: payloadHash,
      );

  /// The user triggered a full JSON data export.
  factory AuditEvent.dataExport() =>
      const AuditEvent._(eventType: 'DATA_EXPORT');

  /// The user initiated the 7-day data-deletion countdown.
  factory AuditEvent.deleteInitiated() =>
      const AuditEvent._(eventType: 'DELETE_INITIATED');
}

/// Append-only DAO for the audit_log table.
///
/// Exposes only [append] and [appendInTransaction].
/// No update(), no delete(), no clear() — ever.
@DriftAccessor(tables: [AuditLog])
class AuditLogDao extends DatabaseAccessor<AppDatabase>
    with _$AuditLogDaoMixin {
  AuditLogDao(super.db);

  /// Writes [event] to the audit log outside any existing transaction.
  Future<void> append(AuditEvent event) async {
    await into(auditLog).insert(
      AuditLogCompanion.insert(
        eventType: event.eventType,
        utcTimestamp: DateTime.now().toUtc().toIso8601String(),
        sessionId: Value(event.sessionId),
        payloadHash: Value(event.payloadHash),
      ),
    );
  }

  /// Writes [event] to the audit log inside an existing [db.transaction()] block.
  ///
  /// Call this variant when you need the audit entry to be part of the same
  /// atomic transaction as the check-in or pet-state write.
  Future<void> appendInTransaction(AuditEvent event) async {
    await into(auditLog).insert(
      AuditLogCompanion.insert(
        eventType: event.eventType,
        utcTimestamp: DateTime.now().toUtc().toIso8601String(),
        sessionId: Value(event.sessionId),
        payloadHash: Value(event.payloadHash),
      ),
    );
  }
}
