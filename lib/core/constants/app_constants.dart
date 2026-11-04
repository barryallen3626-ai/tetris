/// Application-wide constants for storage keys, UI dimensions, and animation durations.
class AppConstants {
  const AppConstants._();

  /// App info
  static const String appName = 'PIXEL SURGE';
  static const String appTagline = 'CYBERPUNK PIXEL PROTOCOL';
  static const String appVersion = '1.0.0';

  /// SharedPreferences storage keys
  static const String keyHighScore = 'pixel_surge_high_score';
  static const String keySoundEnabled = 'pixel_surge_sound_enabled';
  static const String keyHapticsEnabled = 'pixel_surge_haptics_enabled';
  static const String keyGhostEnabled = 'pixel_surge_ghost_enabled';

  /// Animation durations
  static const Duration lineClearDuration = Duration(milliseconds: 250);
  static const Duration screenShakeDuration = Duration(milliseconds: 180);
  static const Duration overlayTransitionDuration = Duration(milliseconds: 220);
  static const Duration scoreCountDuration = Duration(milliseconds: 350);
  static const Duration scanlineCycleDuration = Duration(seconds: 8);
  static const Duration pulseAnimationDuration = Duration(milliseconds: 1200);

  /// Visual dimensions
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 10.0;
  static const double cellBorderRadius = 4.0;
  static const double cardBorderWidth = 1.5;
  static const double glowBlurRadius = 10.0;
  static const double cellGlowRadius = 6.0;

  /// Margins and paddings
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
}
