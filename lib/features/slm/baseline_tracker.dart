import 'package:vitalpet/features/slm/slm_context.dart';

/// A deviation alert for a single metric.
class DeviationAlert {
  const DeviationAlert({
    required this.domain,
    required this.message,
    required this.severity,
  });

  final String domain;
  final String message;
  final double severity;
}

/// Computes per-domain baselines and detects statistical deviations.
class BaselineTracker {
  const BaselineTracker();

  /// Recomputes baselines from the past 14-day check-in history.
  Future<void> computeBaselines() async {
    // TODO: implement — stores derived stats via BaselineDao
  }

  /// Checks all tracked metrics against current [context].
  /// Returns a [DeviationAlert] if any metric exceeds 1.5 SD, otherwise null.
  DeviationAlert? checkAllMetrics(SLMContext context) {
    // TODO: implement
    return null;
  }
}
