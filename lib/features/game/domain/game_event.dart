/// Transient event emitted during gameplay to drive animations, sound effects, and haptics.
enum GameEvent {
  none,
  move,
  rotate,
  softDrop,
  hardDrop,
  lock,
  lineClear,
  tetris,
  levelUp,
  gameOver,
  hold,
}
