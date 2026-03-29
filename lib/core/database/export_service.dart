import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vitalpet/core/audit/audit_log_dao.dart';
import 'package:vitalpet/core/database/baseline_dao.dart';
import 'package:vitalpet/core/database/dao_providers.dart';
import 'package:vitalpet/features/check_in/data/check_in_dao.dart';
import 'package:vitalpet/features/pet/data/pet_archive_dao.dart';
import 'package:vitalpet/features/pet/data/pet_dao.dart';

/// Serialises all user data to a pretty-printed JSON string and shares it
/// via the native share sheet.
///
/// Includes: check_ins, pet_state, pet_archive, baseline_stats.
/// Excludes: audit_log (internal), slm_context_cache (reconstructable).
/// Writes a DATA_EXPORT audit entry on every successful export.
class ExportService {
  const ExportService({
    required CheckInDao checkInDao,
    required PetDao petDao,
    required PetArchiveDao petArchiveDao,
    required BaselineDao baselineDao,
    required AuditLogDao auditLogDao,
  })  : _checkInDao = checkInDao,
        _petDao = petDao,
        _petArchiveDao = petArchiveDao,
        _baselineDao = baselineDao,
        _auditLogDao = auditLogDao;

  final CheckInDao _checkInDao;
  final PetDao _petDao;
  final PetArchiveDao _petArchiveDao;
  final BaselineDao _baselineDao;
  final AuditLogDao _auditLogDao;

  /// Builds a JSON string containing all exportable user data.
  ///
  /// schemaVersion: 2 — bump when the export schema changes.
  Future<String> exportAllData() async {
    final checkins = await _checkInDao.findAll();
    final pet = await _petDao.getPetState();
    final archive = await _petArchiveDao.getArchive();
    final baselines = await _baselineDao.getAllBaselines();

    final data = <String, dynamic>{
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'schemaVersion': 2,
      'check_ins': checkins
          .map(
            (c) => <String, dynamic>{
              'id': c.id,
              'utcDate': c.utcDate,
              'localDate': c.localDate,
              'overallStatus': c.overallStatus,
              'streakDay': c.streakDay,
              'mode': c.mode,
              'symptomsJson': c.symptomsJson,
              'answersJson': c.answersJson,
              'freeNotes': c.freeNotes,
              'depthScore': c.depthScore,
              'isPartial': c.isPartial,
              'amendedAt': c.amendedAt,
              'createdAt': c.createdAt,
            },
          )
          .toList(),
      'pet_state': pet == null
          ? null
          : <String, dynamic>{
              'petId': pet.petId,
              'name': pet.name,
              'species': pet.species,
              'vitality': pet.vitality,
              'streak': pet.streak,
              'lastCheckinUtc': pet.lastCheckinUtc,
              'calmMode': pet.calmMode,
              'consecutiveBadDays': pet.consecutiveBadDays,
              'freezeAvailable': pet.freezeAvailable,
              'freezeLastUsedDate': pet.freezeLastUsedDate,
              'deletionScheduledAt': pet.deletionScheduledAt,
            },
      'pet_archive': archive
          .map(
            (a) => <String, dynamic>{
              'id': a.id,
              'name': a.name,
              'species': a.species,
              'lifespanDays': a.lifespanDays,
              'totalCheckins': a.totalCheckins,
              'topSymptom': a.topSymptom,
              'diedAtUtc': a.diedAtUtc,
            },
          )
          .toList(),
      'baseline_stats': baselines.map(
        (key, value) => MapEntry(
          key,
          <String, dynamic>{
            'metric': value.metric,
            'mean14d': value.mean14d,
            'stddev14d': value.stddev14d,
            'sampleCount': value.sampleCount,
            'lastComputedUtc': value.lastComputedUtc,
          },
        ),
      ),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Exports all data to a temporary JSON file and opens the native share sheet.
  /// Writes a DATA_EXPORT audit entry on success.
  Future<void> shareExport() async {
    final json = await exportAllData();

    final tmpDir = await getTemporaryDirectory();
    final file = File('${tmpDir.path}/vitalpet_export.json');
    await file.writeAsString(json);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: 'VitalPet health data export',
    );

    await _auditLogDao.append(AuditEvent.dataExport());
  }
}

/// Riverpod provider for [ExportService].
final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService(
    checkInDao: ref.watch(checkInDaoProvider),
    petDao: ref.watch(petDaoProvider),
    petArchiveDao: ref.watch(petArchiveDaoProvider),
    baselineDao: ref.watch(baselineDaoProvider),
    auditLogDao: ref.watch(auditLogDaoProvider),
  );
});
