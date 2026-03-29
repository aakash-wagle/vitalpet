import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_state.freezed.dart';
part 'pet_state.g.dart';

enum PetSpecies { cat, dog, rabbit, dragon }

/// Maps to the visual state enum stored in pet_state.
/// Naming: thriving / healthy / tired / unwell / critical / dead.
enum PetStateEnum { thriving, healthy, tired, unwell, critical, dead }

@freezed
abstract class PetState with _$PetState {
  const PetState._();

  const factory PetState({
    required String petId,
    required String name,
    required PetSpecies species,
    required int vitality,
    required PetStateEnum visualState,
    required int streak,
    String? lastCheckinUtc,
    @Default(false) bool calmMode,
    @Default(0) int consecutiveBadDays,
    @Default(true) bool freezeAvailable,
    String? freezeLastUsedDate,
    String? deletionScheduledAt,
    @Default(false) bool vulnerabilityCardShown,
    @Default(false) bool vulnerabilityFrozen,
    @Default([]) List<String> pendingAlerts,
  }) = _PetState;

  factory PetState.fromJson(Map<String, dynamic> json) =>
      _$PetStateFromJson(json);

  /// Human-readable description of the pet's current state for accessibility.
  String get stateName => switch (visualState) {
        PetStateEnum.thriving => 'thriving',
        PetStateEnum.healthy => 'happy',
        PetStateEnum.tired => 'a bit tired',
        PetStateEnum.unwell => 'unwell',
        PetStateEnum.critical => 'in critical condition',
        PetStateEnum.dead => 'no longer with us',
      };

  /// Maps the visual state to the 1–5 asset index used in PNG filenames.
  /// 1=thriving, 2=happy, 3=neutral, 4=unwell, 5=critical/dead.
  int get stateIndex => switch (visualState) {
        PetStateEnum.thriving => 1,
        PetStateEnum.healthy => 2,
        PetStateEnum.tired => 3,
        PetStateEnum.unwell => 4,
        PetStateEnum.critical || PetStateEnum.dead => 5,
      };
}
