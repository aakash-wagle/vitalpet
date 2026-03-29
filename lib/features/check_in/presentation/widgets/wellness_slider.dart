import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Full-screen wellness slider (1–10) with haptic feedback and semantics.
///
/// - Fires [onScoreSelected] when the user lifts their finger.
/// - Triggers [HapticFeedback.lightImpact] on each integer step (iOS only).
/// - Semantics label identifies this as a slider with min/max/value.
class WellnessSlider extends StatefulWidget {
  const WellnessSlider({super.key, this.onScoreSelected});

  final ValueChanged<int>? onScoreSelected;

  @override
  State<WellnessSlider> createState() => _WellnessSliderState();
}

class _WellnessSliderState extends State<WellnessSlider> {
  double _value = 5;
  int _lastHapticStep = 5;

  static const _labels = [
    '',       // index 0 unused
    'Terrible',
    'Very bad',
    'Bad',
    'Poor',
    'Okay',
    'Alright',
    'Good',
    'Great',
    'Very good',
    'Amazing',
  ];

  void _onChanged(double v) {
    final newStep = v.round();
    if (newStep != _lastHapticStep) {
      _lastHapticStep = newStep;
      if (Platform.isIOS) {
        HapticFeedback.lightImpact();
      }
    }
    setState(() => _value = v);
  }

  Color get _trackColor {
    final score = _value.round();
    if (score <= 3) return AppColors.danger;
    if (score <= 6) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final score = _value.round();
    final label = _labels[score];

    return Semantics(
      label: 'Wellness score slider',
      value: '$score',
      hint: 'Minimum 1, maximum 10',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Large score display
          Text(
            '$score',
            style: AppTextStyles.displayLarge.copyWith(
              color: _trackColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _trackColor,
              inactiveTrackColor: _trackColor.withValues(alpha: 0.25),
              thumbColor: _trackColor,
              overlayColor: _trackColor.withValues(alpha: 0.12),
              trackHeight: 6,
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 14),
            ),
            child: Slider(
              value: _value,
              min: 1,
              max: 10,
              divisions: 9,
              label: '$score',
              onChanged: _onChanged,
              onChangeEnd: (v) => widget.onScoreSelected?.call(v.round()),
            ),
          ),
          // 1–10 tick labels below the slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                10,
                (i) => Text(
                  '${i + 1}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: (i + 1) == score
                        ? _trackColor
                        : AppColors.textTertiary,
                    fontWeight:
                        (i + 1) == score ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
