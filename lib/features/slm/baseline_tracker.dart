import 'dart:math' show sqrt;

import 'package:vitalpet/core/constants/symptom_domains.dart';
import 'package:vitalpet/features/check_in/data/symptom_dao.dart';

/// A deviation alert for a single tracked metric.
class DeviationAlert {
  const DeviationAlert({
    required this.metric,
    required this.message,
    required this.severity,
  });

  /// The metric key, e.g. 'wellness_score', 'pain_frequency'.
  final String metric;
  final String message;

  /// Number of standard deviations below mean (always positive when alert fires).
  final double severity;
}

/// Rolling mean and stddev for one metric over a window of sessions.
class BaselineStats {
  const BaselineStats({
    required this.mean,
    required this.stddev,
    required this.sampleCount,
  });

  final double mean;
  final double stddev;
  final int sampleCount;
}

/// Computes per-category baselines and detects statistical deviations.
/// All inputs are pure Dart — no DB access from this class.
class BaselineTracker {
  const BaselineTracker();

  /// Derives baseline stats from [recent] FullCheckIn records.
  ///
  /// Tracked metrics:
  /// - `wellness_score`   — mean of CheckIn.wellnessScore
  /// - `pain_frequency`   — proportion of sessions with ≥1 pain symptom
  /// - `fatigue_frequency`
  /// - `fever_frequency`
  /// - `nausea_frequency`
  ///
  /// Returns an empty map when [recent] is empty.
  Map<String, BaselineStats> computeBaselines(List<FullCheckIn> recent) {
    if (recent.isEmpty) return {};

    final scores =
        recent.map((f) => f.checkIn.wellnessScore.toDouble()).toList();

    final n = recent.length;
    bool hasCategory(FullCheckIn f, SymptomCategory cat) =>
        f.symptoms.any((s) => s.symptom.category == cat.name);

    final painSeries = recent
        .map((f) => hasCategory(f, SymptomCategory.pain) ? 1.0 : 0.0)
        .toList();
    final fatigueSeries = recent
        .map((f) => hasCategory(f, SymptomCategory.fatigue) ? 1.0 : 0.0)
        .toList();
    final feverSeries = recent
        .map((f) => hasCategory(f, SymptomCategory.fever) ? 1.0 : 0.0)
        .toList();
    final nauseaSeries = recent
        .map((f) => hasCategory(f, SymptomCategory.nausea) ? 1.0 : 0.0)
        .toList();

    return {
      'wellness_score': _statsFor(scores),
      'pain_frequency': _statsFor(painSeries),
      'fatigue_frequency': _statsFor(fatigueSeries),
      'fever_frequency': _statsFor(feverSeries),
      'nausea_frequency': _statsFor(nauseaSeries),
    };
  }

  /// Returns a [DeviationAlert] if the last 3 consecutive [values] are all
  /// more than 1.5 standard deviations below [baseline].mean; otherwise null.
  ///
  /// Requires at least 3 values. Returns null when there are fewer than 3.
  DeviationAlert? checkDeviation(
    String metric,
    List<double> values,
    BaselineStats baseline,
  ) {
    if (values.length < 3) return null;
    if (baseline.stddev == 0) return null;

    final last3 = values.sublist(values.length - 3);
    final threshold = baseline.mean - 1.5 * baseline.stddev;
    if (!last3.every((v) => v < threshold)) return null;

    final avgLast3 = last3.reduce((a, b) => a + b) / 3;
    final sd = (baseline.mean - avgLast3) / baseline.stddev;

    return DeviationAlert(
      metric: metric,
      message:
          '$metric has been consistently below baseline for 3 sessions.',
      severity: sd,
    );
  }

  static BaselineStats _statsFor(List<double> values) {
    final n = values.length;
    if (n == 0) return const BaselineStats(mean: 0, stddev: 0, sampleCount: 0);
    final mean = values.reduce((a, b) => a + b) / n;
    final variance =
        values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) / n;
    return BaselineStats(mean: mean, stddev: sqrt(variance), sampleCount: n);
  }
}
