import '../../../core/constants/game_constants.dart';
import 'board.dart';
import 'game_event.dart';
import 'piece.dart';
import 'tetromino_type.dart';

/// Lifecycle statuses of a game session.
enum GameStatus {
  initial,
  playing,
  paused,
  gameOver,
}

/// Immutable state snapshot of the active game session.
class GameState {
  final GameStatus status;
  final Board board;
  final Piece? currentPiece;
  final TetrominoType? holdPiece;
  final bool canHold;
  final List<TetrominoType> nextQueue;
  final int score;
  final int highScore;
  final int lines;
  final int level;
  final bool lastClearWasTetris;
  final List<int> lastClearedRows;
  final int lockResetCount;
  final GameEvent lastEvent;

  const GameState({
    required this.status,
    required this.board,
    this.currentPiece,
    this.holdPiece,
    this.canHold = true,
    this.nextQueue = const [],
    this.score = 0,
    this.highScore = 0,
    this.lines = 0,
    this.level = GameConstants.initialLevel,
    this.lastClearWasTetris = false,
    this.lastClearedRows = const [],
    this.lockResetCount = 0,
    this.lastEvent = GameEvent.none,
  });

  /// Factory for an uninitialized / freshly loaded game state.
  factory GameState.initial({int highScore = 0}) {
    return GameState(
      status: GameStatus.initial,
      board: Board.empty(),
      currentPiece: null,
      holdPiece: null,
      canHold: true,
      nextQueue: const [],
      score: 0,
      highScore: highScore,
      lines: 0,
      level: GameConstants.initialLevel,
      lastClearWasTetris: false,
      lastClearedRows: const [],
      lockResetCount: 0,
      lastEvent: GameEvent.none,
    );
  }

  bool get isPlaying => status == GameStatus.playing;
  bool get isPaused => status == GameStatus.paused;
  bool get isGameOver => status == GameStatus.gameOver;

  /// Returns a modified copy with immutable guarantees.
  GameState copyWith({
    GameStatus? status,
    Board? board,
    Piece? Function()? currentPiece,
    TetrominoType? Function()? holdPiece,
    bool? canHold,
    List<TetrominoType>? nextQueue,
    int? score,
    int? highScore,
    int? lines,
    int? level,
    bool? lastClearWasTetris,
    List<int>? lastClearedRows,
    int? lockResetCount,
    GameEvent? lastEvent,
  }) {
    return GameState(
      status: status ?? this.status,
      board: board ?? this.board,
      currentPiece:
          currentPiece != null ? currentPiece() : this.currentPiece,
      holdPiece: holdPiece != null ? holdPiece() : this.holdPiece,
      canHold: canHold ?? this.canHold,
      nextQueue: nextQueue ?? this.nextQueue,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      lines: lines ?? this.lines,
      level: level ?? this.level,
      lastClearWasTetris: lastClearWasTetris ?? this.lastClearWasTetris,
      lastClearedRows: lastClearedRows ?? this.lastClearedRows,
      lockResetCount: lockResetCount ?? this.lockResetCount,
      lastEvent: lastEvent ?? this.lastEvent,
    );
  }
}
