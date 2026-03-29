import 'package:flutter/material.dart';

/// All colour constants for VitalPet.
/// Never hardcode hex values outside this file.
/// Each token ships in a light variant (default name) and a `*Dark` variant.
abstract final class AppColors {
  // --- Primary brand (teal) ---
  static const primary = Color(0xFF0D7377);
  static const primaryLight = Color(0xFF3ABFC3);
  static const primaryDark = Color(0xFF0A5558);

  // --- Accent (warm orange — milestone celebrations, CTAs) ---
  static const accent = Color(0xFFFF8C42);
  static const accentDark = Color(0xFFE07030);

  // --- Semantic states ---
  static const danger = Color(0xFFE53935);
  static const dangerDark = Color(0xFFEF5350);
  static const warning = Color(0xFFFFB300);
  static const warningDark = Color(0xFFFFCA28);
  static const success = Color(0xFF43A047);
  static const successDark = Color(0xFF66BB6A);

  // --- Surfaces ---
  static const background = Color(0xFFF5F7FA);
  static const backgroundDark = Color(0xFF1A1D23);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF252830);

  // --- Text ---
  static const textPrimary = Color(0xFF1A1D23);
  static const textPrimaryDark = Color(0xFFF5F7FA);
  static const textSecondary = Color(0xFF6B7280);
  static const textSecondaryDark = Color(0xFF9CA3AF);
  static const textTertiary = Color(0xFF9CA3AF);
  static const textTertiaryDark = Color(0xFF6B7280);

  // --- Legacy aliases kept for backward-compatibility ---
  /// Use [danger] for new code.
  static const error = danger;
  /// Use [textPrimaryDark] for new code.
  static const textOnDark = textPrimaryDark;

  // --- Vitality state palette ---
  static const vitalityThriving = Color(0xFF43A047);
  static const vitalityHealthy = Color(0xFF8BC34A);
  static const vitalityTired = Color(0xFFFFB300);
  static const vitalityUnwell = Color(0xFFFF7043);
  static const vitalityCritical = Color(0xFFE53935);
  static const vitalityDead = Color(0xFF9E9E9E);
}
