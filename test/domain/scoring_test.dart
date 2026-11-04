import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_surge/core/constants/game_constants.dart';
import 'package:pixel_surge/features/game/domain/scoring.dart';

void main() {
  group('Scoring and level progression', () {
    test('calculates line scores multiplied by level', () {
      expect(
        ScoringRules.calculateLineScore(
          linesCleared: 1,
          level: 1,
          isBackToBack: false,
        ),
        equals(100),
      );

      expect(
        ScoringRules.calculateLineScore(
          linesCleared: 2,
          level: 2,
          isBackToBack: false,
        ),
        equals(600), // 300 * 2
      );

      expect(
        ScoringRules.calculateLineScore(
          linesCleared: 3,
          level: 3,
          isBackToBack: false,
        ),
        equals(1500), // 500 * 3
      );

      expect(
        ScoringRules.calculateLineScore(
          linesCleared: 4,
          level: 1,
          isBackToBack: false,
        ),
        equals(800), // 800 * 1
      );
    });

    test('applies back-to-back bonus to consecutive tetris clears', () {
      final normalTetris = ScoringRules.calculateLineScore(
        linesCleared: 4,
        level: 2,
        isBackToBack: false,
      );
      final b2bTetris = ScoringRules.calculateLineScore(
        linesCleared: 4,
        level: 2,
        isBackToBack: true,
      );

      expect(normalTetris, equals(1600)); // 800 * 2
      expect(b2bTetris, equals(2400)); // 800 * 1.5 * 2
    });

    test('calculates drop scores properly', () {
      expect(
        ScoringRules.calculateDropScore(cells: 10, isHardDrop: false),
        equals(10), // 1 point per cell
      );
      expect(
        ScoringRules.calculateDropScore(cells: 10, isHardDrop: true),
        equals(20), // 2 points per cell
      );
    });

    test('levels up every 10 lines', () {
      expect(ScoringRules.calculateLevel(0), equals(1));
      expect(ScoringRules.calculateLevel(9), equals(1));
      expect(ScoringRules.calculateLevel(10), equals(2));
      expect(ScoringRules.calculateLevel(25), equals(3));
    });

    test('gravity interval gets faster (shorter duration) as level increases', () {
      final level1Interval = ScoringRules.calculateGravityInterval(1);
      final level5Interval = ScoringRules.calculateGravityInterval(5);
      final level10Interval = ScoringRules.calculateGravityInterval(10);

      expect(level5Interval, lessThan(level1Interval));
      expect(level10Interval, lessThan(level5Interval));
      expect(
        level10Interval.inMilliseconds,
        greaterThanOrEqualTo(GameConstants.minGravityIntervalMs),
      );
    });
  });
}
