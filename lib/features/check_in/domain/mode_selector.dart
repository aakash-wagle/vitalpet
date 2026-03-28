/// Check-in interaction mode, driven by the wellness score.
enum CheckInMode {
  /// Score 7–10: brief positive mode.
  light,

  /// Score 4–6: standard mode.
  standard,

  /// Score 1–3: companion / empathic mode with follow-up questions.
  companion,
}

/// Pure function — selects check-in mode from wellness score (1–10).
CheckInMode selectMode(int score) {
  if (score >= 7) return CheckInMode.light;
  if (score >= 4) return CheckInMode.standard;
  return CheckInMode.companion;
}
