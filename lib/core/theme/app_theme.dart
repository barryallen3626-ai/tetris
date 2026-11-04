import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application theme definition configuring Material 3 dark cyber aesthetic.
class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonCyan,
        secondary: AppColors.neonMagenta,
        tertiary: AppColors.neonPurple,
        surface: AppColors.surfaceGlass,
        error: AppColors.neonRed,
        onPrimary: AppColors.background,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.neonCyan,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.gridLine,
        thickness: 1,
      ),
    );
  }
}
