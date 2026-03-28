/// Pure function: calculates vitality (0–100) from check-in history.
///
/// Inputs:
/// - [recentScores]: wellness scores (1–10) for the past N days
/// - [missedDays]: consecutive missed check-in days
/// - [freezeActive]: whether a streak freeze token is in effect today
///
/// Returns an integer vitality in [0, 100].
int calculateVitality({
  required List<int> recentScores,
  required int missedDays,
  required bool freezeActive,
}) {
  // TODO: implement formula
  throw UnimplementedError();
}
