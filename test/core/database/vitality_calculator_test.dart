import 'package:flutter_test/flutter_test.dart';
// ignore: unused_import — will be used when tests are implemented
import 'package:vitalpet/features/pet/domain/vitality_calculator.dart';

void main() {
  group('calculateVitality', () {
    test('returns max vitality for perfect recent scores with no missed days',
        () {
      // TODO: implement
    });

    test('decrements vitality for each missed day', () {
      // TODO: implement
    });

    test('freeze prevents missed-day decrement for one day', () {
      // TODO: implement
    });

    test('clamps result to [0, 100]', () {
      // TODO: implement
    });
  });
}
