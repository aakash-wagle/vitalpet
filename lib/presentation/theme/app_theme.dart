import 'package:flutter/material.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// App-wide ThemeData — light and dark.
abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryLight,
          onPrimaryContainer: AppColors.textPrimary,
          secondary: AppColors.accent,
          onSecondary: AppColors.textPrimary,
          secondaryContainer: AppColors.primaryLight.withAlpha(51),
          onSecondaryContainer: AppColors.textPrimary,
          error: AppColors.danger,
          onError: Colors.white,
          errorContainer: AppColors.danger.withAlpha(26),
          onErrorContainer: AppColors.danger,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          surfaceContainerHighest: AppColors.background,
          onSurfaceVariant: AppColors.textSecondary,
          outline: AppColors.textTertiary,
          outlineVariant: AppColors.textTertiary.withAlpha(77),
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTextStyles.headlineSmall,
        ),
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
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: AppTextStyles.labelLarge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(64, 48),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.primaryLight,
          onPrimary: AppColors.backgroundDark,
          primaryContainer: AppColors.primaryDark,
          onPrimaryContainer: AppColors.textPrimaryDark,
          secondary: AppColors.accent,
          onSecondary: AppColors.backgroundDark,
          secondaryContainer: AppColors.primaryDark,
          onSecondaryContainer: AppColors.textPrimaryDark,
          error: AppColors.danger,
          onError: Colors.white,
          errorContainer: AppColors.danger.withAlpha(51),
          onErrorContainer: AppColors.danger,
          surface: AppColors.surfaceDark,
          onSurface: AppColors.textPrimaryDark,
          surfaceContainerHighest: AppColors.backgroundDark,
          onSurfaceVariant: AppColors.textSecondaryDark,
          outline: AppColors.textTertiaryDark,
          outlineVariant: AppColors.textTertiaryDark.withAlpha(77),
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceDark,
          foregroundColor: AppColors.textPrimaryDark,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimaryDark,
            height: 1.33,
          ),
        ),
        textTheme: TextTheme(
          displayLarge:
              AppTextStyles.displayLarge.copyWith(color: AppColors.textPrimaryDark),
          headlineLarge:
              AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimaryDark),
          headlineMedium:
              AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimaryDark),
          headlineSmall:
              AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimaryDark),
          titleLarge:
              AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimaryDark),
          bodyLarge:
              AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
          bodyMedium:
              AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
          labelLarge:
              AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryDark),
          labelSmall:
              AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiaryDark),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.backgroundDark,
            textStyle: AppTextStyles.labelLarge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(64, 48),
          ),
        ),
      );
}
