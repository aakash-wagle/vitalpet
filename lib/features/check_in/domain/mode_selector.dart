/// Check-in interaction mode, driven by the wellness score.
enum CheckInMode {
  /// Score 7–10: brief positive mode — slider tap alone counts.
  quick,

  /// Score 4–6: standard guided mode with 3–5 SLM-sequenced questions.
  guided,

  /// Score 1–3: conversational companion mode, pet as voice.
  companion,
}

/// Pure function — selects check-in mode from wellness score (1–10).
/// score ≤ 3 → companion · score ≤ 6 → guided · else → quick
CheckInMode selectMode(int score) {
  if (score <= 3) return CheckInMode.companion;
  if (score <= 6) return CheckInMode.guided;
  return CheckInMode.quick;
}
