import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/slm/medical_content_filter.dart';

void main() {
  group('MedicalContentFilter', () {
    late MedicalContentFilter filter;

    setUp(() {
      filter = const MedicalContentFilter(
        ['diagnose', 'you have', 'prescription', 'take this'],
      );
    });

    test('blocked phrase returns safe=false', () {
      final result = filter.filter('I can diagnose your condition');
      expect(result.safe, isFalse);
    });

    test('blocked phrase returns safeFallback text', () {
      final result = filter.filter('I can diagnose your condition');
      expect(result.text, equals(MedicalContentFilter.safeFallback));
    });

    test('safeFallback is the expected constant string', () {
      expect(
        MedicalContentFilter.safeFallback,
        equals(
          "I'm here to help you remember — please speak to your doctor.",
        ),
      );
    });

    test('safe content passes through unchanged', () {
      const safe = 'How did you sleep last night?';
      final result = filter.filter(safe);
      expect(result.safe, isTrue);
      expect(result.text, safe);
    });

    test('case-insensitive matching', () {
      final result = filter.filter('YOU HAVE high blood pressure');
      expect(result.safe, isFalse);
    });

    test('fallback text is generic and contains no PHI', () {
      final result = filter.filter('take this medication');
      expect(result.text, isNotEmpty);
      expect(result.text.toLowerCase(), isNot(contains('medication')));
    });

    test('empty string is safe', () {
      final result = filter.filter('');
      expect(result.safe, isTrue);
      expect(result.text, isEmpty);
    });

    test('multiple patterns — first match returns false', () {
      final result = filter.filter('here is a prescription for you');
      expect(result.safe, isFalse);
    });
  });
}
