import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_state.freezed.dart';
part 'pet_state.g.dart';

enum PetSpecies { cat, dog, rabbit, dragon }

enum PetStateEnum { thriving, healthy, tired, unwell, critical, dead }

@freezed
abstract class PetState with _$PetState {
  const factory PetState({
    required String id,
    required String name,
    required PetSpecies species,
    required int vitality,
    required PetStateEnum visualState,
    required int currentStreak,
    required DateTime lastCheckIn,
    DateTime? deletionScheduledAt,
    @Default(false) bool freezeActive,
  }) = _PetState;

  factory PetState.fromJson(Map<String, dynamic> json) =>
      _$PetStateFromJson(json);
}
