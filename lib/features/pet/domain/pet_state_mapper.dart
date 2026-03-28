import 'package:vitalpet/features/pet/domain/pet_state.dart';

/// Maps a vitality value (0–100) to a PetStateEnum.
/// Pure function — no side effects.
PetStateEnum mapVitalityToState(int vitality) {
  if (vitality >= 80) return PetStateEnum.thriving;
  if (vitality >= 60) return PetStateEnum.healthy;
  if (vitality >= 40) return PetStateEnum.tired;
  if (vitality >= 20) return PetStateEnum.unwell;
  if (vitality > 0) return PetStateEnum.critical;
  return PetStateEnum.dead;
}
