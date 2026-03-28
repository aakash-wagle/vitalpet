---
name: vitalpet-pet-engine
description: >
  Use when working on the pet lifecycle, vitality formula, streak management, milestone
  detection, Rive animation integration, Calm Mode, vulnerability safeguard, pet death/archive,
  or the PetRenderer widget and home screen. Covers lib/features/pet/.
---

# VitalPet Pet Engine

## Vitality formula (pure Dart function)
```dart
// lib/features/pet/domain/vitality_calculator.dart
int calculateVitality({
  required int streak,
  required double checkInDepthScore,        // 0.0–1.0
  required List<int> consecutiveMissedDays, // one entry per missed day in current run
  required bool isVulnerabilityFrozen,
}) {
  const base = 60;
  final streakBonus = streak.clamp(0, 30);           // +0 to +30
  final depthBonus = (checkInDepthScore * 10).round(); // +0 to +10
  var penalty = 0;
  if (!isVulnerabilityFrozen) {
    for (var i = 0; i < consecutiveMissedDays.length; i++) {
      penalty += switch (i) { 0 => 8, 1 => 10, _ => 12 };
    }
  }
  return (base + streakBonus + depthBonus - penalty).clamp(0, 100);
}
// Always recomputable from raw check-in log — never store intermediate results (NFR-R-03)
```

## Pet states
| State | Vitality | Rive input `vitality` |
|---|---|---|
| Thriving | 80–100 | 80–100 |
| Happy | 60–79 | 60–79 |
| Neutral | 40–59 | 40–59 |
| Unwell | 20–39 | 20–39 |
| Critical | 1–19 | 1–19 → triggers critical notification |
| Dead | 0 | triggers death screen |

`PetStateMapper.mapVitalityToState(int vitality) → PetStateEnum` handles the mapping.

## Rive state machine integration
```dart
// lib/features/pet/presentation/widgets/pet_renderer.dart
// .riv file: assets/animations/<species>.riv
// State machine: "PetStateMachine"
// Inputs exposed by the Rive animator:
//   Number: "vitality"         (0.0–100.0)
//   Boolean: "checkInComplete" (triggers happy reaction animation)
//   Boolean: "isDead"          (triggers death fade-out)
//   Number: "timeOfDay"        (0=morning, 1=day, 2=evening, 3=night)

RiveAnimation.asset(
  'assets/animations/${pet.species}.riv',
  stateMachines: const ['PetStateMachine'],
  onInit: _onRiveInit,
  // Animations respects MediaQuery.of(context).disableAnimations:
  // If true, call controller.isActive = false and show static image
)

void _onRiveInit(Artboard artboard) {
  final ctrl = StateMachineController.fromArtboard(artboard, 'PetStateMachine')!;
  artboard.addController(ctrl);
  _vitalityInput = ctrl.findInput<double>('vitality')!;
  _completeInput = ctrl.findInput<bool>('checkInComplete')!;
}

// Drive from Riverpod listener:
ref.listen(petVitalityProvider, (_, v) => _vitalityInput.value = v.toDouble());
```

## Pet death
```dart
// When calculateVitality() returns 0:
// 1. Trigger death animation (isDead input = true on Rive)
// 2. Show DeathScreen (greyscale fade, name in past tense, lifespan in days)
// 3. Write archive record:
await petArchiveDao.insertArchive(PetArchiveCompanion.insert(
  id: pet.petId,
  name: pet.name,
  species: pet.species,
  lifespanDays: pet.streak,
  totalCheckins: totalCheckins,
  topSymptom: getTopSymptomDomain(checkins),
  diedAtUtc: DateTime.now().toUtc().toIso8601String(),
));
// 4. Delete pet_state row
// 5. Navigate to onboarding pet selection (FR-OB-02)
```

The archive is framed as "Your companions" in Settings. Each entry tap shows:
"Every check-in [Name] inspired is still in your health history. That mattered."

## Milestone rewards (7, 14, 30, 90-day streaks)
```dart
// lib/features/pet/domain/milestone_detector.dart
MilestoneType? detectMilestone(int streak) => switch (streak) {
  7 => MilestoneType.week,
  14 => MilestoneType.twoWeeks,
  30 => MilestoneType.month,
  90 => MilestoneType.quarter,
  _ => null,
};
// On detection: unlock cosmetic, trigger ConfettiWidget, send milestone notification
// Cosmetics stored as JSON in pet_state (future: pet_cosmetics table)
// Cosmetics persist through death and apply to a new pet
```

## Calm Mode
```dart
// pet_state.calmMode = true replaces all loss-aversion framing
// - "Critical warning" → "Your pet misses you"
// - Death mechanic still runs internally, but framing is streak-only
// - Toggle in Settings AND on VulnerabilityCard (proactive surface)
// - All data preserved when switching
```

## Vulnerability safeguard
```dart
// After completeSession(), checked in PetNotifier:
if (pet.consecutiveBadDays >= 5 && !pet.vulnerabilityCardShown) {
  await petDao.update(pet.copyWith(
    vulnerabilityFrozen: true,   // no vitality decay for 7 days
    vulnerabilityCardShown: true,
  ));
  // Surface VulnerabilityCard — with Calm Mode toggle directly on it
}
// Auto-unfreeze after 7 days regardless of wellness improvement
```

## Critical notification
Triggered when `vitality < 20` after any check-in write or midnight calculation:
```dart
if (newVitality < 20) {
  await notificationScheduler.scheduleCritical(
    petName: pet.name,
    daysMissed: pet.streak == 0 ? 1 : 0, // approximate
  );
}
// Overrides notification quiet hours — fires once per day while vitality < 20
```

## Time-of-day animation
```dart
// Sets Rive "timeOfDay" input based on device local hour:
int timeOfDayIndex(int hour) => switch (hour) {
  >= 6 && < 11 => 0,   // morning
  >= 11 && < 18 => 1,  // day
  >= 18 && < 22 => 2,  // evening
  _ => 3,              // night
};
// Called in PetRenderer.initState() and at midnight
```
