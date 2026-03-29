import 'dart:async';
import 'dart:convert';

import 'package:flutter_gemma/flutter_gemma.dart';

import 'package:vitalpet/features/slm/slm_context.dart';
import 'package:vitalpet/features/slm/slm_output.dart';

/// Thrown when on-device SLM inference exceeds the 3-second budget.
class SLMTimeoutException implements Exception {
  const SLMTimeoutException([this.message = 'SLM inference timed out']);
  final String message;
  @override
  String toString() => 'SLMTimeoutException: $message';
}

/// Thrown when the SLM response cannot be parsed into a valid [SLMOutput].
class SLMParseException implements Exception {
  const SLMParseException([this.message = 'SLM output parse failed']);
  final String message;
  @override
  String toString() => 'SLMParseException: $message';
}

/// Wraps flutter_gemma (MediaPipe LLM Inference API).
/// All inference is on-device — no external endpoints are ever called.
///
/// Callers must catch [SLMTimeoutException] and fall back to [RuleBasedFallback].
final class SLMClient {
  static const _timeout = Duration(milliseconds: 3000);

  const SLMClient();

  /// Generates follow-up questions for [context].
  ///
  /// Throws [SLMTimeoutException] when inference exceeds 3 seconds.
  /// Throws [SLMParseException] when the response is malformed JSON.
  Future<SLMOutput> generateQuestions(SLMContext context) async {
    final model = await FlutterGemma.getActiveModel();
    final session = await model.createSession();
    try {
      await session.addQueryChunk(
        Message(text: _buildPrompt(context), isUser: true),
      );

      final String raw;
      try {
        raw = await session.getResponse().timeout(_timeout);
      } on TimeoutException {
        throw const SLMTimeoutException();
      }

      return _parseOutput(raw);
    } finally {
      await session.close();
    }
  }

  /// Serialises [context] into the JSON prompt fed to the model.
  String _buildPrompt(SLMContext context) {
    return jsonEncode({
      'wellness_score': context.wellnessScore,
      'mode': context.mode.name,
      'recent_checkins_count': context.recentCheckins.length,
      if (context.conditionFocus != null)
        'condition_focus': context.conditionFocus,
      if (context.healthSnapshot != null)
        'health': {
          'sleep': context.healthSnapshot!.sleepVsBaselineSummary,
          'steps': context.healthSnapshot!.stepsVsBaselineSummary,
          'hr': context.healthSnapshot!.hrVsBaselineSummary,
        },
      'baseline_stats': context.baselineStats,
      'task': 'Return JSON: {"questions": [{"category": "...", "type": "binary|slider|bodyMap|text", "prompt": "...", "fieldName": "..."}]}',
    });
  }

  /// Extracts the first JSON object from [raw] and validates it as [SLMOutput].
  SLMOutput _parseOutput(String raw) {
    try {
      final jsonStart = raw.indexOf('{');
      final jsonEnd = raw.lastIndexOf('}');
      if (jsonStart == -1 || jsonEnd <= jsonStart) {
        throw const SLMParseException('No JSON object found in response');
      }
      final decoded =
          jsonDecode(raw.substring(jsonStart, jsonEnd + 1)) as Map<String, dynamic>;
      return SLMOutput.fromJson({...decoded, 'rawResponse': raw});
    } on SLMParseException {
      rethrow;
    } catch (e) {
      throw SLMParseException('Failed to parse SLM output: $e');
    }
  }
}
