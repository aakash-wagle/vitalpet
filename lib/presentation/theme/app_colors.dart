import 'package:flutter/material.dart';

/// All colour constants for VitalPet.
/// Never hardcode hex values outside this file.
abstract final class AppColors {
  static const primary = Color(0xFF5B8CFF);
  static const primaryDark = Color(0xFF3A6AE8);

  static const background = Color(0xFFF5F7FA);
  static const backgroundDark = Color(0xFF1A1D23);

  static const surface = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF252830);

  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFFB300);
  static const success = Color(0xFF43A047);

  static const textPrimary = Color(0xFF1A1D23);
  static const textSecondary = Color(0xFF6B7280);
  static const textOnDark = Color(0xFFF5F7FA);

  static const vitalityThriving = Color(0xFF43A047);
  static const vitalityHealthy = Color(0xFF8BC34A);
  static const vitalityTired = Color(0xFFFFB300);
  static const vitalityUnwell = Color(0xFFFF7043);
  static const vitalityCritical = Color(0xFFE53935);
  static const vitalityDead = Color(0xFF9E9E9E);
}
