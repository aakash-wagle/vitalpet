import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/slm/baseline_tracker.dart';

void main() {
  group('BaselineTracker', () {
    // ignore: unused_local_variable — will be used when tests are implemented
  late BaselineTracker tracker;

    setUp(() {
      tracker = const BaselineTracker();
    });

    test('no deviation for scores near baseline', () {
      // TODO: implement with mock time series
    });

    test('deviation detected when metric exceeds 1.5 SD', () {
      // TODO: implement with mock time series
    });

    test('returns null when insufficient history', () {
      // TODO: implement
    });
  });
}
