import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/check_in/domain/check_in_engine.dart';

void main() {
  group('CheckInEngine', () {
    // ignore: unused_local_variable — will be used when tests are implemented
  late CheckInEngine engine;

    setUp(() {
      engine = const CheckInEngine();
    });

    test('startSession returns collecting state', () {
      // TODO: implement
    });

    test('advance progresses through question list', () {
      // TODO: implement
    });

    test('savePartial persists answers and score', () {
      // TODO: implement
    });

    test('resumePartial restores partial session', () {
      // TODO: implement
    });

    test('completeSession writes atomically', () {
      // TODO: implement
    });
  });
}
