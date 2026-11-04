import 'piece.dart';

/// The seven standard tetromino types in Tetris.
enum TetrominoType {
  i,
  o,
  t,
  s,
  z,
  j,
  l;

  /// Raw 32-bit ARGB color value for each piece's neon identity.
  int get rawColor {
    switch (this) {
      case TetrominoType.i:
        return 0xFF00E5FF; // Neon Cyan
      case TetrominoType.o:
        return 0xFFFFD700; // Neon Amber / Gold
      case TetrominoType.t:
        return 0xFFB026FF; // Electric Purple
      case TetrominoType.s:
        return 0xFF00FF66; // Neon Lime
      case TetrominoType.z:
        return 0xFFFF0055; // Neon Crimson
      case TetrominoType.j:
        return 0xFF0077FE; // Electric Blue
      case TetrominoType.l:
        return 0xFFFF7700; // Neon Orange
    }
  }

  /// Initial spawn position on the board.
  /// Top 2 rows (0 and 1) are hidden spawn rows; visible starts at row 2.
  Position get spawnPosition {
    switch (this) {
      case TetrominoType.o:
        return const Position(4, 1);
      case TetrominoType.i:
        return const Position(3, 0);
      default:
        return const Position(3, 1);
    }
  }

  /// Rotation matrices: list of 4 rotation states (0, 1, 2, 3).
  /// Each state contains 4 relative [Position] cell coordinates.
  /// Defined in one data table according to standard SRS definitions.
  List<List<Position>> get rotations {
    return _rotationsTable[this]!;
  }

  static final Map<TetrominoType, List<List<Position>>> _rotationsTable = {
    // I piece (4x4 bounding box)
    TetrominoType.i: [
      [
        const Position(0, 1),
        const Position(1, 1),
        const Position(2, 1),
        const Position(3, 1),
      ],
      [
        const Position(2, 0),
        const Position(2, 1),
        const Position(2, 2),
        const Position(2, 3),
      ],
      [
        const Position(0, 2),
        const Position(1, 2),
        const Position(2, 2),
        const Position(3, 2),
      ],
      [
        const Position(1, 0),
        const Position(1, 1),
        const Position(1, 2),
        const Position(1, 3),
      ],
    ],

    // O piece (2x2 bounding box - invariant under rotation)
    TetrominoType.o: [
      [
        const Position(0, 0),
        const Position(1, 0),
        const Position(0, 1),
        const Position(1, 1),
      ],
      [
        const Position(0, 0),
        const Position(1, 0),
        const Position(0, 1),
        const Position(1, 1),
      ],
      [
        const Position(0, 0),
        const Position(1, 0),
        const Position(0, 1),
        const Position(1, 1),
      ],
      [
        const Position(0, 0),
        const Position(1, 0),
        const Position(0, 1),
        const Position(1, 1),
      ],
    ],

    // T piece (3x3 bounding box)
    TetrominoType.t: [
      [
        const Position(1, 0),
        const Position(0, 1),
        const Position(1, 1),
        const Position(2, 1),
      ],
      [
        const Position(1, 0),
        const Position(1, 1),
        const Position(2, 1),
        const Position(1, 2),
      ],
      [
        const Position(0, 1),
        const Position(1, 1),
        const Position(2, 1),
        const Position(1, 2),
      ],
      [
        const Position(1, 0),
        const Position(0, 1),
        const Position(1, 1),
        const Position(1, 2),
      ],
    ],

    // S piece (3x3 bounding box)
    TetrominoType.s: [
      [
        const Position(1, 0),
        const Position(2, 0),
        const Position(0, 1),
        const Position(1, 1),
      ],
      [
        const Position(1, 0),
        const Position(1, 1),
        const Position(2, 1),
        const Position(2, 2),
      ],
      [
        const Position(1, 1),
        const Position(2, 1),
        const Position(0, 2),
        const Position(1, 2),
      ],
      [
        const Position(0, 0),
        const Position(0, 1),
        const Position(1, 1),
        const Position(1, 2),
      ],
    ],

    // Z piece (3x3 bounding box)
    TetrominoType.z: [
      [
        const Position(0, 0),
        const Position(1, 0),
        const Position(1, 1),
        const Position(2, 1),
      ],
      [
        const Position(2, 0),
        const Position(1, 1),
        const Position(2, 1),
        const Position(1, 2),
      ],
      [
        const Position(0, 1),
        const Position(1, 1),
        const Position(1, 2),
        const Position(2, 2),
      ],
      [
        const Position(1, 0),
        const Position(0, 1),
        const Position(1, 1),
        const Position(0, 2),
      ],
    ],

    // J piece (3x3 bounding box)
    TetrominoType.j: [
      [
        const Position(0, 0),
        const Position(0, 1),
        const Position(1, 1),
        const Position(2, 1),
      ],
      [
        const Position(1, 0),
        const Position(2, 0),
        const Position(1, 1),
        const Position(1, 2),
      ],
      [
        const Position(0, 1),
        const Position(1, 1),
        const Position(2, 1),
        const Position(2, 2),
      ],
      [
        const Position(1, 0),
        const Position(1, 1),
        const Position(0, 2),
        const Position(1, 2),
      ],
    ],

    // L piece (3x3 bounding box)
    TetrominoType.l: [
      [
        const Position(2, 0),
        const Position(0, 1),
        const Position(1, 1),
        const Position(2, 1),
      ],
      [
        const Position(1, 0),
        const Position(1, 1),
        const Position(1, 2),
        const Position(2, 2),
      ],
      [
        const Position(0, 1),
        const Position(1, 1),
        const Position(2, 1),
        const Position(0, 2),
      ],
      [
        const Position(0, 0),
        const Position(1, 0),
        const Position(1, 1),
        const Position(1, 2),
      ],
    ],
  };
}
