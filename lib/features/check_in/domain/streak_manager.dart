/// Manages check-in streak validity and freeze tokens.
class StreakManager {
  const StreakManager();

  /// Returns true if the streak is still alive given the last check-in date
  /// and any active freeze.
  bool isStreakValid({
    required DateTime lastCheckIn,
    required DateTime now,
    required bool freezeActive,
  }) {
    // TODO: implement UTC day boundary logic
    throw UnimplementedError();
  }

  /// Activates a streak freeze token for the current day.
  Future<void> activateFreeze() async {
    // TODO: implement — check monthly quota
  }

  /// Resets streak to 0 and removes any active freeze.
  Future<void> resetStreak() async {
    // TODO: implement
  }
}
