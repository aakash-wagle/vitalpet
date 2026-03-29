import 'package:flutter/material.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Displays the user's current consecutive check-in streak.
///
/// Shows a fire icon and the streak count. Tapping it does nothing by default;
/// wrap in a [GestureDetector] or [InkWell] if tap behaviour is needed.
class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final color = _streakColor(streak);

    return Semantics(
      label: '$streak day streak',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              '$streak ${streak == 1 ? 'day' : 'days'}',
              style: AppTextStyles.labelLarge.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  /// Colour escalates as streak grows to reinforce positive behaviour.
  Color _streakColor(int streak) {
    if (streak >= 30) return AppColors.accent;
    if (streak >= 7) return AppColors.primary;
    return AppColors.textSecondary;
  }
}
