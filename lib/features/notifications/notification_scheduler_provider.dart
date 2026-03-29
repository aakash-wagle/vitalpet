import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/features/notifications/notification_scheduler.dart';

/// Provides a lazily-initialised [FlutterLocalNotificationsPlugin].
final _notificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
  final plugin = FlutterLocalNotificationsPlugin();
  const initSettings = InitializationSettings(
    iOS: DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    ),
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  plugin.initialize(initSettings);
  return plugin;
});

/// Provides [NotificationScheduler] for scheduling reminders.
final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return NotificationScheduler(ref.watch(_notificationsPluginProvider));
});
