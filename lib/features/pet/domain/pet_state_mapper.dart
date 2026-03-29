import 'package:vitalpet/features/pet/domain/pet_state.dart';

/// Special moments that trigger unique pet visuals outside the vitality range.
enum SpecialPetMoment { lowWellnessSubmitted, milestone }

/// Maps a vitality value (0–100) to a PetStateEnum.
/// Pure function — no side effects. Used by domain layer to update [PetState.visualState].
PetStateEnum mapVitalityToState(int vitality) {
  if (vitality >= 80) return PetStateEnum.thriving;
  if (vitality >= 60) return PetStateEnum.healthy;
  if (vitality >= 40) return PetStateEnum.tired;
  if (vitality >= 20) return PetStateEnum.unwell;
  if (vitality > 0) return PetStateEnum.critical;
  return PetStateEnum.dead;
}

/// Maps vitality values and special moments to dog PNG asset paths.
///
/// All assets live in `assets/images/pets/` and include alpha transparency.
class PetStateMapper {
  const PetStateMapper._();

  /// Returns the asset path for the dog image corresponding to [vitality].
  ///   80–100 → greeting.png  (Thriving)
  ///   60–79  → curious.png   (Happy)
  ///   40–59  → alert.png     (Neutral)
  ///   20–39  → sad.png       (Unwell)
  ///   1–19   → depressed.png (Critical)
  ///   0      → dies.png      (Dead)
  static String mapVitalityToState(int vitality) {
    if (vitality >= 80) return 'assets/images/pets/greeting.png';
    if (vitality >= 60) return 'assets/images/pets/curious.png';
    if (vitality >= 40) return 'assets/images/pets/alert.png';
    if (vitality >= 20) return 'assets/images/pets/sad.png';
    if (vitality > 0) return 'assets/images/pets/depressed.png';
    return 'assets/images/pets/dies.png';
  }

  /// Returns the asset path for a special pet moment.
  static String specialAsset(SpecialPetMoment moment) {
    return switch (moment) {
      SpecialPetMoment.lowWellnessSubmitted => 'assets/images/pets/sick.png',
      SpecialPetMoment.milestone => 'assets/images/pets/Celebrating.png',
    };
  }
}
