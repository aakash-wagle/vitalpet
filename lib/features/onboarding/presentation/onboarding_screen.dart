import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/features/onboarding/onboarding_notifier.dart';
import 'package:vitalpet/features/onboarding/presentation/widgets/pet_selector.dart';
import 'package:vitalpet/features/onboarding/presentation/widgets/pet_name_input.dart';

/// 3-page onboarding: problem explanation → pet selection → pet naming.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _ProblemPage(
            onNext: () =>
                ref.read(onboardingProvider.notifier).nextPage(),
          ),
          PetSelector(
            onSelected: (species) {
              ref.read(onboardingProvider.notifier).selectSpecies(species);
              ref.read(onboardingProvider.notifier).nextPage();
            },
          ),
          PetNameInput(
            onSubmitted: (name) async {
              ref.read(onboardingProvider.notifier).setPetName(name);
              await ref.read(onboardingProvider.notifier).complete();
            },
          ),
        ],
      ),
    );
  }
}

class _ProblemPage extends StatelessWidget {
  const _ProblemPage({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Track your health daily'),
          ElevatedButton(onPressed: onNext, child: const Text('Get Started')),
        ],
      ),
    );
  }
}
