import 'package:flutter/material.dart';

/// All colour constants for VitalPet.
/// Never hardcode hex values outside this file.
abstract final class AppColors {
  // ── Brand / Primary ────────────────────────────────────────────────────────
  static const primary = Color(0xFF0D7377);
  static const primaryLight = Color(0xFF14BDCA);
  static const primaryDark = Color(0xFF095A5D);

  // ── Accent ─────────────────────────────────────────────────────────────────
  static const accent = Color(0xFF32E0C4);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const danger = Color(0xFFE53935);
  static const warning = Color(0xFFFFB300);
  static const success = Color(0xFF43A047);

  // ── Surfaces – light ───────────────────────────────────────────────────────
  static const background = Color(0xFFF4F8F8);
  static const surface = Color(0xFFFFFFFF);

  // ── Surfaces – dark ────────────────────────────────────────────────────────
  static const backgroundDark = Color(0xFF0D1214);
  static const surfaceDark = Color(0xFF1A2224);

  // ── Text – light ───────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF0D1214);
  static const textSecondary = Color(0xFF4A6566);
  static const textTertiary = Color(0xFF8AABAC);

  // ── Text – dark ────────────────────────────────────────────────────────────
  static const textPrimaryDark = Color(0xFFE8F4F4);
  static const textSecondaryDark = Color(0xFF8AABAC);
  static const textTertiaryDark = Color(0xFF4A6566);

  // ── Vitality states ────────────────────────────────────────────────────────
  static const vitalityThriving = Color(0xFF43A047);
  static const vitalityHealthy = Color(0xFF8BC34A);
  static const vitalityTired = Color(0xFFFFB300);
  static const vitalityUnwell = Color(0xFFFF7043);
  static const vitalityCritical = Color(0xFFE53935);
  static const vitalityDead = Color(0xFF9E9E9E);
}
