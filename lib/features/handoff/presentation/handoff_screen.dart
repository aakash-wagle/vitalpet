import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/features/handoff/handoff_generator.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Doctor handoff screen.
///
/// Presents a date-range selector (7 / 30 / 90 days) and a "Generate & Share"
/// button. On tap, [HandoffGenerator.generateAndShare] is called which builds
/// the PDF entirely in Dart and passes it to the native share sheet.
class HandoffScreen extends ConsumerStatefulWidget {
  const HandoffScreen({super.key});

  @override
  ConsumerState<HandoffScreen> createState() => _HandoffScreenState();
}

class _HandoffScreenState extends ConsumerState<HandoffScreen> {
  int _dayCount = 30;
  bool _generating = false;
  String? _errorMessage;

  static const _dateRangeOptions = [
    (days: 7, label: 'Last 7 days'),
    (days: 30, label: 'Last 30 days'),
    (days: 90, label: 'Last 90 days'),
  ];

  Future<void> _generate() async {
    setState(() {
      _generating = true;
      _errorMessage = null;
    });
    try {
      await const HandoffGenerator()
          .generateAndShare(dayCount: _dayCount, ref: ref);
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Could not generate PDF. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Doctor Handoff'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _IntroCard(),
              const SizedBox(height: 24),
              Text('Date Range', style: AppTextStyles.labelLarge),
              const SizedBox(height: 10),
              _DateRangeSelector(
                selected: _dayCount,
                options: _dateRangeOptions,
                onChanged: _generating
                    ? null
                    : (days) => setState(() => _dayCount = days),
              ),
              const SizedBox(height: 24),
              _SummaryPreview(dayCount: _dayCount),
              const Spacer(),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                        color: AppColors.danger, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              _GenerateButton(
                generating: _generating,
                onPressed: _generating ? null : _generate,
              ),
              const SizedBox(height: 8),
              Text(
                'The PDF is generated on your device and never uploaded anywhere.',
                style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textTertiary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _IntroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellness Summary PDF',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Share a de-identified summary with your care team. '
                  'Includes trend chart, symptom breakdown, and key dates.',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRangeSelector extends StatelessWidget {
  const _DateRangeSelector({
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  final int selected;
  final List<({int days, String label})> options;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((opt) {
        final isSelected = selected == opt.days;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: onChanged == null ? null : () => onChanged!(opt.days),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textTertiary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  opt.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SummaryPreview extends StatelessWidget {
  const _SummaryPreview({required this.dayCount});

  final int dayCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.textTertiary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your PDF will include:',
            style: AppTextStyles.labelLarge
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          _item(Icons.show_chart, 'Wellness trend chart ($dayCount days)'),
          _item(Icons.grid_view_rounded, 'Calendar heatmap (6 weeks)'),
          _item(Icons.monitor_heart_outlined, 'Top symptom categories'),
          _item(Icons.event_note_outlined, 'Notable events & low-score days'),
          _item(Icons.health_and_safety_outlined,
              'Health data correlation (if connected)'),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          const Text(
            '"This summary was generated by VitalPet and is not a medical record."',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textTertiary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
                fontSize: 12.5, color: AppColors.textPrimary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  const _GenerateButton({
    required this.generating,
    required this.onPressed,
  });

  final bool generating;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: generating
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.ios_share, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Generate & Share',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }
}
