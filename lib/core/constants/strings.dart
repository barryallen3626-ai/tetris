/// Centralized strings used across the application to ensure DRY compliance.
class AppStrings {
  const AppStrings._();

  // App & Header
  static const String appTitle = 'PIXEL SURGE';
  static const String appSubtitle = 'CYBERPUNK PROTOCOL v1.0';

  // Navigation & Buttons
  static const String play = 'INITIALIZE';
  static const String resume = 'RESUME';
  static const String restart = 'REBOOT';
  static const String retry = 'RETRY PROTOCOL';
  static const String home = 'TERMINAL';
  static const String settings = 'SYSTEM CONFIG';
  static const String highScore = 'HIGH SCORES';
  static const String back = 'BACK';
  static const String reset = 'RESET';

  // Game Panels
  static const String hold = 'HOLD';
  static const String next = 'NEXT';
  static const String score = 'SCORE';
  static const String best = 'BEST';
  static const String level = 'LEVEL';
  static const String lines = 'LINES';
  static const String tetris = 'TETRIS!';
  static const String backToBack = 'BACK-TO-BACK!';

  // Overlays
  static const String pausedTitle = 'SYSTEM PAUSED';
  static const String pausedSubtitle = 'Awaiting operator input';
  static const String gameOverTitle = 'SYSTEM OVERLOAD';
  static const String gameOverSubtitle = 'Neural connection collapsed';
  static const String newHighScore = 'NEW RECORD ACHIEVED!';
  static const String finalScore = 'FINAL SCORE';

  // Settings
  static const String soundToggle = 'AUDIO PROTOCOL';
  static const String soundDesc = 'Synthetic sound synthesis';
  static const String hapticsToggle = 'NEURAL HAPTICS';
  static const String hapticsDesc = 'Tactile motor feedback';
  static const String ghostToggle = 'GHOST PROJECTION';
  static const String ghostDesc = 'Display projected landing shadow';
  static const String resetHighScore = 'WIPE RECORD';
  static const String resetHighScoreDesc = 'Reset stored high score to zero';
  static const String resetSuccess = 'System records cleared';

  // Controls
  static const String controlHold = 'HOLD';
  static const String controlDrop = 'DROP';
  static const String controlLeft = '◄';
  static const String controlRight = '►';
  static const String controlDown = '▼';
  static const String controlRotateCw = '↻';
  static const String controlRotateCcw = '↺';
}
