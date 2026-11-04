import 'package:flutter_test/flutter_test.dart';
import 'package:neon_stack/core/constants/game_constants.dart';
import 'package:neon_stack/features/game/domain/board.dart';
import 'package:neon_stack/features/game/domain/piece.dart';
import 'package:neon_stack/features/game/domain/tetromino_type.dart';

void main() {
  group('Rotation and wall kicks', () {
    late Board board;

    setUp(() {
      board = Board.empty();
    });

    test('rotates clockwise in free space without offset kick', () {
      final piece = Piece(
        type: TetrominoType.t,
        position: const Position(4, 5),
        rotation: 0,
      );

      final rotated = board.tryRotate(piece: piece, clockwise: true);
      expect(rotated, isNotNull);
      expect(rotated!.rotation, equals(1));
      expect(rotated.position, equals(const Position(4, 5)));
    });

    test('rotates counter-clockwise in free space', () {
      final piece = Piece(
        type: TetrominoType.t,
        position: const Position(4, 5),
        rotation: 0,
      );

      final rotated = board.tryRotate(piece: piece, clockwise: false);
      expect(rotated, isNotNull);
      expect(rotated!.rotation, equals(-1));
      expect(rotated.normalizedRotation, equals(3));
    });

    test('wall kicks left when rotating against right boundary', () {
      // I piece vertical next to right boundary:
      // In rotation 1 (vertical), column x=7 puts cells at x=7+2 = 9 (rightmost column).
      // Rotating to rotation 2 (horizontal) would put cells at x=7+0..3 = 7, 8, 9, 10 (10 is outside board!).
      // Wall kick offset (-1, 0) shifts it to x=6 (cells 6, 7, 8, 9) which is inside.
      final piece = Piece(
        type: TetrominoType.i,
        position: const Position(7, 5),
        rotation: 1,
      );

      final rotated = board.tryRotate(piece: piece, clockwise: true);
      expect(rotated, isNotNull);
      expect(board.hasCollision(rotated!), isFalse);
      expect(rotated.position.x, lessThan(7));
    });

    test('rejects rotation when completely surrounded / blocked', () {
      // Create a board where cell coordinates around piece are filled
      final rawGrid = List.generate(
        GameConstants.boardTotalHeight,
        (_) => List<int?>.filled(GameConstants.boardWidth, null),
      );

      // Fill entire surrounding area so all kick offsets also collide
      for (int x = 0; x < GameConstants.boardWidth; x++) {
        for (int y = 0; y < GameConstants.boardTotalHeight; y++) {
          // Leave only the original horizontal I piece cells unblocked
          final isInitialCell = y == 6 && x >= 5 && x <= 8;
          if (!isInitialCell) {
            rawGrid[y][x] = 0xFFFFFFFF;
          }
        }
      }

      final blockedBoard = Board.fromGrid(rawGrid);
      final piece = Piece(
        type: TetrominoType.i,
        position: const Position(5, 5),
        rotation: 0,
      );

      final rotated = blockedBoard.tryRotate(piece: piece, clockwise: true);
      expect(rotated, isNull);
    });
  });
}
