import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vitalpet/core/database/app_database.dart';
import 'package:vitalpet/dev/demo_seed_config.dart';
import 'package:vitalpet/features/pet/domain/vitality_calculator.dart';

/// Applies a startup demo seed when enabled in [kEnableDemoScenarioSeed].
///
/// This is intentionally debug-only to avoid demo data entering production.
Future<void> seedDemoScenarioIfEnabled(AppDatabase db) async {
  if (!kDebugMode || !kEnableDemoScenarioSeed) return;

  final raw = await rootBundle.loadString(kDemoScenarioAssetPath);
  final scenario = _DemoScenario.fromJson(
    jsonDecode(raw) as Map<String, dynamic>,
  );

  final seeded = _buildSeedData(scenario, nowUtc: DateTime.now().toUtc());

  await db.transaction(() async {
    await db.delete(db.checkIns).go();
    await db.delete(db.petStateTable).go();

    for (final row in seeded.checkIns) {
      await db.into(db.checkIns).insert(row);
    }

    await db
        .into(db.petStateTable)
        .insert(
          PetStateTableCompanion.insert(
            petId: 'demo-${scenario.scenarioId}',
            name: scenario.petName,
            species: scenario.petSpecies,
            vitality: Value(seeded.vitality),
            streak: Value(scenario.totalLoggedDays),
            lastCheckinUtc: Value(seeded.lastCheckInUtc),
            calmMode: const Value(false),
            consecutiveBadDays: Value(seeded.trailingNotGreatDays),
            freezeAvailable: const Value(true),
            freezeLastUsedDate: const Value(null),
            deletionScheduledAt: const Value(null),
            vulnerabilityCardShown: const Value(false),
            vulnerabilityFrozen: const Value(false),
          ),
        );
  });

  debugPrint(
    'Demo seed applied from $kDemoScenarioAssetPath '
    '(${scenario.totalLoggedDays} days, last logged ${scenario.lastLoggedDaysAgo} day(s) ago).',
  );
}

class _DemoScenario {
  const _DemoScenario({
    required this.scenarioId,
    required this.petName,
    required this.petSpecies,
    required this.totalLoggedDays,
    required this.lastLoggedDaysAgo,
    required this.notGreatEvery,
  });

  final String scenarioId;
  final String petName;
  final String petSpecies;
  final int totalLoggedDays;
  final int lastLoggedDaysAgo;
  final int notGreatEvery;

  factory _DemoScenario.fromJson(Map<String, dynamic> json) {
    final totalLoggedDays = (json['totalLoggedDays'] as num?)?.toInt() ?? 0;
    final lastLoggedDaysAgo = (json['lastLoggedDaysAgo'] as num?)?.toInt() ?? 0;
    final notGreatEvery = (json['notGreatEvery'] as num?)?.toInt() ?? 0;
    final petSpecies = (json['petSpecies'] as String? ?? 'cat').trim();

    if (totalLoggedDays <= 0) {
      throw const FormatException('totalLoggedDays must be > 0');
    }
    if (lastLoggedDaysAgo < 0) {
      throw const FormatException('lastLoggedDaysAgo must be >= 0');
    }
    if (notGreatEvery <= 0) {
      throw const FormatException('notGreatEvery must be > 0');
    }
    if (petSpecies != 'cat' && petSpecies != 'dog') {
      throw const FormatException('petSpecies must be "cat" or "dog"');
    }

    return _DemoScenario(
      scenarioId: (json['scenarioId'] as String?)?.trim().isNotEmpty == true
          ? (json['scenarioId'] as String).trim()
          : 'demo',
      petName: (json['petName'] as String?)?.trim().isNotEmpty == true
          ? (json['petName'] as String).trim()
          : 'Mochi',
      petSpecies: petSpecies,
      totalLoggedDays: totalLoggedDays,
      lastLoggedDaysAgo: lastLoggedDaysAgo,
      notGreatEvery: notGreatEvery,
    );
  }
}

class _SeededData {
  const _SeededData({
    required this.checkIns,
    required this.vitality,
    required this.lastCheckInUtc,
    required this.trailingNotGreatDays,
  });

  final List<CheckInsCompanion> checkIns;
  final int vitality;
  final String lastCheckInUtc;
  final int trailingNotGreatDays;
}

_SeededData _buildSeedData(_DemoScenario scenario, {required DateTime nowUtc}) {
  final todayUtc = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
  final rows = <CheckInsCompanion>[];
  final statuses = <String>[];
  var latestDepth = 0.8;
  var latestCheckInAt = todayUtc;

  for (var i = 0; i < scenario.totalLoggedDays; i++) {
    final reverseOffset = scenario.totalLoggedDays - 1 - i;
    final day = todayUtc.subtract(
      Duration(days: scenario.lastLoggedDaysAgo + reverseOffset),
    );
    final createdAt = DateTime.utc(day.year, day.month, day.day, 12);
    final notGreat = ((i + 1) % scenario.notGreatEvery) == 0;
    final status = notGreat ? 'not_great' : 'great';
    final symptoms = notGreat
        ? _symptomsForDay(i)
        : const <Map<String, Object>>[];
    final depthScore = notGreat ? 1.0 : 0.8;

    statuses.add(status);
    latestDepth = depthScore;
    latestCheckInAt = createdAt;

    rows.add(
      CheckInsCompanion.insert(
        id: '${scenario.scenarioId}_${_fmtDate(day)}',
        utcDate: _fmtDate(day),
        localDate: _fmtDate(day),
        overallStatus: status,
        streakDay: Value(i + 1),
        mode: notGreat ? 1 : 0,
        symptomsJson: Value(jsonEncode(symptoms)),
        answersJson: jsonEncode({
          'symptoms': symptoms,
          'notes': notGreat ? 'Felt off today.' : 'Felt good today.',
        }),
        depthScore: Value(depthScore),
        isPartial: const Value(false),
        createdAt: createdAt.toIso8601String(),
      ),
    );
  }

  final trailingNotGreatDays = _countTrailingNotGreat(statuses);
  final missedDays = (scenario.lastLoggedDaysAgo - 1).clamp(0, 365);
  final vitality = calculateVitality(
    streak: scenario.totalLoggedDays,
    checkInDepthScore: latestDepth,
    consecutiveMissedDays: List.generate(missedDays, (i) => i),
    isVulnerabilityFrozen: false,
  );

  return _SeededData(
    checkIns: rows,
    vitality: vitality,
    lastCheckInUtc: latestCheckInAt.toIso8601String(),
    trailingNotGreatDays: trailingNotGreatDays,
  );
}

List<Map<String, Object>> _symptomsForDay(int i) {
  final variants = <List<Map<String, Object>>>[
    [
      {
        'category': 'pain',
        'region': 'lower_back',
        'pattern': 'constant',
        'intensity': 6,
      },
    ],
    [
      {'category': 'fatigue', 'scope': 'whole_body', 'pattern': 'intermittent'},
    ],
    [
      {'category': 'fever', 'temperature_c': 38.2, 'pattern': 'evening_spikes'},
      {'category': 'nausea', 'appetite': 'low', 'pattern': 'morning'},
    ],
  ];
  return variants[i % variants.length];
}

int _countTrailingNotGreat(List<String> statuses) {
  var count = 0;
  for (var i = statuses.length - 1; i >= 0; i--) {
    if (statuses[i] != 'not_great') break;
    count++;
  }
  return count;
}

String _fmtDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
