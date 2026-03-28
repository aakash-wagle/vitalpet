import 'package:flutter/material.dart' show TimeOfDay;

/// Analyses notification open history and suggests a better reminder time.
class PatternAdapter {
  const PatternAdapter();

  /// Returns a suggested [TimeOfDay] after at least 7 days of open-rate data.
  /// Returns null if insufficient data is available.
  Future<TimeOfDay?> suggestReminderTime() async {
    // TODO: implement open-rate analysis
    return null;
  }
}
