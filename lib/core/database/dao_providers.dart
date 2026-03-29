import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/core/audit/audit_log_dao.dart';
import 'package:vitalpet/core/database/baseline_dao.dart';
import 'package:vitalpet/core/database/database_provider.dart';
import 'package:vitalpet/features/check_in/data/check_in_dao.dart';
import 'package:vitalpet/features/pet/data/pet_archive_dao.dart';
import 'package:vitalpet/features/pet/data/pet_dao.dart';

/// Riverpod providers for all DAO types.
///
/// Consume via `ref.read(petDaoProvider)` inside notifiers.
/// Never instantiate a DAO directly in domain or presentation code.

final petDaoProvider = Provider<PetDao>((ref) {
  return PetDao(ref.watch(databaseProvider));
});

final petArchiveDaoProvider = Provider<PetArchiveDao>((ref) {
  return PetArchiveDao(ref.watch(databaseProvider));
});

final checkInDaoProvider = Provider<CheckInDao>((ref) {
  return CheckInDao(ref.watch(databaseProvider));
});

final auditLogDaoProvider = Provider<AuditLogDao>((ref) {
  return AuditLogDao(ref.watch(databaseProvider));
});

final baselineDaoProvider = Provider<BaselineDao>((ref) {
  return BaselineDao(ref.watch(databaseProvider));
});
