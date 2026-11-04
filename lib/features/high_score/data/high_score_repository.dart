import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

/// Repository handling persistent storage for player high scores.
class HighScoreRepository {
  final SharedPreferences _prefs;

  const HighScoreRepository(this._prefs);

  /// Loads the persisted high score from storage, defaulting to 0.
  int getHighScore() {
    return _prefs.getInt(AppConstants.keyHighScore) ?? 0;
  }

  /// Saves a new high score if it exceeds the current record.
  Future<int> saveHighScore(int newScore) async {
    final currentHigh = getHighScore();
    if (newScore > currentHigh) {
      await _prefs.setInt(AppConstants.keyHighScore, newScore);
      return newScore;
    }
    return currentHigh;
  }

  /// Resets the persisted high score back to 0.
  Future<void> resetHighScore() async {
    await _prefs.remove(AppConstants.keyHighScore);
  }
}
