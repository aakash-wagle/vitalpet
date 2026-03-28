import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Schedules all VitalPet push notifications.
/// Payloads contain ONLY: pet name, generic copy, and pet visual state.
/// Never include wellness scores, symptom names, or health metrics.
class NotificationScheduler {
  const NotificationScheduler(this._plugin);

  // ignore: unused_field — used when scheduling methods are implemented
  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> schedulePrimary({
    required String petName,
    required int petStateIndex,
    required TimeOfDay time,
  }) async {
    // TODO: implement daily check-in reminder
  }

  Future<void> scheduleSecondary({
    required String petName,
    required TimeOfDay time,
  }) async {
    // TODO: implement secondary reminder for missed check-in
  }

  Future<void> scheduleCritical({required String petName}) async {
    // TODO: implement critical alert when pet is near death
  }

  Future<void> scheduleMilestone({
    required String petName,
    required int streak,
  }) async {
    // TODO: implement milestone celebration notification
  }
}
