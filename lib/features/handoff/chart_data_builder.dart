/// Data model for a single wellness trend bar.
class TrendBar {
  const TrendBar({required this.date, required this.score});
  final DateTime date;
  final double score;
}

/// Data model for a heatmap cell.
class HeatmapCell {
  const HeatmapCell({required this.date, required this.intensity});
  final DateTime date;
  final double intensity;
}

/// Builds chart data structures from raw check-in records.
class ChartDataBuilder {
  const ChartDataBuilder();

  /// Builds a list of [TrendBar] from daily wellness scores.
  List<TrendBar> buildTrendChart(List<Map<String, dynamic>> checkIns) {
    // TODO: implement
    return [];
  }

  /// Builds a heatmap of check-in frequency / severity.
  List<HeatmapCell> buildHeatmap(List<Map<String, dynamic>> checkIns) {
    // TODO: implement
    return [];
  }

  /// Builds a health-correlation data set correlating wellness with
  /// sleep/steps/heart-rate summaries.
  Map<String, List<double>> buildHealthCorrelation(
    List<Map<String, dynamic>> checkIns,
  ) {
    // TODO: implement
    return {};
  }
}
