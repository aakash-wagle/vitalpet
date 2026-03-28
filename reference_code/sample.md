You are updating VitalPet's configuration to match a revised DEVELOPMENT_PLAN.md.
The key changes are: (1) Rive animations replaced with PNG + Flutter tweens,
(2) asset path changed from assets/widget_sprites/ to assets/images/pets/,
(3) flutter build apk removed from the final sprint.

Read these files in full before making any changes:
- DEVELOPMENT_PLAN.md
- REPO_STRUCTURE.md
- pubspec.yaml
- .cursor/rules/00-project-context.mdc
- .cursor/rules/02-flutter-ui.mdc
- .cursor/rules/04-native-widgets.mdc
- .cursor/skills/pet-engine/SKILL.md
- .cursor/skills/native-widgets/SKILL.md

Make ONLY the changes listed below. Do not change anything else.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CHANGE 1 — pubspec.yaml
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Remove the rive dependency entirely:
  DELETE: rive: ^0.13.x  (or whatever version is listed)

No replacement — the pet renderer now uses Flutter's built-in
animation primitives (AnimatedBuilder, Tween, AnimationController).

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CHANGE 2 — REPO_STRUCTURE.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

In the "Stack summary" section:
  DELETE the line: - **Animations**: `rive` 0.13.x (pet state machine) + `confetti` 0.7.x (milestones)
  REPLACE with:    - **Animations**: Flutter built-in AnimatedBuilder + Tween (pet rocking/bounce) + `confetti` 0.7.x (milestones)

In the assets/ directory section:
  DELETE the entire assets/animations/ block (cat.riv, dog.riv, rabbit.riv, dragon.riv)
  DELETE the entire assets/widget_sprites/ block (cat_1.png ... dragon_5.png)

  ADD in their place:
  ```
  assets/images/pets/
  ├── cat_1.png   # thriving state
  ├── cat_2.png   # happy state
  ├── cat_3.png   # neutral state
  ├── cat_4.png   # unwell state
  ├── cat_5.png   # critical state
  ├── dog_1.png … dog_5.png
  ├── rabbit_1.png … rabbit_5.png
  └── dragon_1.png … dragon_5.png
  # Naming: <species>_<stateIndex>.png where stateIndex 1=thriving … 5=critical
  # These same files are used in BOTH the main app and the WidgetKit extension
  ```

In the native/ widget section, update any reference to widget_sprites/ to assets/images/pets/.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CHANGE 3 — .cursor/rules/00-project-context.mdc
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

In the "Tech stack" section, find the Animations bullet:
  DELETE: - **Animations**: `rive` 0.13.x (pet state machine) + `confetti` 0.7.x (milestones)
  REPLACE with:
  - **Animations**: Flutter built-in AnimatedBuilder + Tween (pet rocking/bounce effect, 
    PNG swap per vitality state) + `confetti` 0.7.x (milestone streaks). No Rive dependency.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CHANGE 4 — .cursor/rules/02-flutter-ui.mdc
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DELETE the entire "PetRenderer widget (Rive)" section, which contains
RiveAnimation.asset, StateMachineController, findInput, and Rive-specific
code examples.

REPLACE it with a new section:

## PetRenderer widget (PNG + Flutter animation)
```dart
// Pet images live at: assets/images/pets/<species>_<stateIndex>.png
// stateIndex: 1=thriving, 2=happy, 3=neutral, 4=unwell, 5=critical
// PetStateMapper.mapVitalityToState(vitality) → stateIndex

class PetRenderer extends ConsumerStatefulWidget {
  // Drives two things from Riverpod:
  // 1. Which PNG to show (species + stateIndex from petStateProvider)
  // 2. Whether to animate (MediaQuery.of(context).disableAnimations)
}

class _PetRendererState extends State<PetRenderer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rockAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _rockAnimation = Tween<double>(begin: -0.04, end: 0.04)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(petStateProvider).value;
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final assetPath = 'assets/images/pets/'
        '${pet?.species ?? 'cat'}_${pet?.stateIndex ?? 1}.png';

    final image = Image.asset(assetPath, width: 200, height: 200);

    return Semantics(
      label: '${pet?.name} the ${pet?.species}, ${pet?.stateName}',
      child: disableAnimations
          ? image
          : AnimatedBuilder(
              animation: _rockAnimation,
              builder: (_, child) => Transform.rotate(
                angle: _rockAnimation.value,
                child: child,
              ),
              child: image,
            ),
    );
  }
}
```

For the happy bounce on check-in completion:
```dart
// Trigger a single bounce (scale up then back) when checkInComplete fires
// Use a separate short-lived AnimationController, not the continuous rock controller
void triggerHappyBounce() {
  _bounceController.forward().then((_) => _bounceController.reverse());
}
// _bounceController: duration 300ms, Tween<double>(begin: 1.0, end: 1.25)
// Wrap image in ScaleTransition(scale: _bounceAnimation, child: image)
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CHANGE 5 — .cursor/rules/04-native-widgets.mdc
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Find the "Pet images in widgets" section which references assets/widget_sprites/.

REPLACE the entire section with:

## Pet images in widgets
Widgets use the same static PNG files as the main app:
  assets/images/pets/<species>_<stateIndex>.png
  (1=thriving, 2=happy, 3=neutral, 4=unwell, 5=critical)

Copy these into the widget extension's asset catalog in Xcode:
  In the Xcode project, add assets/images/pets/ as a folder reference
  inside the VitalPetWidget target's asset catalog.
  The WidgetDataProvider reads petState (1–5) and species from shared
  UserDefaults; the SwiftUI view constructs the image name:
    Image("\(species)_\(stateIndex)")

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CHANGE 6 — .cursor/skills/pet-engine/SKILL.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DELETE the entire "Rive state machine integration" section, which contains
RiveAnimation.asset, StateMachineController, _vitalityInput, _completeInput,
and all Rive-specific Dart code.

REPLACE it with:

## Pet renderer (PNG + Flutter animation)
```dart
// Asset path convention: assets/images/pets/<species>_<stateIndex>.png
// stateIndex derived from: PetStateMapper.mapVitalityToState(vitality)
// 1=thriving(80–100), 2=happy(60–79), 3=neutral(40–59),
// 4=unwell(20–39), 5=critical(1–19)

// Continuous rocking: AnimationController repeating reverse,
//   Tween<double>(begin: -0.04, end: 0.04), Transform.rotate
// Disabled when MediaQuery.of(context).disableAnimations is true

// Happy bounce on check-in complete: separate short-lived controller,
//   Tween<double>(begin: 1.0, end: 1.25), ScaleTransition, 300ms

// State change (vitality crosses a threshold): swap PNG asset path,
//   wrap in AnimatedSwitcher(duration: 500ms) for smooth cross-fade
```

In the "Pet death" section, change:
  DELETE: // 1. Trigger death animation (isDead input = true on Rive)
  REPLACE with:
  // 1. Stop rocking controller, show greyscale version of pet PNG
  //    Use ColorFiltered(colorFilter: ColorFilter.matrix(greyscaleMatrix), child: Image.asset(...))

In the "Time-of-day animation" section, change:
  DELETE the timeOfDay Rive input reference
  REPLACE with:
  // Time of day affects background gradient / ambient color of home screen
  // The pet PNG itself does not change — only the surrounding environment
  // Use a ColorTween on a background gradient driven by the same timeOfDayIndex()

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CHANGE 7 — .cursor/skills/native-widgets/SKILL.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Find every reference to assets/widget_sprites/ in this file.
Replace each one with assets/images/pets/.

The naming convention is unchanged: <species>_<stateIndex>.png

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CHANGE 8 — DEVELOPMENT_PLAN.md (Sprint 9.1 only)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

In Sprint 9.1, in the "Build release candidate" step, find:
  - flutter build apk --release (Android)

DELETE that line entirely. iOS-first build only. Android is post-hackathon.

Leave the iOS build line unchanged:
  - flutter build ios --release (iOS) — or flutter build ipa if signing configured

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After making all changes, run:
  flutter analyze --no-pub

Report exactly which files were changed and the analyze result.
Do not touch rules 01, 03, or 05.
Do not touch the SLM, check-in-engine, data-layer, or handoff SKILL.md files.
Do not change any phase prompts in DEVELOPMENT_PLAN.md other than
the single line deletion in Sprint 9.1.
