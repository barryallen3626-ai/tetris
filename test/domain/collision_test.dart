import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_surge/core/constants/game_constants.dart';
import 'package:pixel_surge/features/game/domain/board.dart';
import 'package:pixel_surge/features/game/domain/piece.dart';
import 'package:pixel_surge/features/game/domain/tetromino_type.dart';

void main() {
  group('Board collision detection', () {
    late Board board;

    setUp(() {
      board = Board.empty();
    });

    test('fresh board has no collision with valid spawn piece', () {
      final piece = Piece(
        type: TetrominoType.t,
        position: const Position(3, 5),
      );
      expect(board.hasCollision(piece), isFalse);
    });

    test('collides when moved past left wall (x < 0)', () {
      final piece = Piece(
        type: TetrominoType.i,
        position: const Position(-1, 5),
      );
      expect(board.hasCollision(piece), isTrue);
    });

    test('collides when moved past right wall (x >= boardWidth)', () {
      final piece = Piece(
        type: TetrominoType.i,
        position: const Position(8, 5), // I piece extends 4 wide in horizontal rotation
      );
      expect(board.hasCollision(piece), isTrue);
    });

    test('collides when reaching or passing floor (y >= boardTotalHeight)', () {
      final piece = Piece(
        type: TetrominoType.o,
        position: Position(4, GameConstants.boardTotalHeight - 1),
      );
      // O piece is 2 cells tall, so y + 1 is boardTotalHeight -> collision
      expect(board.hasCollision(piece), isTrue);
    });

    test('collides with locked stack cells', () {
      final lockedPiece = Piece(
        type: TetrominoType.o,
        position: const Position(4, 18),
      );
      final lockedBoard = board.lockPiece(lockedPiece);

      final fallingPiece = Piece(
        type: TetrominoType.t,
        position: const Position(4, 18),
      );
      expect(lockedBoard.hasCollision(fallingPiece), isTrue);
    });

    test('calculates correct ghost piece position', () {
      final piece = Piece(
        type: TetrominoType.o,
        position: const Position(4, 0),
      );
      final ghost = board.calculateGhostPiece(piece);

      // On an empty board, the 2x2 O piece lands at y = boardTotalHeight - 2
      expect(ghost.position.y, equals(GameConstants.boardTotalHeight - 2));
      expect(ghost.position.x, equals(4));
    });
  });
}
