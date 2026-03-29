import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';

void main() {
  group('selectMode', () {
    test('score 1 → companion (lower bound)', () {
      expect(selectMode(1), CheckInMode.companion);
    });

    test('score 3 → companion (upper boundary)', () {
      expect(selectMode(3), CheckInMode.companion);
    });

    test('score 4 → guided (lower boundary)', () {
      expect(selectMode(4), CheckInMode.guided);
    });

    test('score 6 → guided (upper boundary)', () {
      expect(selectMode(6), CheckInMode.guided);
    });

    test('score 7 → quick (lower boundary)', () {
      expect(selectMode(7), CheckInMode.quick);
    });

    test('score 10 → quick (upper bound)', () {
      expect(selectMode(10), CheckInMode.quick);
    });
  });
}
