/// App-wide constants. Tweak here — never scatter magic numbers in feature code.
abstract final class AppConstants {
  /// SLM inference timeout in milliseconds.
  static const int slmTimeoutMs = 3000;

  /// Consecutive missed days before the pet is marked dead.
  static const int maxMissedDaysBeforeDeath = 3;

  /// Days in the data-deletion recovery window.
  static const int deletionRecoveryWindowDays = 7;

  /// Standard-deviation threshold for deviation alerts.
  static const double deviationAlertThreshold = 1.5;

  /// Consecutive bad days before vulnerability card appears.
  static const int vulnerabilityBadDayThreshold = 5;

  /// Minimum / maximum pet name length.
  static const int petNameMinLength = 2;
  static const int petNameMaxLength = 20;

  /// Streak-freeze maximum uses per 30-day window.
  static const int maxFreezeUsesPerMonth = 2;
}
