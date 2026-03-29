import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/handoff/chart_data_builder.dart';

void main() {
  group('ChartDataBuilder', () {
    final start = DateTime(2025, 6, 1);
    final end = DateTime(2025, 6, 3);

    test('buildTrendChart fills every day in the range', () {
      final points = ChartDataBuilder.buildTrendChart([], start, end);
      // 3 days: June 1, 2, 3
      expect(points, hasLength(3));
      expect(points.every((p) => p.type == TrendPointType.missed), isTrue);
    });

    test('buildHeatmap handles empty input', () {
      final map = ChartDataBuilder.buildHeatmap([]);
      expect(map, isEmpty);
    });

    test('buildSymptomFrequency returns empty for empty input', () {
      final freq = ChartDataBuilder.buildSymptomFrequency([]);
      expect(freq, isEmpty);
    });

    test('buildNotableEvents returns empty for no notable points', () {
      final points = ChartDataBuilder.buildTrendChart([], start, end);
      final events = ChartDataBuilder.buildNotableEvents(points);
      expect(events, isEmpty);
    });
  });
}
