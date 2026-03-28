import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';

void main() {
  group('selectMode', () {
    test('score 3 → companion', () {
      expect(selectMode(3), CheckInMode.companion);
    });

    test('score 4 → standard', () {
      expect(selectMode(4), CheckInMode.standard);
    });

    test('score 6 → standard', () {
      expect(selectMode(6), CheckInMode.standard);
    });

    test('score 7 → light', () {
      expect(selectMode(7), CheckInMode.light);
    });

    test('score 1 → companion (boundary)', () {
      expect(selectMode(1), CheckInMode.companion);
    });

    test('score 10 → light (boundary)', () {
      expect(selectMode(10), CheckInMode.light);
    });
  });
}
