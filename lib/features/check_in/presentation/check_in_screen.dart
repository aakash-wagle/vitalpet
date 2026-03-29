import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_notifier.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_state.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/check_in/presentation/widgets/companion_bubble.dart';
import 'package:vitalpet/features/check_in/presentation/widgets/question_card.dart';
import 'package:vitalpet/features/check_in/presentation/widgets/wellness_slider.dart';
import 'package:vitalpet/features/pet/domain/milestone_detector.dart';
import 'package:vitalpet/features/pet/domain/pet_notifier.dart';
import 'package:vitalpet/features/pet/domain/pet_state_mapper.dart';
import 'package:vitalpet/features/slm/slm_output.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Main check-in screen: WellnessSlider → follow-up questions → done.
class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen>
    with TickerProviderStateMixin {
  late final ConfettiController _confettiController;
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(checkInSessionProvider.notifier).startSession();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onCompleted(bool hadMilestone) {
    _bounceController.forward().then((_) => _bounceController.reverse());
    if (hadMilestone && !MediaQuery.of(context).disableAnimations) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(checkInSessionProvider);

    ref.listen(checkInSessionProvider, (_, next) {
      next.whenData((s) {
        s.whenOrNull(
          completed: (hadMilestone, _) => _onCompleted(hadMilestone),
        );
      });
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          tooltip: 'Close',
          onPressed: () => context.pop(),
        ),
        title: const Text('Daily Check-in', style: AppTextStyles.titleLarge),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: sessionAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorBody(message: e.toString()),
              data: (session) => _buildSessionBody(session),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: MediaQuery.of(context).disableAnimations
                ? const SizedBox.shrink()
                : ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      AppColors.primary,
                      AppColors.accent,
                      AppColors.warning,
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionBody(CheckInSessionState session) {
    return session.map(
      idle: (_) => _ScoreBody(bounceAnimation: _bounceAnimation),
      collectingScore: (_) => _ScoreBody(bounceAnimation: _bounceAnimation),
      collectingAnswers: (s) => s.mode == CheckInMode.companion
          ? _CompanionBody(
              wellnessScore: s.wellnessScore,
              mode: s.mode,
              questions: s.questions,
              currentIndex: s.currentIndex,
              answers: s.answers,
            )
          : _GuidedBody(
              wellnessScore: s.wellnessScore,
              mode: s.mode,
              questions: s.questions,
              currentIndex: s.currentIndex,
              answers: s.answers,
            ),
      partial: (s) => _PartialSavedBody(savedAt: s.savedAt),
      completing: (_) =>
          const Center(child: CircularProgressIndicator()),
      completed: (s) => _CompletedBody(
        hadMilestone: s.hadMilestone,
        milestone: s.milestone,
        bounceAnimation: _bounceAnimation,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Score collection phase
// ---------------------------------------------------------------------------

class _ScoreBody extends ConsumerStatefulWidget {
  const _ScoreBody({required this.bounceAnimation});

  final Animation<double> bounceAnimation;

  @override
  ConsumerState<_ScoreBody> createState() => _ScoreBodyState();
}

class _ScoreBodyState extends ConsumerState<_ScoreBody> {
  bool _showSick = false;
  Timer? _sickTimer;

  @override
  void dispose() {
    _sickTimer?.cancel();
    super.dispose();
  }

  void _onScoreSelected(int score) {
    if (score <= 3) {
      setState(() => _showSick = true);
      _sickTimer = Timer(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        ref.read(checkInSessionProvider.notifier).submitWellnessScore(score);
      });
    } else {
      ref.read(checkInSessionProvider.notifier).submitWellnessScore(score);
    }
  }

  @override
  Widget build(BuildContext context) {
    final petAsync = ref.watch(petProvider);

    final Widget petImage;
    if (_showSick) {
      petImage = Container(
        key: const ValueKey('sick'),
        width: 120,
        height: 120,
        color: const Color(0xFF000000),
        child: Image.asset(
          PetStateMapper.specialAsset(SpecialPetMoment.lowWellnessSubmitted),
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
      );
    } else if (petAsync.value != null) {
      final assetPath =
          PetStateMapper.mapVitalityToState(petAsync.value!.vitality);
      petImage = Container(
        key: ValueKey(assetPath),
        width: 120,
        height: 120,
        color: const Color(0xFF000000),
        child: Image.asset(
          assetPath,
          width: 120,
          height: 120,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              const SizedBox(width: 120, height: 120),
        ),
      );
    } else {
      petImage =
          const SizedBox(key: ValueKey('empty'), width: 120, height: 120);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          ScaleTransition(
            scale: widget.bounceAnimation,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: petImage,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'How are you feeling today?',
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Slide to log your wellness score',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          WellnessSlider(
            onScoreSelected: _onScoreSelected,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Guided mode (Mode 2)
// ---------------------------------------------------------------------------

class _GuidedBody extends ConsumerWidget {
  const _GuidedBody({
    required this.wellnessScore,
    required this.mode,
    required this.questions,
    required this.currentIndex,
    required this.answers,
  });

  final int wellnessScore;
  final CheckInMode mode;
  final List<SLMQuestion> questions;
  final int currentIndex;
  final List<QuestionAnswer> answers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDone = currentIndex >= questions.length;

    return Column(
      children: [
        _ProgressBar(
          current: currentIndex,
          total: questions.isEmpty ? 1 : questions.length,
        ),
        Expanded(
          child: isDone
              ? _AllAnsweredPrompt(
                  onDone: () => ref
                      .read(checkInSessionProvider.notifier)
                      .completeSession(),
                )
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: QuestionCard(
                    question: questions[currentIndex],
                    onAnswered: (answer) {
                      ref
                          .read(checkInSessionProvider.notifier)
                          .submitAnswer(answer);
                    },
                  ),
                ),
        ),
        _ActionFooter(
          onSavePartial: () =>
              ref.read(checkInSessionProvider.notifier).savePartial(),
          onDone: () =>
              ref.read(checkInSessionProvider.notifier).completeSession(),
          showSavePartial: true,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Companion mode (Mode 3)
// ---------------------------------------------------------------------------

class _CompanionBody extends ConsumerWidget {
  const _CompanionBody({
    required this.wellnessScore,
    required this.mode,
    required this.questions,
    required this.currentIndex,
    required this.answers,
  });

  final int wellnessScore;
  final CheckInMode mode;
  final List<SLMQuestion> questions;
  final int currentIndex;
  final List<QuestionAnswer> answers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider);
    final petName = petAsync.value?.name ?? 'your pet';
    final clampedIndex = currentIndex.clamp(0, questions.isEmpty ? 0 : questions.length - 1);
    final currentQuestion =
        questions.isNotEmpty && clampedIndex < questions.length
            ? questions[clampedIndex]
            : null;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              for (var i = 0; i < answers.length; i++) ...[
                if (i < questions.length)
                  CompanionBubble(
                    petName: petName,
                    message: questions[i].prompt,
                  ),
                const SizedBox(height: 8),
                _UserAnswerBubble(answer: answers[i]),
                const SizedBox(height: 16),
              ],
              if (currentQuestion != null) ...[
                CompanionBubble(
                  petName: petName,
                  message: currentQuestion.prompt,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: QuestionCard(
                    question: currentQuestion,
                    onAnswered: (answer) {
                      ref
                          .read(checkInSessionProvider.notifier)
                          .submitAnswer(answer);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        _ActionFooter(
          onSavePartial: () =>
              ref.read(checkInSessionProvider.notifier).savePartial(),
          onDone: () =>
              ref.read(checkInSessionProvider.notifier).completeSession(),
          showSavePartial: true,
        ),
      ],
    );
  }
}

class _UserAnswerBubble extends StatelessWidget {
  const _UserAnswerBubble({required this.answer});

  final QuestionAnswer answer;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          _formatAnswer(answer),
          style: AppTextStyles.bodyLarge
              .copyWith(color: AppColors.surface),
        ),
      ),
    );
  }

  String _formatAnswer(QuestionAnswer a) {
    final v = a.value;
    if (v is List) return v.join(', ');
    return v?.toString() ?? '';
  }
}

// ---------------------------------------------------------------------------
// Partial saved state
// ---------------------------------------------------------------------------

class _PartialSavedBody extends StatelessWidget {
  const _PartialSavedBody({required this.savedAt});

  final DateTime savedAt;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bookmark, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text('Progress saved', style: AppTextStyles.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text(
              'Come back before midnight to finish and keep your streak!',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => context.pop(),
              style:
                  FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Completed state — pet bounce + milestone celebration
// ---------------------------------------------------------------------------

class _CompletedBody extends ConsumerStatefulWidget {
  const _CompletedBody({
    required this.hadMilestone,
    required this.milestone,
    required this.bounceAnimation,
  });

  final bool hadMilestone;
  final MilestoneType? milestone;
  final Animation<double> bounceAnimation;

  @override
  ConsumerState<_CompletedBody> createState() => _CompletedBodyState();
}

class _CompletedBodyState extends ConsumerState<_CompletedBody> {
  bool _showCelebrating = false;
  Timer? _celebratingTimer;

  @override
  void initState() {
    super.initState();
    if (widget.hadMilestone) {
      _showCelebrating = true;
      _celebratingTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showCelebrating = false);
      });
    }
  }

  @override
  void dispose() {
    _celebratingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petAsync = ref.watch(petProvider);
    final pet = petAsync.value;

    final Widget petImage;
    if (_showCelebrating) {
      petImage = Container(
        key: const ValueKey('celebrating'),
        width: 140,
        height: 140,
        color: const Color(0xFF000000),
        child: Image.asset(
          PetStateMapper.specialAsset(SpecialPetMoment.milestone),
          width: 140,
          height: 140,
          fit: BoxFit.contain,
        ),
      );
    } else if (pet != null) {
      final assetPath = PetStateMapper.mapVitalityToState(pet.vitality);
      petImage = Container(
        key: ValueKey(assetPath),
        width: 140,
        height: 140,
        color: const Color(0xFF000000),
        child: Image.asset(
          assetPath,
          width: 140,
          height: 140,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              const SizedBox(width: 140, height: 140),
        ),
      );
    } else {
      petImage =
          const SizedBox(key: ValueKey('empty'), width: 140, height: 140);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: widget.bounceAnimation,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: petImage,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.hadMilestone
                  ? '🎉 Milestone reached!'
                  : 'Check-in complete!',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.hadMilestone
                  ? '${pet?.name ?? "Your pet"} is proud of your streak!'
                  : '${pet?.name ?? "Your pet"} thanks you for checking in.',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                ref.read(checkInSessionProvider.notifier).reset();
                context.pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
// ---------------------------------------------------------------------------

class _ActionFooter extends StatelessWidget {
  const _ActionFooter({
    required this.onSavePartial,
    required this.onDone,
    required this.showSavePartial,
  });

  final VoidCallback onSavePartial;
  final VoidCallback onDone;
  final bool showSavePartial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Row(
        children: [
          if (showSavePartial) ...[
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: onSavePartial,
                  child: const Text('Save and come back'),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: onDone,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text("I'm done"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: total > 0 ? (current / total).clamp(0.0, 1.0) : 0,
      backgroundColor: AppColors.background,
      color: AppColors.primary,
      minHeight: 4,
    );
  }
}

class _AllAnsweredPrompt extends StatelessWidget {
  const _AllAnsweredPrompt({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 64, color: AppColors.success),
            const SizedBox(height: 16),
            const Text('All questions answered!',
                style: AppTextStyles.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: onDone,
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary),
                child: const Text("I'm done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
            const SizedBox(height: 16),
            const Text('Something went wrong',
                style: AppTextStyles.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
