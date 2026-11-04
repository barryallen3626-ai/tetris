import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/application/settings_controller.dart';
import '../domain/board.dart';
import '../domain/game_event.dart';
import '../domain/game_state.dart';
import '../domain/piece.dart';
import '../domain/tetromino_type.dart';
import 'game_controller.dart';

/// Derived provider exposing current game status to avoid unnecessary board rebuilds.
final gameStatusProvider = Provider<GameStatus>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.status));
});

/// Derived provider exposing player score.
final scoreProvider = Provider<int>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.score));
});

/// Derived provider exposing high score.
final currentHighScoreProvider = Provider<int>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.highScore));
});

/// Derived provider exposing player level.
final levelProvider = Provider<int>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.level));
});

/// Derived provider exposing cleared line count.
final linesProvider = Provider<int>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.lines));
});

/// Derived provider exposing the held tetromino type.
final holdPieceProvider = Provider<TetrominoType?>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.holdPiece));
});

/// Derived provider indicating whether hold is currently available for this drop.
final canHoldProvider = Provider<bool>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.canHold));
});

/// Derived provider exposing the preview queue of upcoming tetrominoes.
final nextQueueProvider = Provider<List<TetrominoType>>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.nextQueue));
});

/// Derived provider for the ghost piece (derived landing shadow).
/// Returns null if ghost projection is disabled in settings.
final ghostPieceProvider = Provider<Piece?>((ref) {
  final ghostEnabled =
      ref.watch(settingsProvider.select((s) => s.ghostEnabled));
  if (!ghostEnabled) return null;

  final piece =
      ref.watch(gameControllerProvider.select((s) => s.currentPiece));
  if (piece == null) return null;

  final board = ref.watch(gameControllerProvider.select((s) => s.board));
  return board.calculateGhostPiece(piece);
});

/// Derived provider for active board grid matrix.
final boardProvider = Provider<Board>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.board));
});

/// Derived provider for active falling piece.
final currentPieceProvider = Provider<Piece?>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.currentPiece));
});

/// Derived provider for cleared line animation indices.
final lastClearedRowsProvider = Provider<List<int>>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.lastClearedRows));
});

/// Derived provider for transient game events (used for sound/haptic triggers).
final gameEventProvider = Provider<GameEvent>((ref) {
  return ref.watch(gameControllerProvider.select((s) => s.lastEvent));
});
