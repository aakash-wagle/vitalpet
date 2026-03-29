import 'package:flutter_test/flutter_test.dart';
// Hide the drift table class — we use the domain BaselineStats from baseline_tracker.dart.
import 'package:vitalpet/core/database/app_database.dart' hide BaselineStats;
import 'package:vitalpet/features/check_in/data/symptom_dao.dart';
import 'package:vitalpet/features/slm/baseline_tracker.dart';

// ---------------------------------------------------------------------------
// Fixture helpers
// ---------------------------------------------------------------------------

CheckIn _checkIn(String id, int wellnessScore) => CheckIn(
      id: id,
      utcDate: '2026-03-$id',
      localDate: '2026-03-$id',
      wellnessScore: wellnessScore,
      mode: 1,
      depthScore: 0.0,
      isPartial: false,
      createdAt: '2026-03-${id}T10:00:00Z',
    );

CheckInSymptom _symptom(String id, String checkInId, String category) =>
    CheckInSymptom(
      id: id,
      checkInId: checkInId,
      category: category,
    );

FullCheckIn _fullCheckIn(
  String id,
  int wellnessScore, {
  List<String> categories = const [],
}) =>
    FullCheckIn(
      checkIn: _checkIn(id, wellnessScore),
      symptoms: categories
          .map((c) => SymptomWithDetail(
                symptom: _symptom('sym_${id}_$c', id, c),
              ))
          .toList(),
    );

void main() {
  group('BaselineTracker.computeBaselines', () {
    late BaselineTracker tracker;

    setUp(() {
      tracker = const BaselineTracker();
    });

    test('returns empty map for empty input', () {
      expect(tracker.computeBaselines([]), isEmpty);
    });

    test('computes correct wellness_score mean', () {
      final checkins = [
        _fullCheckIn('01', 8),
        _fullCheckIn('02', 6),
        _fullCheckIn('03', 7),
        _fullCheckIn('04', 9),
      ];
      final baselines = tracker.computeBaselines(checkins);
      expect(baselines['wellness_score']!.mean, closeTo(7.5, 0.01));
    });

    test('computes correct pain_frequency', () {
      final checkins = [
        _fullCheckIn('01', 6, categories: ['pain']),
        _fullCheckIn('02', 7),
        _fullCheckIn('03', 5, categories: ['pain']),
        _fullCheckIn('04', 8),
      ];
      final baselines = tracker.computeBaselines(checkins);
      expect(baselines['pain_frequency']!.mean, closeTo(0.5, 0.01));
    });

    test('all 5 metric keys are present', () {
      final checkins = [_fullCheckIn('01', 7)];
      final baselines = tracker.computeBaselines(checkins);
      expect(baselines.keys, containsAll([
        'wellness_score',
        'pain_frequency',
        'fatigue_frequency',
        'fever_frequency',
        'nausea_frequency',
      ]));
    });

    test('uses FullCheckIn.symptoms — not answersJson', () {
      // FullCheckIn has structured symptom rows, no answersJson field.
      // This test documents the contract: pain_frequency is derived from
      // SymptomWithDetail rows, not any JSON blob.
      final checkins = [
        _fullCheckIn('01', 5, categories: ['pain', 'fatigue']),
        _fullCheckIn('02', 6),
      ];
      final baselines = tracker.computeBaselines(checkins);
      expect(baselines['pain_frequency']!.mean, closeTo(0.5, 0.01));
      expect(baselines['fatigue_frequency']!.mean, closeTo(0.5, 0.01));
      expect(baselines['nausea_frequency']!.mean, closeTo(0.0, 0.01));
    });
  });

  group('BaselineTracker.checkDeviation', () {
    late BaselineTracker tracker;
    late BaselineStats baseline;

    setUp(() {
      tracker = const BaselineTracker();
      // mean=7, stddev=1 → 1.5 SD threshold = 5.5
      baseline = const BaselineStats(mean: 7.0, stddev: 1.0, sampleCount: 14);
    });

    test('returns null when fewer than 3 values', () {
      expect(tracker.checkDeviation('wellness_score', [4.0, 5.0], baseline), isNull);
    });

    test('returns null when exactly 2 values are below threshold (not 3)', () {
      // last 3 values: 5.0, 5.0, 8.0 — only 2 below threshold 5.5
      final values = [7.0, 7.0, 8.0, 8.0, 5.0, 5.0, 8.0];
      expect(tracker.checkDeviation('wellness_score', values, baseline), isNull);
    });

    test('returns DeviationAlert when exactly 3 consecutive values are below 1.5 SD', () {
      // All 3 below 5.5 (threshold = 7.0 - 1.5*1.0)
      final values = [7.0, 8.0, 7.0, 5.0, 5.0, 5.0];
      final alert = tracker.checkDeviation('wellness_score', values, baseline);
      expect(alert, isNotNull);
      expect(alert!.metric, equals('wellness_score'));
      expect(alert.severity, greaterThan(0));
    });

    test('no alert when last 3 values are within 1.5 SD of mean', () {
      // Values around mean (7.0 ± 1.0) — threshold is 5.5, these are above
      final values = [7.0, 6.5, 7.2, 6.8, 7.1, 6.9];
      expect(tracker.checkDeviation('wellness_score', values, baseline), isNull);
    });

    test('no alert when only the last value is below threshold', () {
      final values = [7.0, 7.0, 7.0, 7.0, 8.0, 5.0];
      expect(tracker.checkDeviation('wellness_score', values, baseline), isNull);
    });

    test('alert metric field matches the provided metric key', () {
      final values = [5.0, 5.0, 5.0];
      final alert =
          tracker.checkDeviation('fatigue_frequency', values, baseline);
      expect(alert?.metric, equals('fatigue_frequency'));
    });

    test('returns null when stddev is zero (no variance — cannot compute SD)', () {
      const flat = BaselineStats(mean: 7.0, stddev: 0, sampleCount: 14);
      final values = [7.0, 7.0, 7.0];
      expect(tracker.checkDeviation('wellness_score', values, flat), isNull);
    });
  });
}
