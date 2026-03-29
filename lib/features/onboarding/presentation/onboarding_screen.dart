import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalpet/features/onboarding/onboarding_notifier.dart';
import 'package:vitalpet/features/onboarding/presentation/widgets/pet_name_input.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Full onboarding flow — 3-page PageView followed by a one-time
/// vulnerability safeguard overlay.
///
/// FR-OB-01 through FR-OB-09.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  bool _showVulnerabilityScreen = false;
  String _validatedName = '';
  String _conditionFocus = 'general_wellness';
  bool _completing = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    ref.read(onboardingProvider.notifier).advance();
  }

  void _skipToPage3() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onLetsGo() async {
    if (_completing) return;
    setState(() => _completing = true);
    await HapticFeedback.mediumImpact();

    ref.read(onboardingProvider.notifier).setPetName(_validatedName);
    ref.read(onboardingProvider.notifier).setConditionFocus(_conditionFocus);
    await ref.read(onboardingProvider.notifier).complete();

    setState(() {
      _completing = false;
      _showVulnerabilityScreen = true;
    });
  }

  Future<void> _onGotIt() async {
    await HapticFeedback.lightImpact();
    await _requestNotificationPermission();
    if (mounted) context.go('/checkin');
  }

  Future<void> _requestNotificationPermission() async {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _ProblemPage(
                onGetStarted: () => _goToPage(1),
                onSkip: _skipToPage3,
              ),
              _MeetYourPetPage(onNext: () => _goToPage(2)),
              _NameYourPetPage(
                onNameChanged: (name) => setState(() => _validatedName = name),
                onConditionChanged: (focus) =>
                    setState(() => _conditionFocus = focus),
                selectedCondition: _conditionFocus,
                onLetsGo: _validatedName.isNotEmpty && !_completing
                    ? _onLetsGo
                    : null,
                completing: _completing,
              ),
            ],
          ),
          if (_showVulnerabilityScreen)
            _VulnerabilitySafeguardOverlay(onGotIt: _onGotIt),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 1 — Problem statement
// ---------------------------------------------------------------------------

class _ProblemPage extends StatelessWidget {
  const _ProblemPage({required this.onGetStarted, required this.onSkip});

  final VoidCallback onGetStarted;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  'Skip',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              'You forget\nhow you felt.\nYour doctor\nguesses.',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'VitalPet helps you track how you really feel, every day.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onGetStarted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Get started',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 2 — Meet your pet
// ---------------------------------------------------------------------------

class _MeetYourPetPage extends StatelessWidget {
  const _MeetYourPetPage({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              width: 240,
              height: 240,
              child: Semantics(
                label: 'Your bulldog companion, greeting',
                child: Image.asset(
                  'assets/images/pets/greeting.png',
                  width: 240,
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Meet your companion.',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "They'll check in with you every day.",
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Next',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 3 — Name your pet + condition focus
// ---------------------------------------------------------------------------

const _kConditionOptions = [
  ('chronic_pain', 'Chronic pain'),
  ('post_surgery', 'Post-surgery recovery'),
  ('mental_health', 'Mental health'),
  ('general_wellness', 'General wellness'),
  ('other', 'Other'),
];

class _NameYourPetPage extends StatelessWidget {
  const _NameYourPetPage({
    required this.onNameChanged,
    required this.onConditionChanged,
    required this.selectedCondition,
    required this.onLetsGo,
    required this.completing,
  });

  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onConditionChanged;
  final String selectedCondition;
  final VoidCallback? onLetsGo;
  final bool completing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Semantics(
                  label: 'Your bulldog companion',
                  child: Image.asset(
                    'assets/images/pets/greeting.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Name your companion",
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            PetNameInput(onChanged: onNameChanged),
            const SizedBox(height: 32),
            Text(
              'What are you tracking?',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const SizedBox(height: 12),
            ..._kConditionOptions.map(
              (entry) => _ConditionTile(
                label: entry.$2,
                value: entry.$1,
                selected: selectedCondition == entry.$1,
                onTap: () => onConditionChanged(entry.$1),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onLetsGo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: onLetsGo != null
                      ? AppColors.primary
                      : AppColors.textTertiary,
                  foregroundColor: AppColors.textPrimaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: completing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Let's go",
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ConditionTile extends StatelessWidget {
  const _ConditionTile({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$label, ${selected ? 'selected' : 'not selected'}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          constraints: const BoxConstraints(minHeight: 44),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.2)
                : const Color(0xFF252830),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? AppColors.primary : AppColors.textTertiary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: selected
                        ? AppColors.primaryLight
                        : AppColors.textSecondaryDark,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vulnerability safeguard overlay (shown once after "Let's go")
// ---------------------------------------------------------------------------

class _VulnerabilitySafeguardOverlay extends StatelessWidget {
  const _VulnerabilitySafeguardOverlay({required this.onGotIt});

  final VoidCallback onGotIt;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Important notice',
      child: Material(
        color: AppColors.backgroundDark,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.primary,
                  size: 56,
                ),
                const SizedBox(height: 32),
                Text(
                  "A gentle note",
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "If you're going through a hard time, you can always pause your streak without penalty.",
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondaryDark,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onGotIt,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Got it',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
