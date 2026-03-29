import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalpet/features/pet/domain/pet_notifier.dart';
import 'package:vitalpet/features/pet/presentation/widgets/pet_renderer.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Shown when a pet's vitality reaches 0.
///
/// Displays [PetRenderer] which automatically shows dies.png on a black
/// background when vitality == 0, the pet's name in past-tense framing, the
/// lifespan in days, and a "Start again" CTA that archives the pet and opens
/// onboarding.
class DeathScreen extends ConsumerWidget {
  const DeathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: petAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Something went wrong')),
        data: (pet) {
          if (pet == null) {
            // Pet already archived — navigate to onboarding.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/onboarding');
            });
            return const SizedBox.shrink();
          }
          return _DeathContent(
            petName: pet.name,
            lifespanDays: pet.streak,
            onStartAgain: () async {
              await ref.read(petProvider.notifier).archivePet();
              if (context.mounted) context.go('/onboarding');
            },
          );
        },
      ),
    );
  }
}

class _DeathContent extends StatelessWidget {
  const _DeathContent({
    required this.petName,
    required this.lifespanDays,
    required this.onStartAgain,
  });

  final String petName;
  final int lifespanDays;
  final VoidCallback onStartAgain;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          // dies.png is shown by PetRenderer when vitality == 0 — no filters needed.
          const PetRenderer(),
          const SizedBox(height: 24),
          Text(
            '$petName was a brave companion.',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _LifespanChip(days: lifespanDays),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Every check-in $petName inspired is still in your health history.\n'
              'That mattered.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onStartAgain,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: AppTextStyles.labelLarge,
                ),
                child: const Text('Start again'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LifespanChip extends StatelessWidget {
  const _LifespanChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.vitalityDead.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Lived $days ${days == 1 ? 'day' : 'days'}',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
