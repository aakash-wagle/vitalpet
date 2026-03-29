/// Pure function: calculates vitality (0–100) from check-in history.
///
/// Inputs:
/// - [streak]: current consecutive check-in streak in days
/// - [checkInDepthScore]: depth of the most recent check-in (0.0–1.0)
/// - [consecutiveMissedDays]: one entry per consecutive missed day in the
///   current run (values are ignored; only the length matters)
/// - [isVulnerabilityFrozen]: when true, no missed-day penalty is applied
///
/// Returns an integer vitality in [0, 100].
///
/// Penalty schedule (applied per missed day, unless frozen):
///   day 1 = -8, day 2 = -10, day 3+ = -12 each.
/// Always recomputable from raw check-in log (NFR-R-03).
int calculateVitality({
  required int streak,
  required double checkInDepthScore,
  required List<int> consecutiveMissedDays,
  required bool isVulnerabilityFrozen,
}) {
  const base = 60;
  final streakBonus = streak.clamp(0, 30);
  final depthBonus = (checkInDepthScore * 10).round();

  var penalty = 0;
  if (!isVulnerabilityFrozen) {
    for (var i = 0; i < consecutiveMissedDays.length; i++) {
      penalty += switch (i) { 0 => 8, 1 => 10, _ => 12 };
    }
  }

  return (base + streakBonus + depthBonus - penalty).clamp(0, 100);
}
