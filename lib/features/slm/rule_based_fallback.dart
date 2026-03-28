import 'package:vitalpet/features/slm/slm_context.dart';
import 'package:vitalpet/features/slm/slm_output.dart';

/// Returns deterministic question sequences from cold_start_rules.json.
/// Used when [SLMClient] is unavailable or times out.
class RuleBasedFallback {
  const RuleBasedFallback(this._rules);

  // ignore: unused_field — used in getQuestions() when implemented
  final Map<String, List<String>> _rules;

  /// Returns questions ordered by priority for the given context.
  List<SLMQuestion> getQuestions(SLMContext context) {
    // TODO: implement — look up conditionFocus in _rules, map to SLMQuestion
    return [];
  }

  /// Loads rules from assets/config/cold_start_rules.json.
  static Future<RuleBasedFallback> load() async {
    // TODO: implement rootBundle load
    return const RuleBasedFallback({});
  }
}
