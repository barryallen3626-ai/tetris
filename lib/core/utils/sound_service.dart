/// Abstract interface for game audio effects so concrete audio packages
/// or synthesizers can be plugged in later without modifying game logic.
abstract class SoundService {
  void playMove();
  void playRotate();
  void playSoftDrop();
  void playHardDrop();
  void playLock();
  void playLineClear({int lines = 1});
  void playTetris();
  void playGameOver();
  void playLevelUp();
  void playButtonTap();
}

/// No-op stub implementation for audio effects.
class StubSoundService implements SoundService {
  const StubSoundService();

  @override
  void playMove() {}

  @override
  void playRotate() {}

  @override
  void playSoftDrop() {}

  @override
  void playHardDrop() {}

  @override
  void playLock() {}

  @override
  void playLineClear({int lines = 1}) {}

  @override
  void playTetris() {}

  @override
  void playGameOver() {}

  @override
  void playLevelUp() {}

  @override
  void playButtonTap() {}
}
