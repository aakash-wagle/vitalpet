import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/handoff/chart_data_builder.dart';

void main() {
  group('ChartDataBuilder', () {
    late ChartDataBuilder builder;

    setUp(() {
      builder = const ChartDataBuilder();
    });

    test('buildTrendChart returns one bar per check-in', () {
      // TODO: implement
    });

    test('buildHeatmap handles missed days gracefully', () {
      // TODO: implement — missing days should produce intensity=0 cells
    });

    test('buildTrendChart is empty for empty input', () {
      expect(builder.buildTrendChart([]), isEmpty);
    });
  });
}
