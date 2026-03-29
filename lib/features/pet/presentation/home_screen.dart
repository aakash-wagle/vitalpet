import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalpet/features/pet/domain/pet_notifier.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';
import 'package:vitalpet/features/pet/presentation/widgets/deviation_alert_card.dart';
import 'package:vitalpet/features/pet/presentation/widgets/pet_renderer.dart';
import 'package:vitalpet/features/pet/presentation/widgets/streak_badge.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';
import 'package:vitalpet/presentation/widgets/vulnerability_card.dart';

/// Time-of-day index for background gradient selection.
/// 0=morning(6–10), 1=day(11–17), 2=evening(18–21), 3=night.
int _timeOfDayIndex(int hour) => switch (hour) {
      >= 6 && < 11 => 0,
      >= 11 && < 18 => 1,
      >= 18 && < 22 => 2,
      _ => 3,
    };

const _gradients = [
  // Morning — warm amber to light teal
  [Color(0xFFFFF8E1), Color(0xFFB2DFDB)],
  // Day — sky blue to light teal
  [Color(0xFFE3F2FD), Color(0xFFE0F2F1)],
  // Evening — soft peach to lavender
  [Color(0xFFFFF3E0), Color(0xFFEDE7F6)],
  // Night — deep navy to dark teal
  [Color(0xFF1A237E), Color(0xFF004D40)],
];

/// The main home screen: pet centred in a time-of-day gradient, streak,
/// deviation alert, doctor handoff button, and a FAB to start a check-in.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider);

    // React to pet state transitions (dead or deleted) by navigating away.
    // When Calm Mode is on the death screen is hidden — the pet's demise is
    // handled silently and the user sees only the streak-focused home UI.
    ref.listen<AsyncValue<PetState?>>(petProvider, (_, next) {
      next.whenData((pet) {
        if (pet == null) {
          context.go('/onboarding');
        } else if (pet.visualState == PetStateEnum.dead && !pet.calmMode) {
          context.go('/death');
        }
      });
    });

    return petAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const Scaffold(
        body: Center(
          child: Text('Something went wrong'),
        ),
      ),
      data: (pet) {
        if (pet == null) {
          // Initial render before ref.listen redirects — show blank slate.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/onboarding');
          });
          return const Scaffold(body: SizedBox.shrink());
        }
        if (pet.visualState == PetStateEnum.dead && !pet.calmMode) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/death');
          });
          return const Scaffold(body: SizedBox.shrink());
        }
        return _HomeContent(pet: pet);
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.pet});

  final PetState pet;

  @override
  Widget build(BuildContext context) {
    final hour = TimeOfDay.now().hour;
    final todIndex = _timeOfDayIndex(hour);
    final gradientColors = _gradients[todIndex];
    final isNight = todIndex == 3;

    return Scaffold(
      backgroundColor: gradientColors[0],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/checkin'),
        icon: const Icon(Icons.add),
        label: const Text('Check in'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Time-of-day background gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradientColors,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _TopBar(isNight: isNight),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _PetSection(pet: pet),
                        const SizedBox(height: 24),
                        if (pet.calmMode)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _CalmModeBanner(petName: pet.name),
                          ),
                        if (pet.vulnerabilityFrozen)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: VulnerabilityCard(),
                          ),
                        if (!pet.calmMode && pet.pendingAlerts.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DeviationAlertCard(
                                alerts: pet.pendingAlerts),
                          ),
                        _DoctorHandoffButton(petName: pet.name),
                        const SizedBox(height: 80), // FAB clearance
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isNight});

  final bool isNight;

  @override
  Widget build(BuildContext context) {
    final iconColor = isNight ? Colors.white70 : AppColors.textSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          Text(
            'VitalPet',
            style: AppTextStyles.titleLarge.copyWith(
              color: isNight ? Colors.white : AppColors.textPrimary,
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: iconColor),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }
}

class _PetSection extends StatelessWidget {
  const _PetSection({required this.pet});

  final PetState pet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/checkin'),
      child: Column(
        children: [
          const PetRenderer(),
          const SizedBox(height: 12),
          Text(
            pet.name,
            style: AppTextStyles.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          StreakBadge(streak: pet.streak),
        ],
      ),
    );
  }
}

class _CalmModeBanner extends StatelessWidget {
  const _CalmModeBanner({required this.petName});

  final String petName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.spa_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$petName misses you. Check in whenever you\'re ready.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorHandoffButton extends StatelessWidget {
  const _DoctorHandoffButton({required this.petName});

  final String petName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.push('/handoff'),
        icon: const Icon(Icons.description_outlined),
        label: const Text('Show my doctor'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
    );
  }
}
