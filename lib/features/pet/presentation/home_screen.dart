import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalpet/core/database/dao_providers.dart';
import 'package:vitalpet/features/pet/domain/mood_tracker.dart';
import 'package:vitalpet/features/pet/domain/pet_notifier.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';
import 'package:vitalpet/features/pet/presentation/widgets/deviation_alert_card.dart';
import 'package:vitalpet/features/pet/presentation/widgets/pet_renderer.dart';
import 'package:vitalpet/features/pet/presentation/widgets/streak_badge.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';
import 'package:vitalpet/presentation/widgets/vulnerability_card.dart';

/// Provider for mood analysis — refreshes when check-in data changes.
final moodAnalysisProvider = FutureProvider<MoodAnalysis>((ref) async {
  final checkInDao = ref.watch(checkInDaoProvider);
  const tracker = MoodTracker();
  return tracker.analyze(checkInDao);
});

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

/// The main home screen: pet centred in a time-of-day gradient, mood-based
/// affirmations, streak, and a FAB to start a check-in.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider);

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

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.pet});

  final PetState pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hour = TimeOfDay.now().hour;
    final todIndex = _timeOfDayIndex(hour);
    final gradientColors = _gradients[todIndex];
    final isNight = todIndex == 3;
    final moodAsync = ref.watch(moodAnalysisProvider);

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
                        const SizedBox(height: 20),
                        // Mood-based affirmation card
                        moodAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (mood) => _MoodCard(
                            mood: mood,
                            isNight: isNight,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Recent mood visualization
                        moodAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (mood) => mood.recentStatuses.isNotEmpty
                              ? _MoodTimeline(statuses: mood.recentStatuses)
                              : const SizedBox.shrink(),
                        ),
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

// ---------------------------------------------------------------------------
// Mood-based affirmation card
// ---------------------------------------------------------------------------

class _MoodCard extends StatelessWidget {
  const _MoodCard({required this.mood, required this.isNight});

  final MoodAnalysis mood;
  final bool isNight;

  Color get _accentColor => switch (mood.trend) {
        MoodTrend.improvingFromBad => const Color(0xFF43A047), // green
        MoodTrend.decliningFromGood => const Color(0xFFFF8F00), // amber
        MoodTrend.consistentlyGood => const Color(0xFF1E88E5), // blue
        MoodTrend.consistentlyBad => const Color(0xFFE53935), // red
        MoodTrend.neutral => AppColors.primary,
      };

  IconData get _icon => switch (mood.trend) {
        MoodTrend.improvingFromBad => Icons.trending_up,
        MoodTrend.decliningFromGood => Icons.favorite,
        MoodTrend.consistentlyGood => Icons.celebration,
        MoodTrend.consistentlyBad => Icons.self_improvement,
        MoodTrend.neutral => Icons.wb_sunny,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isNight
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon, color: _accentColor, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  mood.phrase,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isNight ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mood.subPhrase,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isNight ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mood timeline — dots showing recent check-in statuses
// ---------------------------------------------------------------------------

class _MoodTimeline extends StatelessWidget {
  const _MoodTimeline({required this.statuses});

  final List<String> statuses;

  @override
  Widget build(BuildContext context) {
    // Reverse so oldest is on the left
    final ordered = statuses.reversed.toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent days',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < ordered.length; i++) ...[
                if (i > 0)
                  Container(
                    width: 24,
                    height: 2,
                    color: AppColors.textTertiary.withValues(alpha: 0.3),
                  ),
                _MoodDot(
                  status: ordered[i],
                  label: i == ordered.length - 1
                      ? 'Today'
                      : '${ordered.length - i - 1}d ago',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MoodDot extends StatelessWidget {
  const _MoodDot({required this.status, required this.label});

  final String status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isGreat = status == 'great';
    final color = isGreat ? AppColors.success : AppColors.warning;
    final icon = isGreat ? Icons.sentiment_very_satisfied : Icons.sentiment_dissatisfied;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Existing widgets (unchanged)
// ---------------------------------------------------------------------------

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
