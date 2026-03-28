import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_notifier.g.dart';

class OnboardingState {
  const OnboardingState({
    this.currentPage = 0,
    this.selectedSpecies,
    this.petName,
    this.conditionFocus,
    this.isComplete = false,
  });

  final int currentPage;
  final String? selectedSpecies;
  final String? petName;
  final String? conditionFocus;
  final bool isComplete;
}

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingState build() => const OnboardingState();

  void nextPage() {
    state = OnboardingState(
      currentPage: state.currentPage + 1,
      selectedSpecies: state.selectedSpecies,
      petName: state.petName,
      conditionFocus: state.conditionFocus,
    );
  }

  void selectSpecies(String species) {
    state = OnboardingState(
      currentPage: state.currentPage,
      selectedSpecies: species,
      petName: state.petName,
      conditionFocus: state.conditionFocus,
    );
  }

  void setPetName(String name) {
    state = OnboardingState(
      currentPage: state.currentPage,
      selectedSpecies: state.selectedSpecies,
      petName: name,
      conditionFocus: state.conditionFocus,
    );
  }

  Future<void> complete() async {
    // TODO: persist conditionFocus + create initial PetState
    state = OnboardingState(
      currentPage: state.currentPage,
      selectedSpecies: state.selectedSpecies,
      petName: state.petName,
      conditionFocus: state.conditionFocus,
      isComplete: true,
    );
  }
}
