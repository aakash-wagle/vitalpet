import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/check_in/domain/streak_manager.dart';

void main() {
  group('StreakManager', () {
    // ignore: unused_local_variable — will be used when tests are implemented
  late StreakManager manager;

    setUp(() {
      manager = const StreakManager();
    });

    test('streak is valid when checked in today (UTC)', () {
      // TODO: implement
    });

    test('streak is invalid after 2 missed UTC days', () {
      // TODO: implement
    });

    test('freeze prevents invalidation for exactly one missed day', () {
      // TODO: implement
    });

    test('clock tamper: future lastCheckIn does not extend streak', () {
      // TODO: implement
    });
  });
}
