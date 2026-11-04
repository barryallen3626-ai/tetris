import '../../../core/constants/game_constants.dart';
import 'piece.dart';

/// Result of evaluating line clearing on the board.
class ClearLinesResult {
  final Board newBoard;
  final List<int> clearedRowIndices;

  const ClearLinesResult({
    required this.newBoard,
    required this.clearedRowIndices,
  });

  int get linesCleared => clearedRowIndices.length;
}

/// Immutable representation of the Tetris grid.
class Board {
  final List<List<int?>> _grid;

  /// Creates an empty board filled with nulls.
  factory Board.empty() {
    final grid = List.generate(
      GameConstants.boardTotalHeight,
      (_) => List<int?>.filled(GameConstants.boardWidth, null),
      growable: false,
    );
    return Board._(grid);
  }

  /// Creates a board from an existing 2D grid matrix.
  factory Board.fromGrid(List<List<int?>> grid) {
    final copy = grid
        .map((row) => List<int?>.from(row, growable: false))
        .toList(growable: false);
    return Board._(copy);
  }

  const Board._(this._grid);

  /// Returns raw grid rows (read-only view).
  List<List<int?>> get grid => _grid;

  /// Cell value at coordinate ([x], [y]) or null if empty or out of bounds.
  int? getCell(int x, int y) {
    if (x < 0 ||
        x >= GameConstants.boardWidth ||
        y < 0 ||
        y >= GameConstants.boardTotalHeight) {
      return null;
    }
    return _grid[y][x];
  }

  /// Whether a cell is within bounds and occupied.
  bool isCellOccupied(int x, int y) {
    if (x < 0 ||
        x >= GameConstants.boardWidth ||
        y < 0 ||
        y >= GameConstants.boardTotalHeight) {
      return false;
    }
    return _grid[y][x] != null;
  }

  /// Checks whether a [Piece] collides with walls, floor, or locked blocks.
  bool hasCollision(Piece piece) {
    for (final pos in piece.absolutePositions) {
      // Horizontal bounds
      if (pos.x < 0 || pos.x >= GameConstants.boardWidth) {
        return true;
      }
      // Floor bound
      if (pos.y >= GameConstants.boardTotalHeight) {
        return true;
      }
      // Stack collision (only if within grid vertically)
      if (pos.y >= 0 && _grid[pos.y][pos.x] != null) {
        return true;
      }
    }
    return false;
  }

  /// Computes the ghost piece position (lowest valid position before collision).
  Piece calculateGhostPiece(Piece piece) {
    Piece ghost = piece;
    while (true) {
      final next = ghost.copyWith(position: ghost.position.translate(0, 1));
      if (hasCollision(next)) {
        break;
      }
      ghost = next;
    }
    return ghost;
  }

  /// Attempts to rotate the piece applying wall kicks from [GameConstants.wallKickOffsets].
  /// Returns the rotated piece with kick applied, or null if rotation is blocked.
  Piece? tryRotate({required Piece piece, required bool clockwise}) {
    final newRotation =
        clockwise ? piece.rotation + 1 : piece.rotation - 1;

    for (final (dx, dy) in GameConstants.wallKickOffsets) {
      final candidate = piece.copyWith(
        rotation: newRotation,
        position: piece.position.translate(dx, dy),
      );
      if (!hasCollision(candidate)) {
        return candidate;
      }
    }
    return null;
  }

  /// Locks a piece into the board and returns a new immutable [Board].
  Board lockPiece(Piece piece) {
    final newGrid = _grid
        .map((row) => List<int?>.from(row))
        .toList();

    for (final pos in piece.absolutePositions) {
      if (pos.y >= 0 &&
          pos.y < GameConstants.boardTotalHeight &&
          pos.x >= 0 &&
          pos.x < GameConstants.boardWidth) {
        newGrid[pos.y][pos.x] = piece.type.rawColor;
      }
    }

    return Board._(
      newGrid.map((row) => List<int?>.unmodifiable(row)).toList(growable: false),
    );
  }

  /// Detects full rows, clears them, and shifts higher rows down.
  ClearLinesResult clearLines() {
    final clearedIndices = <int>[];
    final remainingRows = <List<int?>>[];

    for (int y = 0; y < GameConstants.boardTotalHeight; y++) {
      final isFull = _grid[y].every((cell) => cell != null);
      if (isFull) {
        clearedIndices.add(y);
      } else {
        remainingRows.add(_grid[y]);
      }
    }

    if (clearedIndices.isEmpty) {
      return ClearLinesResult(newBoard: this, clearedRowIndices: const []);
    }

    // Insert new empty rows at the top
    final newGrid = <List<int?>>[];
    for (int i = 0; i < clearedIndices.length; i++) {
      newGrid.add(List<int?>.filled(GameConstants.boardWidth, null));
    }
    newGrid.addAll(remainingRows);

    return ClearLinesResult(
      newBoard: Board._(
        newGrid.map((row) => List<int?>.unmodifiable(row)).toList(growable: false),
      ),
      clearedRowIndices: clearedIndices,
    );
  }
}
