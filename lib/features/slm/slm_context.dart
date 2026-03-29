import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vitalpet/features/check_in/data/symptom_dao.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/health/health_adapter.dart';

part 'slm_context.freezed.dart';

/// Context passed to the SLM for question sequencing.
/// Contains only de-identified, derived data — never raw health values.
/// [recentCheckins] carries structured symptom data from SymptomDao.getFullCheckIn().
@freezed
abstract class SLMContext with _$SLMContext {
  const factory SLMContext({
    required int wellnessScore,
    required CheckInMode mode,
    required List<FullCheckIn> recentCheckins,
    required Map<String, double> baselineStats,
    HealthSnapshot? healthSnapshot,
    String? conditionFocus,
    String? streakFreezeReason,
  }) = _SLMContext;
}
