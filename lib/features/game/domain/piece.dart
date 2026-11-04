import 'tetromino_type.dart';

/// Immutable 2D integer coordinate in board grid space.
class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  /// Adds another [Position] offset.
  Position operator +(Position other) => Position(x + other.x, y + other.y);

  /// Translates position by [dx] columns and [dy] rows.
  Position translate(int dx, int dy) => Position(x + dx, y + dy);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x, $y)';
}

/// An active or preview tetromino piece with type, rotation state, and board position.
class Piece {
  final TetrominoType type;
  final int rotation;
  final Position position;

  const Piece({
    required this.type,
    this.rotation = 0,
    required this.position,
  });

  /// The normalized rotation index between 0 and 3.
  int get normalizedRotation => (rotation % 4 + 4) % 4;

  /// Absolute coordinates of the 4 cells on the board.
  List<Position> get absolutePositions {
    final offsets = type.rotations[normalizedRotation];
    return offsets.map((offset) => position + offset).toList(growable: false);
  }

  /// Creates a copy with optionally modified properties.
  Piece copyWith({
    TetrominoType? type,
    int? rotation,
    Position? position,
  }) {
    return Piece(
      type: type ?? this.type,
      rotation: rotation ?? this.rotation,
      position: position ?? this.position,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Piece &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          rotation == other.rotation &&
          position == other.position;

  @override
  int get hashCode => Object.hash(type, rotation, position);

  @override
  String toString() => 'Piece(${type.name}, rot: $rotation, pos: $position)';
}
