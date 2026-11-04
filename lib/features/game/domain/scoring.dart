import 'dart:math';
import '../../../core/constants/game_constants.dart';

/// Pure functions for scoring, level calculations, and gravity speed.
class ScoringRules {
  const ScoringRules._();

  /// Calculates points earned for clearing [linesCleared] at [level].
  /// Back-to-back Tetris earns an additional bonus multiplier.
  static int calculateLineScore({
    required int linesCleared,
    required int level,
    required bool isBackToBack,
  }) {
    if (linesCleared <= 0) return 0;

    int basePoints;
    switch (linesCleared) {
      case 1:
        basePoints = GameConstants.singleLineScore;
        break;
      case 2:
        basePoints = GameConstants.doubleLineScore;
        break;
      case 3:
        basePoints = GameConstants.tripleLineScore;
        break;
      case 4:
        basePoints = GameConstants.tetrisLineScore;
        if (isBackToBack) {
          basePoints = (basePoints * GameConstants.backToBackMultiplier).round();
        }
        break;
      default:
        basePoints = linesCleared * GameConstants.singleLineScore;
    }

    return basePoints * level;
  }

  /// Calculates points for soft or hard dropping [cells] count.
  static int calculateDropScore({
    required int cells,
    required bool isHardDrop,
  }) {
    if (cells <= 0) return 0;
    final multiplier = isHardDrop
        ? GameConstants.hardDropPointsPerCell
        : GameConstants.softDropPointsPerCell;
    return cells * multiplier;
  }

  /// Calculates current level from total lines cleared.
  static int calculateLevel(int totalLinesCleared) {
    final computedLevel = (totalLinesCleared ~/ GameConstants.linesPerLevel) + 1;
    return computedLevel.clamp(GameConstants.initialLevel, GameConstants.maxLevel);
  }

  /// Calculates timer gravity drop interval as a pure decaying function of level.
  static Duration calculateGravityInterval(int level) {
    final exponent = (level - 1).clamp(0, GameConstants.maxLevel);
    final decay = pow(GameConstants.speedDecayFactor, exponent);
    final intervalMs = (GameConstants.baseGravityIntervalMs * decay).round();
    final clampedMs = intervalMs.clamp(
      GameConstants.minGravityIntervalMs,
      GameConstants.baseGravityIntervalMs,
    );
    return Duration(milliseconds: clampedMs);
  }
}
