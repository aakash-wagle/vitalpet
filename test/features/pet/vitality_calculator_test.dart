import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/pet/domain/vitality_calculator.dart';

void main() {
  group('calculateVitality', () {
    // --- Base cases ---
    test('base score with no streak and no missed days', () {
      // base=60, streakBonus=0, depthBonus=5 (0.5*10), penalty=0
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.5,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        65,
      );
    });

    test('max streak bonus (+30) at streak=30', () {
      // base=60, streakBonus=30, depthBonus=0, penalty=0 → 90
      expect(
        calculateVitality(
          streak: 30,
          checkInDepthScore: 0.0,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        90,
      );
    });

    test('streak bonus capped at 30 for streak > 30', () {
      // streakBonus never exceeds 30
      expect(
        calculateVitality(
          streak: 100,
          checkInDepthScore: 0.0,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        90,
      );
    });

    test('max depth bonus (+10) at depthScore=1.0', () {
      // base=60, streakBonus=0, depthBonus=10, penalty=0 → 70
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 1.0,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        70,
      );
    });

    // --- Penalty escalation ---
    test('1 missed day applies -8 penalty', () {
      // base=60, +0+5 -8 = 57
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.5,
          consecutiveMissedDays: [1],
          isVulnerabilityFrozen: false,
        ),
        57,
      );
    });

    test('2 missed days apply -8 then -10 = -18 penalty', () {
      // base=60 +0+5 -18 = 47
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.5,
          consecutiveMissedDays: [1, 2],
          isVulnerabilityFrozen: false,
        ),
        47,
      );
    });

    test('3 missed days apply -8 -10 -12 = -30 penalty', () {
      // base=60 +0+5 -30 = 35
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.5,
          consecutiveMissedDays: [1, 2, 3],
          isVulnerabilityFrozen: false,
        ),
        35,
      );
    });

    test('4+ missed days: day 3+ each cost -12', () {
      // penalty = 8+10+12+12 = 42; base=60+0+5-42=23
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.5,
          consecutiveMissedDays: [1, 2, 3, 4],
          isVulnerabilityFrozen: false,
        ),
        23,
      );
    });

    // --- Vulnerability freeze ---
    test('frozen vulnerability: no penalty even with missed days', () {
      // No penalty applied when frozen
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.5,
          consecutiveMissedDays: [1, 2, 3, 4, 5],
          isVulnerabilityFrozen: true,
        ),
        65, // base=60+0+5 with no penalty
      );
    });

    // --- Clamp boundaries ---
    test('result is clamped to 0 at minimum', () {
      // Heavy missed-days penalty should not go below 0
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.0,
          consecutiveMissedDays: List.generate(20, (i) => i),
          isVulnerabilityFrozen: false,
        ),
        0,
      );
    });

    test('result is clamped to 100 at maximum', () {
      // Even best-case inputs cannot exceed 100
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

    // --- Depth bonus rounding ---
    test('depthScore 0.25 rounds to +3 (0.25 * 10 = 2.5 → round = 3)', () {
      // base=60+0+3=63
      expect(
        calculateVitality(
          streak: 0,
          checkInDepthScore: 0.25,
          consecutiveMissedDays: [],
          isVulnerabilityFrozen: false,
        ),
        63,
      );
    });
  });
}
