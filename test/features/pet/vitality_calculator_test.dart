import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/pet/domain/vitality_calculator.dart';

void main() {
  group('calculateVitality', () {
    test('zero streak, no missed days, zero depth → base 60', () {
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.0,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        60,
      );
    });

    test('max streak bonus (+30 cap) with full depth → 100', () {
      expect(
        calculateVitality(
          streak: 30,
          checkInDepthScore: 1.0,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        100,
      );
    });

    test('streak above 30 is still capped at +30', () {
      expect(
        calculateVitality(
          streak: 100,
          checkInDepthScore: 0.0,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        90, // 60 + 30
      );
    });

    test('1 missed day → −8 penalty', () {
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.0,
          consecutiveMissedDays: [1],
          isVulnerabilityFrozen: false,
        ),
        52, // 60 − 8
      );
    });

    test('2 consecutive missed days → −8 −10 penalty', () {
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.0,
          consecutiveMissedDays: [1, 2],
          isVulnerabilityFrozen: false,
        ),
        42, // 60 − 8 − 10
      );
    });

    test('3 consecutive missed days → −8 −10 −12 penalty', () {
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.0,
          consecutiveMissedDays: [1, 2, 3],
          isVulnerabilityFrozen: false,
        ),
        30, // 60 − 30
      );
    });

    test('4+ missed days → −8 −10 −12 −12 (day 3+ all −12)', () {
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.0,
          consecutiveMissedDays: [1, 2, 3, 4],
          isVulnerabilityFrozen: false,
        ),
        18, // 60 − 8 − 10 − 12 − 12
      );
    });

    test('vulnerability freeze suppresses all missed-day penalties', () {
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.0,
          consecutiveMissedDays: [1, 2, 3, 4, 5],
          isVulnerabilityFrozen: true,
        ),
        60, // no penalty applied
      );
    });

    test('depth bonus 0.5 → +5', () {
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.5,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        65, // 60 + 5
      );
    });

    test('depth bonus rounds correctly for 0.95 → +10 (rounds to 10)', () {
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.95,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        70, // 60 + 10 (rounds to 10)
      );
    });

    test('result is clamped to minimum 0 even with heavy penalties', () {
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.0,
          // 60 − (8+10+12+12+12+12+12) = 60 − 78 < 0
          consecutiveMissedDays: [1, 2, 3, 4, 5, 6, 7],
          isVulnerabilityFrozen: false,
        ),
        0,
      );
    });

    test('result is clamped to maximum 100', () {
      expect(
        calculateVitality(
          streak: 999,
          checkInDepthScore: 1.0,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        100,
      );
    });
  });
}
