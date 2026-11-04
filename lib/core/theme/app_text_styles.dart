import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized typography using Orbitron for a futuristic cyber aesthetic.
class AppTextStyles {
  const AppTextStyles._();

  /// Primary cyber font family
  static final TextStyle _base = GoogleFonts.orbitron(
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );

  /// Game title on home screen
  static final TextStyle displayTitle = _base.copyWith(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    letterSpacing: 4.0,
    shadows: [
      const Shadow(
        color: AppColors.neonCyan,
        blurRadius: 18,
      ),
      const Shadow(
        color: AppColors.neonPurple,
        blurRadius: 32,
      ),
    ],
  );

  /// Overlay titles (Paused, Game Over)
  static final TextStyle overlayTitle = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: 3.0,
  );

  /// Panel headings (HOLD, NEXT, SCORE)
  static final TextStyle panelLabel = _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.5,
    color: AppColors.textSecondary,
  );

  /// Numeric values inside panels (Score, Level, Lines)
  static final TextStyle panelValue = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
    color: AppColors.neonCyan,
    shadows: [
      const Shadow(
        color: AppColors.neonCyan,
        blurRadius: 10,
      ),
    ],
  );

  /// Large numerical displays (Final score, High score)
  static final TextStyle numericDisplay = _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.0,
    color: AppColors.neonMagenta,
    shadows: [
      const Shadow(
        color: AppColors.neonMagenta,
        blurRadius: 16,
      ),
    ],
  );

  /// Button label typography
  static final TextStyle button = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
  );

  /// Subtitle / description typography
  static final TextStyle body = GoogleFonts.rajdhani(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );

  /// Setting item title
  static final TextStyle settingTitle = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.textPrimary,
  );
}
