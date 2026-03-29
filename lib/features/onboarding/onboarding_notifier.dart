import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vitalpet/core/database/app_database.dart';
import 'package:vitalpet/core/database/dao_providers.dart';
import 'package:vitalpet/core/database/database_provider.dart';

part 'onboarding_notifier.g.dart';

class OnboardingState {
  const OnboardingState({
    this.petName = '',
    this.conditionFocus = '',
    this.step = 0,
    this.isComplete = false,
  });

  final String petName;
  final String conditionFocus;
  final int step;
  final bool isComplete;
}

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingState build() => const OnboardingState();

  void setPetName(String name) {
    state = OnboardingState(
      petName: name,
      conditionFocus: state.conditionFocus,
      step: state.step,
    );
  }

  void setConditionFocus(String focus) {
    state = OnboardingState(
      petName: state.petName,
      conditionFocus: focus,
      step: state.step,
    );
  }

  void advance() {
    state = OnboardingState(
      petName: state.petName,
      conditionFocus: state.conditionFocus,
      step: state.step + 1,
    );
  }

  /// Creates the initial PetState row in the encrypted DB (species='dog',
  /// vitality=60, streak=0) and marks onboarding complete.
  Future<void> complete() async {
    final snapshot = state;
    final petName = snapshot.petName.trim();
    final conditionFocus = snapshot.conditionFocus;
    final step = snapshot.step;

    final petDao = ref.read(petDaoProvider);
    final db = ref.read(databaseProvider);
    final petId = 'pet_${DateTime.now().millisecondsSinceEpoch}';

    await db.transaction(() async {
      await petDao.updatePetState(
        PetStateTableCompanion(
          petId: Value(petId),
          name: Value(petName),
          species: const Value('dog'),
          vitality: const Value(60),
          streak: const Value(0),
          calmMode: const Value(false),
          consecutiveBadDays: const Value(0),
          freezeAvailable: const Value(true),
          vulnerabilityCardShown: const Value(false),
          vulnerabilityFrozen: const Value(false),
        ),
      );
    });

    if (!ref.mounted) return;
    state = OnboardingState(
      petName: petName,
      conditionFocus: conditionFocus,
      step: step,
      isComplete: true,
    );
  }
}
