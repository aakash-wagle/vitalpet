import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/pet/domain/milestone_detector.dart';

void main() {
  group('detectMilestone', () {
    test('streak 7 → week milestone', () {
      expect(detectMilestone(7), MilestoneType.week);
    });

    test('streak 14 → twoWeeks milestone', () {
      expect(detectMilestone(14), MilestoneType.twoWeeks);
    });

    test('streak 30 → month milestone', () {
      expect(detectMilestone(30), MilestoneType.month);
    });

    test('streak 90 → quarter milestone', () {
      expect(detectMilestone(90), MilestoneType.quarter);
    });

    test('streak 8 → null (no milestone between 7 and 14)', () {
      expect(detectMilestone(8), isNull);
    });

    test('streak 15 → null (no milestone between 14 and 30)', () {
      expect(detectMilestone(15), isNull);
    });

    test('other non-milestone values → null', () {
      expect(detectMilestone(1), isNull);
      expect(detectMilestone(29), isNull);
      expect(detectMilestone(100), isNull);
    });
  });
}
