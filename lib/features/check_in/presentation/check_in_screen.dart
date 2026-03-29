import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalpet/core/constants/symptom_domains.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_notifier.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_state.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/check_in/presentation/widgets/companion_bubble.dart';
import 'package:vitalpet/features/check_in/presentation/widgets/question_card.dart';
import 'package:vitalpet/features/pet/domain/milestone_detector.dart';
import 'package:vitalpet/features/pet/domain/pet_notifier.dart';
import 'package:vitalpet/features/pet/domain/pet_state_mapper.dart';
import 'package:vitalpet/features/slm/slm_output.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Main check-in screen: Overall status → symptoms → follow-up → done.
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
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
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
              loading: () => const Center(child: CircularProgressIndicator()),
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
      idle: (_) => _OverallStatusBody(bounceAnimation: _bounceAnimation),
      collectingScore: (_) =>
          _OverallStatusBody(bounceAnimation: _bounceAnimation),
      selectingSymptoms: (s) =>
          _SymptomCategorySelector(overallStatus: s.overallStatus),
      collectingSymptomDetails: (s) => _SymptomDetailBody(
        category: s.selectedCategories[s.currentCategoryIndex],
        step: s.categoryStep,
        currentData: s.currentCategoryData,
        categoryIndex: s.currentCategoryIndex,
        totalCategories: s.selectedCategories.length,
      ),
      collectingAnswers: (s) => s.mode == CheckInMode.companion
          ? _CompanionBody(
              overallStatus: s.overallStatus,
              mode: s.mode,
              questions: s.questions,
              currentIndex: s.currentIndex,
              answers: s.answers,
            )
          : _GuidedBody(
              overallStatus: s.overallStatus,
              mode: s.mode,
              questions: s.questions,
              currentIndex: s.currentIndex,
              answers: s.answers,
            ),
      partial: (s) => _PartialSavedBody(savedAt: s.savedAt),
      completing: (_) => const Center(child: CircularProgressIndicator()),
      completed: (s) => _CompletedBody(
        hadMilestone: s.hadMilestone,
        milestone: s.milestone,
        bounceAnimation: _bounceAnimation,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Overall status selection (replaces wellness slider)
// ---------------------------------------------------------------------------

class _OverallStatusBody extends ConsumerStatefulWidget {
  const _OverallStatusBody({required this.bounceAnimation});

  final Animation<double> bounceAnimation;

  @override
  ConsumerState<_OverallStatusBody> createState() => _OverallStatusBodyState();
}

class _OverallStatusBodyState extends ConsumerState<_OverallStatusBody> {
  @override
  Widget build(BuildContext context) {
    final petAsync = ref.watch(petProvider);

    final Widget petImage;
    if (petAsync.value != null) {
      final assetPath = PetStateMapper.mapVitalityToState(
        petAsync.value!.vitality,
      );
      petImage = SizedBox(
        key: ValueKey(assetPath),
        width: 120,
        height: 120,
        child: Image.asset(
          assetPath,
          width: 120,
          height: 120,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox(width: 120, height: 120),
        ),
      );
    } else {
      petImage = const SizedBox(
        key: ValueKey('empty'),
        width: 120,
        height: 120,
      );
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
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _StatusButton(
                  label: 'Great!',
                  icon: Icons.sentiment_very_satisfied,
                  color: AppColors.success,
                  onTap: () => ref
                      .read(checkInSessionProvider.notifier)
                      .submitOverallStatus('great'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatusButton(
                  label: 'Not great',
                  icon: Icons.sentiment_dissatisfied,
                  color: AppColors.warning,
                  onTap: () => ref
                      .read(checkInSessionProvider.notifier)
                      .submitOverallStatus('not_great'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Text input alternative
          _TextInputAlternative(
            hint: 'Or tell us how you feel...',
            onSubmit: (text) {
              final lower = text.toLowerCase();
              final isGreat =
                  lower.contains('great') ||
                  lower.contains('good') ||
                  lower.contains('fine') ||
                  lower.contains('amazing') ||
                  lower.contains('wonderful') ||
                  lower.contains('better');
              ref
                  .read(checkInSessionProvider.notifier)
                  .submitOverallStatus(isGreat ? 'great' : 'not_great');
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Icon(icon, size: 48, color: color),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: AppTextStyles.labelLarge.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Symptom category selector (for "not_great" users)
// ---------------------------------------------------------------------------

class _SymptomCategorySelector extends ConsumerStatefulWidget {
  const _SymptomCategorySelector({required this.overallStatus});

  final String overallStatus;

  @override
  ConsumerState<_SymptomCategorySelector> createState() =>
      _SymptomCategorySelectorState();
}

class _SymptomCategorySelectorState
    extends ConsumerState<_SymptomCategorySelector> {
  final Set<SymptomCategory> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'What\'s bothering you?',
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Select all that apply',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: SymptomCategory.values.map((cat) {
                final isSelected = _selected.contains(cat);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SymptomCategoryChip(
                    category: cat,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selected.remove(cat);
                        } else {
                          _selected.add(cat);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Text input alternative
          _TextInputAlternative(
            hint: 'Or describe what you\'re feeling...',
            onSubmit: (text) {
              // Auto-detect categories from text
              final lower = text.toLowerCase();
              final detected = <SymptomCategory>{};
              if (lower.contains('fever') ||
                  lower.contains('temperature') ||
                  lower.contains('hot')) {
                detected.add(SymptomCategory.fever);
              }
              if (lower.contains('pain') ||
                  lower.contains('hurt') ||
                  lower.contains('ache') ||
                  lower.contains('sore')) {
                detected.add(SymptomCategory.pain);
              }
              if (lower.contains('tired') ||
                  lower.contains('fatigue') ||
                  lower.contains('exhausted') ||
                  lower.contains('energy')) {
                detected.add(SymptomCategory.fatigue);
              }
              if (lower.contains('nausea') ||
                  lower.contains('vomit') ||
                  lower.contains('sick') ||
                  lower.contains('throw up')) {
                detected.add(SymptomCategory.nausea);
              }
              if (detected.isEmpty) {
                detected.add(SymptomCategory.other);
              }
              ref
                  .read(checkInSessionProvider.notifier)
                  .selectSymptomCategories(detected.toList());
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () =>
                        ref.read(checkInSessionProvider.notifier).savePartial(),
                    child: const Text('Save and come back'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _selected.isEmpty
                        ? null
                        : () => ref
                              .read(checkInSessionProvider.notifier)
                              .selectSymptomCategories(_selected.toList()),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SymptomCategoryChip extends StatelessWidget {
  const _SymptomCategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final SymptomCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon => switch (category) {
    SymptomCategory.fever => Icons.thermostat,
    SymptomCategory.pain => Icons.bolt,
    SymptomCategory.fatigue => Icons.battery_2_bar,
    SymptomCategory.nausea => Icons.sick,
    SymptomCategory.other => Icons.more_horiz,
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: category.label,
      child: Material(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _icon,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Symptom detail collection (category-specific questions)
// ---------------------------------------------------------------------------

class _SymptomDetailBody extends ConsumerStatefulWidget {
  const _SymptomDetailBody({
    required this.category,
    required this.step,
    required this.currentData,
    required this.categoryIndex,
    required this.totalCategories,
  });

  final SymptomCategory category;
  final int step;
  final Map<String, dynamic> currentData;
  final int categoryIndex;
  final int totalCategories;

  @override
  ConsumerState<_SymptomDetailBody> createState() => _SymptomDetailBodyState();
}

class _SymptomDetailBodyState extends ConsumerState<_SymptomDetailBody> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProgressBar(
            current: widget.categoryIndex,
            total: widget.totalCategories,
          ),
          const SizedBox(height: 16),
          Text(
            widget.category.label,
            style: AppTextStyles.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(child: SingleChildScrollView(child: _buildStepContent())),
          _TextInputAlternative(
            hint: 'Or describe in your own words...',
            onSubmit: _handleTextInput,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () =>
                  ref.read(checkInSessionProvider.notifier).savePartial(),
              child: const Text('Save and come back'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTextInput(String text) {
    // For text input, auto-fill with reasonable defaults and skip ahead
    switch (widget.category) {
      case SymptomCategory.fever:
        ref
            .read(checkInSessionProvider.notifier)
            .submitSymptomDetail('pattern', 'intermittent');
        break;
      case SymptomCategory.pain:
        ref
            .read(checkInSessionProvider.notifier)
            .submitSymptomDetail(
              widget.step == 0
                  ? 'regions'
                  : widget.step == 1
                  ? 'type'
                  : 'pattern',
              text,
            );
        break;
      case SymptomCategory.fatigue:
        ref
            .read(checkInSessionProvider.notifier)
            .submitSymptomDetail(widget.step == 0 ? 'scope' : 'pattern', text);
        break;
      case SymptomCategory.nausea:
        ref
            .read(checkInSessionProvider.notifier)
            .submitSymptomDetail(
              widget.step == 0 ? 'vomiting' : 'pattern',
              text,
            );
        break;
      case SymptomCategory.other:
        ref
            .read(checkInSessionProvider.notifier)
            .submitSymptomDetail('free_text', text);
        break;
    }
  }

  Widget _buildStepContent() {
    return switch (widget.category) {
      SymptomCategory.fever => _buildFeverStep(),
      SymptomCategory.pain => _buildPainStep(),
      SymptomCategory.fatigue => _buildFatigueStep(),
      SymptomCategory.nausea => _buildNauseaStep(),
      SymptomCategory.other => _buildOtherStep(),
    };
  }

  // --- Fever steps ---

  Widget _buildFeverStep() {
    if (widget.step == 0) {
      return _buildBinaryQuestion(
        'Do you have a thermometer to measure your temperature?',
        onYes: () {
          ref
              .read(checkInSessionProvider.notifier)
              .submitSymptomDetail('skipped', false);
        },
        onNo: () {
          ref
              .read(checkInSessionProvider.notifier)
              .submitSymptomDetail('skipped', true);
        },
      );
    }
    return _buildOptionsList(
      'How would you describe your fever?',
      feverPatterns,
      (v) => ref
          .read(checkInSessionProvider.notifier)
          .submitSymptomDetail('pattern', v),
    );
  }

  // --- Pain steps ---

  Widget _buildPainStep() {
    if (widget.step == 0) {
      // Body region selection
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Where does it hurt?', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 16),
          _MultiSelectChips(
            options: const [
              'Head',
              'Chest',
              'Abdomen',
              'Left arm',
              'Right arm',
              'Left leg',
              'Right leg',
              'Back',
            ],
            onConfirmed: (regions) => ref
                .read(checkInSessionProvider.notifier)
                .submitSymptomDetail('regions', regions),
          ),
        ],
      );
    }
    if (widget.step == 1) {
      return _buildOptionsList(
        'What kind of pain is it?',
        painTypes,
        (v) => ref
            .read(checkInSessionProvider.notifier)
            .submitSymptomDetail('type', v),
      );
    }
    return _buildOptionsList(
      'How is the pain behaving?',
      painPatterns,
      (v) => ref
          .read(checkInSessionProvider.notifier)
          .submitSymptomDetail('pattern', v),
    );
  }

  // --- Fatigue steps ---

  Widget _buildFatigueStep() {
    if (widget.step == 0) {
      return _buildOptionsList(
        'How severe is your fatigue?',
        fatigueScopes,
        (v) => ref
            .read(checkInSessionProvider.notifier)
            .submitSymptomDetail('scope', v),
        labels: const {
          'functional': 'Functional — I can manage',
          'wiped_out': 'Wiped out — barely functioning',
          'debilitating': 'Debilitating — can\'t do normal things',
        },
      );
    }
    return _buildOptionsList(
      'When does the fatigue hit?',
      fatiguePatterns,
      (v) => ref
          .read(checkInSessionProvider.notifier)
          .submitSymptomDetail('pattern', v),
      labels: const {
        'morning_only': 'Mainly in the morning',
        'afternoon_crash': 'Afternoon crash',
        'all_day': 'All day long',
        'post_exertion': 'After any effort',
      },
    );
  }

  // --- Nausea steps ---

  Widget _buildNauseaStep() {
    if (widget.step == 0) {
      return _buildBinaryQuestion(
        'Have you been vomiting?',
        onYes: () {
          ref
              .read(checkInSessionProvider.notifier)
              .submitSymptomDetail('vomiting', true);
        },
        onNo: () {
          ref
              .read(checkInSessionProvider.notifier)
              .submitSymptomDetail('vomiting', false);
        },
      );
    }
    return _buildOptionsList(
      'When does the nausea occur?',
      nauseaPatterns,
      (v) => ref
          .read(checkInSessionProvider.notifier)
          .submitSymptomDetail('pattern', v),
      labels: const {
        'constant': 'Constant',
        'after_eating': 'After eating',
        'morning': 'In the morning',
        'wave_like': 'Comes in waves',
      },
    );
  }

  // --- Other step ---

  Widget _buildOtherStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tell us what\'s going on', style: AppTextStyles.bodyLarge),
        const SizedBox(height: 16),
        TextField(
          controller: _textController,
          maxLines: 5,
          minLines: 3,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Describe your symptoms...',
            hintStyle: AppTextStyles.bodyMedium,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => ref
                .read(checkInSessionProvider.notifier)
                .submitSymptomDetail('free_text', _textController.text.trim()),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  // --- Shared builders ---

  Widget _buildBinaryQuestion(
    String question, {
    required VoidCallback onYes,
    required VoidCallback onNo,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: AppTextStyles.bodyLarge),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: onYes,
                  child: const Text('Yes'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: onNo,
                  child: const Text('No'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionsList(
    String question,
    List<String> options,
    ValueChanged<String> onSelect, {
    Map<String, String>? labels,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: AppTextStyles.bodyLarge),
        const SizedBox(height: 16),
        ...options.map((opt) {
          final display = labels?[opt] ?? opt.replaceAll('_', ' ');
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: () => onSelect(opt),
                child: Text(
                  display[0].toUpperCase() + display.substring(1),
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _MultiSelectChips extends StatefulWidget {
  const _MultiSelectChips({required this.options, required this.onConfirmed});

  final List<String> options;
  final ValueChanged<List<String>> onConfirmed;

  @override
  State<_MultiSelectChips> createState() => _MultiSelectChipsState();
}

class _MultiSelectChipsState extends State<_MultiSelectChips> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.options.map((opt) {
            final isSelected = _selected.contains(opt);
            return GestureDetector(
              onTap: () => setState(() {
                if (isSelected) {
                  _selected.remove(opt);
                } else {
                  _selected.add(opt);
                }
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textTertiary,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  opt,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected
                        ? AppColors.surface
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_selected.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () => widget.onConfirmed(_selected.toList()),
              child: const Text('Confirm'),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Text input alternative (with keyboard + mic support)
// ---------------------------------------------------------------------------

class _TextInputAlternative extends StatefulWidget {
  const _TextInputAlternative({required this.hint, required this.onSubmit});

  final String hint;
  final ValueChanged<String> onSubmit;

  @override
  State<_TextInputAlternative> createState() => _TextInputAlternativeState();
}

class _TextInputAlternativeState extends State<_TextInputAlternative> {
  final _controller = TextEditingController();
  bool _expanded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_expanded) {
      return TextButton.icon(
        onPressed: () => setState(() => _expanded = true),
        icon: const Icon(Icons.keyboard_alt_outlined, size: 18),
        label: Text(widget.hint, style: AppTextStyles.labelSmall),
        style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            autofocus: true,
            // textInputAction enables keyboard mic on iOS/Android
            textInputAction: TextInputAction.send,
            onSubmitted: (text) {
              if (text.trim().isNotEmpty) {
                widget.onSubmit(text.trim());
              }
            },
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.labelSmall,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColors.textTertiary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
            style: AppTextStyles.bodyMedium,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.send, color: AppColors.primary),
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSubmit(_controller.text.trim());
            }
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Guided mode (standard follow-up questions)
// ---------------------------------------------------------------------------

class _GuidedBody extends ConsumerWidget {
  const _GuidedBody({
    required this.overallStatus,
    required this.mode,
    required this.questions,
    required this.currentIndex,
    required this.answers,
  });

  final String overallStatus;
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
    required this.overallStatus,
    required this.mode,
    required this.questions,
    required this.currentIndex,
    required this.answers,
  });

  final String overallStatus;
  final CheckInMode mode;
  final List<SLMQuestion> questions;
  final int currentIndex;
  final List<QuestionAnswer> answers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider);
    final petName = petAsync.value?.name ?? 'your pet';
    final clampedIndex = currentIndex.clamp(
      0,
      questions.isEmpty ? 0 : questions.length - 1,
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.surface),
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
            const Text(
              'Progress saved',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Come back before midnight to finish and keep your streak!',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => context.pop(),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
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
      petImage = SizedBox(
        key: const ValueKey('celebrating'),
        width: 140,
        height: 140,
        child: Image.asset(
          PetStateMapper.specialAsset(SpecialPetMoment.milestone),
          width: 140,
          height: 140,
          fit: BoxFit.contain,
        ),
      );
    } else if (pet != null) {
      final assetPath = PetStateMapper.mapVitalityToState(pet.vitality);
      petImage = SizedBox(
        key: ValueKey(assetPath),
        width: 140,
        height: 140,
        child: Image.asset(
          assetPath,
          width: 140,
          height: 140,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox(width: 140, height: 140),
        ),
      );
    } else {
      petImage = const SizedBox(
        key: ValueKey('empty'),
        width: 140,
        height: 140,
      );
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
              widget.hadMilestone ? 'Milestone reached!' : 'Check-in complete!',
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
            const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            const Text(
              'All questions answered!',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: onDone,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
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
            const Text(
              'Something went wrong',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
