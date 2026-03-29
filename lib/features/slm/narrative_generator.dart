import 'package:vitalpet/features/handoff/narrative_context.dart';
import 'package:vitalpet/features/slm/medical_content_filter.dart';
import 'package:vitalpet/features/slm/slm_client.dart';

// ── Toggle ────────────────────────────────────────────────────────────────────
//
// Set [kUseSlmNarrative] to true to attempt on-device Gemma inference.
// When false the rule-based fallback runs synchronously and requires no model.
// Switch-off is intentional for the hackathon: the SLM generate() method is
// not yet wired up (SLMClient.generate throws UnimplementedError), so keeping
// this false lets the PDF pipeline work end-to-end from demo seed data.
// Flip to true once flutter_gemma is fully initialised in SLMClient.generate().
const bool kUseSlmNarrative = false;

/// Returned by [NarrativeGenerator.generate].
class HandoffNarrative {
  const HandoffNarrative({required this.headline, required this.context, required this.questions});

  /// Short bolded headline for the PDF, e.g. "Declining pattern — 30-day summary".
  final String headline;

  /// One-paragraph clinical context paragraph.
  final String context;

  /// Bullet points the clinician should ask about.
  final List<String> questions;
}

/// Generates a doctor-facing narrative from a de-identified [NarrativeContext].
///
/// Two modes — controlled by the top-level [kUseSlmNarrative] flag:
///   • false (default): deterministic rule-based generation, no model required.
///   • true: SLM inference via [SLMClient], output filtered by [MedicalContentFilter].
///
/// To switch modes, change [kUseSlmNarrative] and hot-restart. No structural
/// code changes are needed — the SLM path is already wired up and will activate
/// as soon as the model is loaded.
class NarrativeGenerator {
  const NarrativeGenerator({
    required SLMClient slmClient,
    required MedicalContentFilter filter,
  })  : _slmClient = slmClient,
        _filter = filter;

  final SLMClient _slmClient;
  final MedicalContentFilter _filter;

  /// Generates a [HandoffNarrative] from [context].
  ///
  /// Routes to [_generateRuleBased] or [_generateWithSlm] based on the toggle.
  Future<HandoffNarrative> generate(NarrativeContext context) async {
    if (kUseSlmNarrative) {
      try {
        return await _generateWithSlm(context);
      } catch (_) {
        // SLM unavailable — fall through to rule-based
      }
    }
    return _generateRuleBased(context);
  }

  // ── Rule-based path ────────────────────────────────────────────────────────

  HandoffNarrative _generateRuleBased(NarrativeContext ctx) {
    final trend = ctx.trendDirection ?? _inferTrend(ctx.averageWellnessScore);
    final avg = ctx.averageWellnessScore;
    final dayCount = ctx.dayCount;
    final completed = ctx.completedCheckins ?? ctx.totalCheckins ?? dayCount;
    final total = ctx.totalCheckins ?? dayCount;
    final topDomains = ctx.dominantSymptomDomains;

    final avgDesc = avg >= 7.5
        ? 'generally good'
        : avg >= 5.0
            ? 'moderate'
            : 'consistently low';

    final trendDesc = switch (trend) {
      'improving' => 'showing improvement over time',
      'declining' => 'showing a declining pattern that warrants attention',
      _ => 'remaining stable',
    };

    final headline = '${_capitalize(trend)} pattern — $dayCount-day wellness summary';

    final topDomainText = topDomains.isNotEmpty
        ? 'Primary symptom categories: ${topDomains.take(3).join(', ')}.'
        : '';

    final completionPct = total > 0 ? ((completed / total) * 100).round() : 0;

    final contextPara =
        'Over the past $dayCount days, the patient completed $completed of $total '
        'possible check-ins ($completionPct% completion rate). '
        'Average wellness score: ${avg.toStringAsFixed(1)}/10 — $avgDesc, $trendDesc. '
        '$topDomainText'
        '${ctx.fatigueBlockedDailyCount != null && ctx.fatigueBlockedDailyCount! > 0 ? ' Fatigue blocked daily activities on ${ctx.fatigueBlockedDailyCount} occasion(s).' : ''}'
        '${ctx.healthCorrelationSummary != null ? ' Health context: ${ctx.healthCorrelationSummary}.' : ''}';

    final questions = _buildQuestions(ctx, trend, topDomains);

    return HandoffNarrative(
      headline: headline,
      context: contextPara,
      questions: questions,
    );
  }

  List<String> _buildQuestions(
    NarrativeContext ctx,
    String trend,
    List<String> domains,
  ) {
    final q = <String>[];

    if (trend == 'declining') {
      q.add('What factors may be contributing to the declining wellness trend?');
    } else if (trend == 'improving') {
      q.add('What changes may be contributing to the improvement?');
    }

    for (final domain in domains.take(2)) {
      switch (domain) {
        case 'fever':
          q.add('Has the patient been evaluated for the fevers recorded?');
        case 'pain':
          final regions = ctx.mostFrequentPainRegions;
          if (regions != null && regions.isNotEmpty) {
            q.add('Pain was frequently reported in: ${regions.take(3).join(', ')}. '
                'Is this consistent with their diagnosis?');
          } else {
            q.add('Pain was reported frequently — are current medications adequate?');
          }
        case 'fatigue':
          q.add(
            ctx.fatigueBlockedDailyCount != null && ctx.fatigueBlockedDailyCount! > 0
                ? 'Fatigue blocked daily activities ${ctx.fatigueBlockedDailyCount} time(s). '
                    'Has anaemia, sleep quality, or medication side-effects been considered?'
                : 'How is fatigue impacting daily function?',
          );
        case 'nausea':
          q.add('Nausea was reported — could this be medication-related?');
        default:
          q.add('Have the $domain symptoms been assessed recently?');
      }
    }

    if (ctx.deviationAlertSummaries.isNotEmpty) {
      q.add('Notable days: ${ctx.deviationAlertSummaries.take(2).join('; ')}. '
          'Were these evaluated?');
    }

    if (q.isEmpty) {
      q.add('Are symptoms consistent with the patient\'s current management plan?');
    }

    return q;
  }

  String _inferTrend(double avg) {
    if (avg >= 7.0) return 'stable';
    if (avg >= 5.0) return 'stable';
    return 'declining';
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  // ── SLM path ──────────────────────────────────────────────────────────────

  Future<HandoffNarrative> _generateWithSlm(NarrativeContext ctx) async {
    final prompt = _buildSlmPrompt(ctx);
    final raw = await _slmClient.generate(
      prompt,
      timeout: const Duration(seconds: 30),
    );

    final filtered = _filter.filter(raw);

    // Parse SLM response — expected format:
    // HEADLINE: <one line>
    // CONTEXT: <paragraph>
    // QUESTIONS:
    // - <question 1>
    // - <question 2>
    final lines = filtered.text.split('\n');
    var headline = '';
    var contextText = '';
    final questions = <String>[];
    var inQuestions = false;

    for (final line in lines) {
      if (line.startsWith('HEADLINE:')) {
        headline = line.replaceFirst('HEADLINE:', '').trim();
      } else if (line.startsWith('CONTEXT:')) {
        contextText = line.replaceFirst('CONTEXT:', '').trim();
        inQuestions = false;
      } else if (line.trim() == 'QUESTIONS:') {
        inQuestions = true;
      } else if (inQuestions && line.trim().startsWith('-')) {
        questions.add(line.trim().replaceFirst('-', '').trim());
      } else if (contextText.isNotEmpty && !inQuestions && line.trim().isNotEmpty) {
        contextText = '$contextText ${line.trim()}';
      }
    }

    if (headline.isEmpty || contextText.isEmpty) {
      // Malformed SLM output — fall back to rule-based
      return _generateRuleBased(ctx);
    }

    return HandoffNarrative(
      headline: headline,
      context: contextText,
      questions: questions.isNotEmpty
          ? questions
          : _generateRuleBased(ctx).questions,
    );
  }

  String _buildSlmPrompt(NarrativeContext ctx) {
    return '''
You are a clinical data summariser. Generate a concise doctor-facing wellness summary.
DO NOT include patient names, device IDs, or personal identifiers.
DO NOT give diagnoses or treatment recommendations.
Respond ONLY in this exact format:

HEADLINE: <one short sentence>
CONTEXT: <2-3 sentence clinical paragraph>
QUESTIONS:
- <question for the clinician>
- <question for the clinician>

Data (de-identified):
- Period: ${ctx.dayCount} days
- Average wellness: ${ctx.averageWellnessScore.toStringAsFixed(1)}/10
- Trend: ${ctx.trendDirection ?? 'stable'}
- Top symptom categories: ${ctx.dominantSymptomDomains.join(', ')}
- Completion rate: ${ctx.completedCheckins ?? '?'}/${ctx.totalCheckins ?? ctx.dayCount} days
${ctx.fatigueBlockedDailyCount != null ? '- Fatigue blocked daily activities: ${ctx.fatigueBlockedDailyCount} times' : ''}
${ctx.mostFrequentPainRegions != null ? '- Frequent pain regions: ${ctx.mostFrequentPainRegions!.join(', ')}' : ''}
${ctx.healthCorrelationSummary != null ? '- Health context: ${ctx.healthCorrelationSummary}' : ''}
''';
  }
}
