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

    test('other streak values → null', () {
      expect(detectMilestone(1), isNull);
      expect(detectMilestone(15), isNull);
      expect(detectMilestone(100), isNull);
    });
  });
}
