import 'package:flutter/material.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// App-wide ThemeData — light and dark.
/// Always obtain via [AppTheme.light] / [AppTheme.dark]; never construct inline.
abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.displayLarge,
          headlineLarge: AppTextStyles.headlineLarge,
          headlineMedium: AppTextStyles.headlineMedium,
          headlineSmall: AppTextStyles.headlineSmall,
          titleLarge: AppTextStyles.titleLarge,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          labelLarge: AppTextStyles.labelLarge,
          labelSmall: AppTextStyles.labelSmall,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: TextTheme(
          displayLarge: AppTextStyles.displayLarge
              .copyWith(color: AppColors.textPrimaryDark),
          headlineLarge: AppTextStyles.headlineLarge
              .copyWith(color: AppColors.textPrimaryDark),
          headlineMedium: AppTextStyles.headlineMedium
              .copyWith(color: AppColors.textPrimaryDark),
          headlineSmall: AppTextStyles.headlineSmall
              .copyWith(color: AppColors.textPrimaryDark),
          titleLarge: AppTextStyles.titleLarge
              .copyWith(color: AppColors.textPrimaryDark),
          bodyLarge: AppTextStyles.bodyLarge
              .copyWith(color: AppColors.textPrimaryDark),
          bodyMedium: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textSecondaryDark),
          labelLarge: AppTextStyles.labelLarge
              .copyWith(color: AppColors.textPrimaryDark),
          labelSmall: AppTextStyles.labelSmall
              .copyWith(color: AppColors.textTertiaryDark),
        ),
      );
}
