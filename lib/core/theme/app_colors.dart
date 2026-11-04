import 'package:flutter/material.dart';

/// Centralized color palette following the cyberpunk aesthetic:
/// near-black navy backgrounds, glowing neon accents, and distinct tetromino colors.
class AppColors {
  const AppColors._();

  // Backgrounds & Surfaces
  static const Color background = Color(0xFF0A0E1A);
  static const Color backgroundSecondary = Color(0xFF060912);
  static const Color backgroundDark = Color(0xFF070B14);
  static const Color surfaceGlass = Color(0xCC12182B);
  static const Color surfaceGlassElevated = Color(0xE6161F38);
  static const Color gridLine = Color(0x2200E5FF);
  static const Color gridLineSubtle = Color(0x1400E5FF);
  static const Color scanline = Color(0x0A00E5FF);

  // Neon Accents
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonMagenta = Color(0xFFFF007F);
  static const Color neonPurple = Color(0xFFB026FF);
  static const Color neonLime = Color(0xFF00FF66);
  static const Color neonAmber = Color(0xFFFFB800);
  static const Color neonOrange = Color(0xFFFF7700);
  static const Color neonRed = Color(0xFFFF0055);
  static const Color neonBlue = Color(0xFF0077FE);

  // Board cell background
  static const Color cellEmpty = Color(0x1A0F1626);
  static const Color cellEmptyBorder = Color(0x152A3B5C);
  static const Color ghostBorder = Color(0x6600E5FF);
  static const Color ghostFill = Color(0x1500E5FF);

  // Text colors
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B9BB4);
  static const Color textMuted = Color(0xFF4A5568);
  static const Color textGlow = Color(0xFF00E5FF);

  // Overlay scrim
  static const Color overlayScrim = Color(0xD90A0E1A);

  /// Raw 32-bit ARGB values for domain logic or serialization if needed
  static const int rawCyan = 0xFF00E5FF;
  static const int rawYellow = 0xFFFFD700;
  static const int rawPurple = 0xFFB026FF;
  static const int rawLime = 0xFF00FF66;
  static const int rawRed = 0xFFFF0055;
  static const int rawBlue = 0xFF0077FE;
  static const int rawOrange = 0xFFFF7700;

  /// Returns the corresponding neon color for a raw integer value
  static Color fromRaw(int value) => Color(value);
}
