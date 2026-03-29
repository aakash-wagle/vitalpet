/// Pure function: calculates vitality (0–100) from check-in history.
///
/// - [streak]: current consecutive-day streak
/// - [checkInDepthScore]: 0.0–1.0 — fraction of symptom questions answered
/// - [consecutiveMissedDays]: one entry per missed day in the current run
/// - [isVulnerabilityFrozen]: when true, no missed-day penalty is applied
///
/// Base = 60 · streak bonus capped at +30 · depth bonus 0–10
/// Graduated missed-day penalty: day 1 = −8, day 2 = −10, day 3+ = −12 each.
/// Always recomputable from the raw check-in log (NFR-R-03).
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
