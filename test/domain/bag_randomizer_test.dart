import 'package:flutter_test/flutter_test.dart';
import 'package:neon_stack/core/constants/game_constants.dart';
import 'package:neon_stack/features/game/domain/bag_randomizer.dart';
import 'package:neon_stack/features/game/domain/tetromino_type.dart';

void main() {
  group('BagRandomizer 7-bag generation', () {
    test('generates all 7 distinct tetrominoes in each bag cycle', () {
      final randomizer = BagRandomizer();

      // Check across 5 complete consecutive 7-piece bags
      for (int cycle = 0; cycle < 5; cycle++) {
        final bag = <TetrominoType>[];
        for (int i = 0; i < GameConstants.bagSize; i++) {
          bag.add(randomizer.next());
        }

        expect(bag.length, equals(7));
        // Verify every TetrominoType is present exactly once
        expect(bag.toSet(), equals(TetrominoType.values.toSet()));
      }
    });

    test('generateInitialQueue deals correct number of pieces', () {
      final randomizer = BagRandomizer();
      final queue = randomizer.generateInitialQueue(3);

      expect(queue.length, equals(3));
    });
  });
}
