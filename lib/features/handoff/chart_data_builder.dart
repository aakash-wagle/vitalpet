import 'dart:convert';
import 'package:vitalpet/core/database/app_database.dart';

/// The type of a data point in the wellness trend.
enum TrendPointType {
  /// A day where a check-in was completed.
  normal,

  /// A day with no check-in record (user skipped).
  missed,

  /// A day where the pet freeze mechanic was used.
  freeze,
}

/// One data point in the wellness trend line, one per calendar day.
class TrendPoint {
  const TrendPoint({
    required this.date,
    required this.type,
    this.score,
    this.hasSymptoms = false,
    this.hasFever = false,
    this.symptomCategoryCount = 0,
  });

  final DateTime date;
  final TrendPointType type;

  /// Wellness score 1–10, or null for missed / freeze days.
  final int? score;

  /// True when the check-in recorded at least one symptom.
  final bool hasSymptoms;

  /// True when fever was one of the recorded symptoms.
  final bool hasFever;

  /// Number of distinct symptom categories in this check-in.
  final int symptomCategoryCount;

  /// A day is notable if it had a very low score, a fever, or 2+ categories.
  bool get isNotable =>
      (score != null && score! <= 4) || hasFever || symptomCategoryCount >= 2;
}

/// A notable event entry for Page 2 of the handoff PDF.
class NotableEvent {
  const NotableEvent({
    required this.date,
    required this.reason,
    this.score,
  });

  final DateTime date;
  final String reason;
  final int? score;
}

/// Pure-Dart data builders for the handoff PDF.
/// No Flutter dependencies — safe to call from any isolate.
class ChartDataBuilder {
  ChartDataBuilder._();

  // ── Trend chart ──────────────────────────────────────────────────────────

  /// Returns one [TrendPoint] per calendar day between [start] and [end],
  /// inclusive. Days without a check-in row are marked as [TrendPointType.missed].
  static List<TrendPoint> buildTrendChart(
    List<CheckIn> checkIns,
    DateTime start,
    DateTime end,
  ) {
    final byDate = <String, CheckIn>{
      for (final ci in checkIns) ci.utcDate: ci,
    };

    final points = <TrendPoint>[];
    var cursor = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);

    while (!cursor.isAfter(endDay)) {
      final key = _fmt(cursor);
      final ci = byDate[key];
      if (ci == null) {
        points.add(TrendPoint(date: cursor, type: TrendPointType.missed));
      } else {
        final answers = _parseAnswers(ci.answersJson);
        final symptoms = (answers['symptoms'] as List<dynamic>?) ?? [];
        final categories = symptoms
            .map((s) => (s as Map<String, dynamic>)['category'] as String?)
            .whereType<String>()
            .toSet();
        points.add(TrendPoint(
          date: cursor,
          type: TrendPointType.normal,
          score: ci.wellnessScore,
          hasSymptoms: symptoms.isNotEmpty,
          hasFever: categories.contains('fever'),
          symptomCategoryCount: categories.length,
        ));
      }
      cursor = cursor.add(const Duration(days: 1));
    }
    return points;
  }

  // ── Heatmap ───────────────────────────────────────────────────────────────

  /// Returns a map of "yyyy-MM-dd" → wellness score for every check-in.
  /// Days without a check-in are absent from the map (caller renders as grey).
  static Map<String, int?> buildHeatmap(List<CheckIn> checkIns) {
    return {for (final ci in checkIns) ci.utcDate: ci.wellnessScore};
  }

  // ── Symptom frequency ─────────────────────────────────────────────────────

  /// Returns a map of symptom category → number of sessions that category
  /// appeared in. Counts each category once per session (not per symptom item).
  static Map<String, int> buildSymptomFrequency(List<CheckIn> checkIns) {
    final freq = <String, int>{};
    for (final ci in checkIns) {
      final answers = _parseAnswers(ci.answersJson);
      final symptoms = (answers['symptoms'] as List<dynamic>?) ?? [];
      final seenInSession = <String>{};
      for (final s in symptoms) {
        final cat = (s as Map<String, dynamic>)['category'] as String?;
        if (cat != null && seenInSession.add(cat)) {
          freq[cat] = (freq[cat] ?? 0) + 1;
        }
      }
    }
    return freq;
  }

  // ── Notable events ────────────────────────────────────────────────────────

  /// Filters [points] for notable events: score ≤ 4, fever, or 2+ categories.
  static List<NotableEvent> buildNotableEvents(List<TrendPoint> points) {
    final events = <NotableEvent>[];
    for (final p in points) {
      if (!p.isNotable) continue;
      final reasons = <String>[
        if (p.score != null && p.score! <= 4) 'Wellness score ${p.score}/10',
        if (p.hasFever) 'Fever recorded',
        if (p.symptomCategoryCount >= 2)
          '${p.symptomCategoryCount} symptom categories',
      ];
      events.add(NotableEvent(
        date: p.date,
        reason: reasons.join(', '),
        score: p.score,
      ));
    }
    return events;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static Map<String, dynamic> _parseAnswers(String json) {
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
