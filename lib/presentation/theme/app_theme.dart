import 'package:flutter/material.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// App-wide ThemeData — light and dark.
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
          titleLarge: AppTextStyles.titleLarge,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          labelLarge: AppTextStyles.labelLarge,
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
          displayLarge:
              AppTextStyles.displayLarge.copyWith(color: AppColors.textOnDark),
          headlineLarge:
              AppTextStyles.headlineLarge.copyWith(color: AppColors.textOnDark),
          bodyLarge:
              AppTextStyles.bodyLarge.copyWith(color: AppColors.textOnDark),
        ),
      );
}
