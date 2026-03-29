/// Check-in interaction mode, driven by the overall status.
enum CheckInMode {
  /// Status "great": brief positive mode.
  light,

  /// Status "not_great": standard mode with symptom collection.
  standard,

  /// Status "not_great" with deep concerns: companion / empathic mode.
  companion,
}

/// Pure function — selects check-in mode from overall status.
CheckInMode selectMode(String overallStatus) {
  if (overallStatus == 'great') return CheckInMode.light;
  return CheckInMode.standard;
}
