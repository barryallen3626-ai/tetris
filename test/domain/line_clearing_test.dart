import 'package:flutter_test/flutter_test.dart';
import 'package:neon_stack/core/constants/game_constants.dart';
import 'package:neon_stack/features/game/domain/board.dart';

void main() {
  group('Line clearing and row shifting', () {
    test('clears single full row and shifts above rows down', () {
      final rawGrid = List.generate(
        GameConstants.boardTotalHeight,
        (_) => List<int?>.filled(GameConstants.boardWidth, null),
      );

      // Row 20 has a marker at (0, 20)
      rawGrid[20][0] = 0xAA;
      // Row 21 is completely full
      for (int x = 0; x < GameConstants.boardWidth; x++) {
        rawGrid[21][x] = 0xFF;
      }

      final board = Board.fromGrid(rawGrid);
      final result = board.clearLines();

      expect(result.linesCleared, equals(1));
      expect(result.clearedRowIndices, equals([21]));
      // The marker at (0, 20) should now be shifted down to (0, 21)
      expect(result.newBoard.getCell(0, 21), equals(0xAA));
      // Row 0 should be empty
      expect(result.newBoard.getCell(0, 0), isNull);
    });

    test('clears 2 full rows (double)', () {
      final rawGrid = List.generate(
        GameConstants.boardTotalHeight,
        (_) => List<int?>.filled(GameConstants.boardWidth, null),
      );

      for (int x = 0; x < GameConstants.boardWidth; x++) {
        rawGrid[20][x] = 0x11;
        rawGrid[21][x] = 0x22;
      }

      final board = Board.fromGrid(rawGrid);
      final result = board.clearLines();

      expect(result.linesCleared, equals(2));
      expect(result.clearedRowIndices, equals([20, 21]));
      expect(result.newBoard.getCell(0, 21), isNull);
    });

    test('clears 3 full rows (triple)', () {
      final rawGrid = List.generate(
        GameConstants.boardTotalHeight,
        (_) => List<int?>.filled(GameConstants.boardWidth, null),
      );

      for (int y = 19; y <= 21; y++) {
        for (int x = 0; x < GameConstants.boardWidth; x++) {
          rawGrid[y][x] = 0x33;
        }
      }

      final board = Board.fromGrid(rawGrid);
      final result = board.clearLines();

      expect(result.linesCleared, equals(3));
      expect(result.clearedRowIndices, equals([19, 20, 21]));
    });

    test('clears 4 full rows simultaneously (Tetris)', () {
      final rawGrid = List.generate(
        GameConstants.boardTotalHeight,
        (_) => List<int?>.filled(GameConstants.boardWidth, null),
      );

      // Place a sentinel cell on row 17
      rawGrid[17][3] = 0x99;

      // Rows 18, 19, 20, 21 are fully filled
      for (int y = 18; y <= 21; y++) {
        for (int x = 0; x < GameConstants.boardWidth; x++) {
          rawGrid[y][x] = 0x44;
        }
      }

      final board = Board.fromGrid(rawGrid);
      final result = board.clearLines();

      expect(result.linesCleared, equals(4));
      expect(result.clearedRowIndices, equals([18, 19, 20, 21]));
      // The sentinel block at row 17 should now be shifted down by 4 rows to row 21!
      expect(result.newBoard.getCell(3, 21), equals(0x99));
    });
  });
}
