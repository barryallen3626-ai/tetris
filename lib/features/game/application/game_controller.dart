import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/game_constants.dart';
import '../../high_score/application/high_score_provider.dart';
import '../domain/bag_randomizer.dart';
import '../domain/board.dart';
import '../domain/game_event.dart';
import '../domain/game_state.dart';
import '../domain/piece.dart';
import '../domain/scoring.dart';
import '../domain/tetromino_type.dart';

/// Riverpod controller managing the active Tetris game loop, piece translations,
/// rotations, lock delay, scoring, and lifecycle transitions.
class GameController extends Notifier<GameState> {
  BagRandomizer _randomizer = BagRandomizer();
  Timer? _gravityTimer;
  Timer? _lockTimer;
  bool _isLocking = false;

  @override
  GameState build() {
    ref.onDispose(_cancelAllTimers);

    // Initial high score is populated from the high score repository
    final savedHighScore = ref.watch(highScoreProvider).value ?? 0;
    return GameState.initial(highScore: savedHighScore);
  }

  /// Cancels any active gravity or lock delay timers.
  void _cancelAllTimers() {
    _gravityTimer?.cancel();
    _gravityTimer = null;
    _lockTimer?.cancel();
    _lockTimer = null;
    _isLocking = false;
  }

  /// Starts or restarts the gravity timer according to the current level speed.
  void _startGravityLoop() {
    _gravityTimer?.cancel();
    final interval = ScoringRules.calculateGravityInterval(state.level);
    _gravityTimer = Timer.periodic(interval, (_) => tick());
  }

  /// Initializes a brand new game session.
  void start() {
    _cancelAllTimers();
    _randomizer = BagRandomizer();

    // Prepare 4 pieces (1 active + 3 preview queue)
    final initialQueue = _randomizer.generateInitialQueue(4);
    final activeType = initialQueue.removeAt(0);
    final activePiece = Piece(
      type: activeType,
      position: activeType.spawnPosition,
    );

    final currentHigh = ref.read(highScoreProvider).value ?? state.highScore;

    state = GameState(
      status: GameStatus.playing,
      board: Board.empty(),
      currentPiece: activePiece,
      nextQueue: initialQueue,
      highScore: currentHigh,
      lastEvent: GameEvent.none,
    );

    _startGravityLoop();
  }

  /// Restarts the game from any state.
  void restart() => start();

  /// Pauses an active game session.
  void pause() {
    if (state.isPlaying) {
      _cancelAllTimers();
      state = state.copyWith(
        status: GameStatus.paused,
        lastEvent: GameEvent.none,
      );
    }
  }

  /// Resumes a paused session.
  void resume() {
    if (state.isPaused) {
      state = state.copyWith(
        status: GameStatus.playing,
        lastEvent: GameEvent.none,
      );
      _startGravityLoop();
    }
  }

  /// Translates current piece 1 column to the left.
  void moveLeft() {
    if (!state.isPlaying || state.currentPiece == null) return;

    final candidate = state.currentPiece!.copyWith(
      position: state.currentPiece!.position.translate(-1, 0),
    );

    if (!state.board.hasCollision(candidate)) {
      state = state.copyWith(
        currentPiece: () => candidate,
        lastEvent: GameEvent.move,
      );
      _handleMovementOnSurface();
    }
  }

  /// Translates current piece 1 column to the right.
  void moveRight() {
    if (!state.isPlaying || state.currentPiece == null) return;

    final candidate = state.currentPiece!.copyWith(
      position: state.currentPiece!.position.translate(1, 0),
    );

    if (!state.board.hasCollision(candidate)) {
      state = state.copyWith(
        currentPiece: () => candidate,
        lastEvent: GameEvent.move,
      );
      _handleMovementOnSurface();
    }
  }

  /// Rotates current piece 90 degrees clockwise with wall kick support.
  void rotateCw() {
    if (!state.isPlaying || state.currentPiece == null) return;

    final rotated = state.board.tryRotate(
      piece: state.currentPiece!,
      clockwise: true,
    );

    if (rotated != null) {
      state = state.copyWith(
        currentPiece: () => rotated,
        lastEvent: GameEvent.rotate,
      );
      _handleMovementOnSurface();
    }
  }

  /// Rotates current piece 90 degrees counter-clockwise with wall kick support.
  void rotateCcw() {
    if (!state.isPlaying || state.currentPiece == null) return;

    final rotated = state.board.tryRotate(
      piece: state.currentPiece!,
      clockwise: false,
    );

    if (rotated != null) {
      state = state.copyWith(
        currentPiece: () => rotated,
        lastEvent: GameEvent.rotate,
      );
      _handleMovementOnSurface();
    }
  }

  /// Drops piece 1 row down, awarding soft drop points.
  void softDrop() {
    if (!state.isPlaying || state.currentPiece == null) return;

    final candidate = state.currentPiece!.copyWith(
      position: state.currentPiece!.position.translate(0, 1),
    );

    if (!state.board.hasCollision(candidate)) {
      final points = ScoringRules.calculateDropScore(
        cells: 1,
        isHardDrop: false,
      );
      state = state.copyWith(
        currentPiece: () => candidate,
        score: state.score + points,
        lastEvent: GameEvent.softDrop,
      );
    } else {
      _startLockCountdown();
    }
  }

  /// Instantly drops piece to its ghost position and locks immediately.
  void hardDrop() {
    if (!state.isPlaying || state.currentPiece == null) return;

    final ghost = state.board.calculateGhostPiece(state.currentPiece!);
    final cellsDropped = ghost.position.y - state.currentPiece!.position.y;
    final points = ScoringRules.calculateDropScore(
      cells: cellsDropped,
      isHardDrop: true,
    );

    state = state.copyWith(
      currentPiece: () => ghost,
      score: state.score + points,
      lastEvent: GameEvent.hardDrop,
    );

    _lockCurrentPiece();
  }

  /// Swaps current piece with hold slot (once per drop).
  void hold() {
    if (!state.isPlaying || state.currentPiece == null || !state.canHold) return;

    _lockTimer?.cancel();
    _isLocking = false;

    final currentType = state.currentPiece!.type;
    final queue = List<TetrominoType>.from(state.nextQueue);

    if (state.holdPiece == null) {
      // First hold: pop next from queue and spawn
      final nextType = queue.removeAt(0);
      queue.add(_randomizer.next());
      final newPiece = Piece(
        type: nextType,
        position: nextType.spawnPosition,
      );

      state = state.copyWith(
        holdPiece: () => currentType,
        currentPiece: () => newPiece,
        nextQueue: queue,
        canHold: false,
        lastEvent: GameEvent.hold,
      );
    } else {
      // Swap with existing hold piece
      final heldType = state.holdPiece!;
      final newPiece = Piece(
        type: heldType,
        position: heldType.spawnPosition,
      );

      state = state.copyWith(
        holdPiece: () => currentType,
        currentPiece: () => newPiece,
        canHold: false,
        lastEvent: GameEvent.hold,
      );
    }
  }

  /// Game gravity tick called periodically by the gravity loop.
  void tick() {
    if (!state.isPlaying || state.currentPiece == null) return;

    final candidate = state.currentPiece!.copyWith(
      position: state.currentPiece!.position.translate(0, 1),
    );

    if (!state.board.hasCollision(candidate)) {
      state = state.copyWith(
        currentPiece: () => candidate,
        lastEvent: GameEvent.none,
      );
      // Cancel lock timer if piece falls freely
      if (_isLocking) {
        _lockTimer?.cancel();
        _isLocking = false;
      }
    } else {
      _startLockCountdown();
    }
  }

  /// Starts the 500ms lock delay timer when touching the floor/stack.
  void _startLockCountdown() {
    if (_isLocking) return;
    _isLocking = true;
    _lockTimer?.cancel();
    _lockTimer = Timer(
      const Duration(milliseconds: GameConstants.lockDelayMs),
      _lockCurrentPiece,
    );
  }

  /// Resets lock delay on lateral move or rotation if within maximum reset allowance.
  void _handleMovementOnSurface() {
    if (state.currentPiece == null) return;

    final below = state.currentPiece!.copyWith(
      position: state.currentPiece!.position.translate(0, 1),
    );

    final isResting = state.board.hasCollision(below);
    if (isResting) {
      if (state.lockResetCount < GameConstants.maxLockResets) {
        _lockTimer?.cancel();
        _isLocking = true;
        _lockTimer = Timer(
          const Duration(milliseconds: GameConstants.lockDelayMs),
          _lockCurrentPiece,
        );
        state = state.copyWith(lockResetCount: state.lockResetCount + 1);
      }
    } else {
      _lockTimer?.cancel();
      _isLocking = false;
    }
  }

  /// Locks the resting piece into the board grid, checks for line clears,
  /// updates score, and spawns the next piece.
  void _lockCurrentPiece() {
    if (!state.isPlaying || state.currentPiece == null) return;

    _lockTimer?.cancel();
    _isLocking = false;

    // Lock piece into board
    final lockedBoard = state.board.lockPiece(state.currentPiece!);
    final clearResult = lockedBoard.clearLines();
    final clearedCount = clearResult.linesCleared;

    final newLines = state.lines + clearedCount;
    final newLevel = ScoringRules.calculateLevel(newLines);
    final isTetris = clearedCount == 4;

    final linePoints = ScoringRules.calculateLineScore(
      linesCleared: clearedCount,
      level: state.level,
      isBackToBack: isTetris && state.lastClearWasTetris,
    );

    final newScore = state.score + linePoints;
    final newHigh = max(newScore, state.highScore);

    // Event determination
    GameEvent event;
    if (newLevel > state.level) {
      event = GameEvent.levelUp;
    } else if (isTetris) {
      event = GameEvent.tetris;
    } else if (clearedCount > 0) {
      event = GameEvent.lineClear;
    } else {
      event = GameEvent.lock;
    }

    // Spawn next piece
    final queue = List<TetrominoType>.from(state.nextQueue);
    final nextType = queue.removeAt(0);
    queue.add(_randomizer.next());

    final spawnedPiece = Piece(
      type: nextType,
      position: nextType.spawnPosition,
    );

    // Check game over
    if (clearResult.newBoard.hasCollision(spawnedPiece)) {
      _cancelAllTimers();
      state = state.copyWith(
        status: GameStatus.gameOver,
        board: clearResult.newBoard,
        currentPiece: () => null,
        score: newScore,
        highScore: newHigh,
        lines: newLines,
        level: newLevel,
        lastClearWasTetris: isTetris,
        lastClearedRows: clearResult.clearedRowIndices,
        lastEvent: GameEvent.gameOver,
      );
      return;
    }

    // Update state for next piece
    final oldLevel = state.level;
    state = state.copyWith(
      board: clearResult.newBoard,
      currentPiece: () => spawnedPiece,
      nextQueue: queue,
      canHold: true,
      score: newScore,
      highScore: newHigh,
      lines: newLines,
      level: newLevel,
      lastClearWasTetris: isTetris,
      lastClearedRows: clearResult.clearedRowIndices,
      lockResetCount: 0,
      lastEvent: event,
    );

    // Adjust gravity timer if level changed
    if (newLevel != oldLevel) {
      _startGravityLoop();
    }
  }
}

/// Global provider for the GameController.
final gameControllerProvider =
    NotifierProvider<GameController, GameState>(() {
  return GameController();
});
