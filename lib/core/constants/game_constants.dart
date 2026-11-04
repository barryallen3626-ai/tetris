/// Game constants governing the Tetris board, rules, timings, and scoring.
class GameConstants {
  const GameConstants._();

  /// Board dimensions
  static const int boardWidth = 10;
  static const int boardVisibleHeight = 20;
  static const int hiddenRows = 2;
  static const int boardTotalHeight = boardVisibleHeight + hiddenRows; // 22

  /// Next queue size
  static const int nextQueueDisplayCount = 3;
  static const int bagSize = 7;

  /// Scoring rules
  static const int singleLineScore = 100;
  static const int doubleLineScore = 300;
  static const int tripleLineScore = 500;
  static const int tetrisLineScore = 800;
  static const double backToBackMultiplier = 1.5;
  static const int softDropPointsPerCell = 1;
  static const int hardDropPointsPerCell = 2;

  /// Level & speed progression
  static const int linesPerLevel = 10;
  static const int initialLevel = 1;
  static const int maxLevel = 20;
  static const int baseGravityIntervalMs = 800;
  static const int minGravityIntervalMs = 70;
  static const double speedDecayFactor = 0.86;

  /// Lock delay
  static const int lockDelayMs = 500;
  static const int maxLockResets = 15;

  /// Wall kick offsets to test during rotation: (dx, dy).
  /// In screen grid coordinates: positive x is right, positive y is down.
  /// (0, 0) -> no kick
  /// (-1, 0) -> kick left 1
  /// (1, 0) -> kick right 1
  /// (-2, 0) -> kick left 2
  /// (2, 0) -> kick right 2
  /// (0, -1) -> kick up 1
  static const List<(int, int)> wallKickOffsets = [
    (0, 0),
    (-1, 0),
    (1, 0),
    (-2, 0),
    (2, 0),
    (0, -1),
  ];

  /// Auto-repeat (DAS / ARR) timing for held controls
  static const Duration holdRepeatInitialDelay = Duration(milliseconds: 180);
  static const Duration holdRepeatInterval = Duration(milliseconds: 50);
}
