import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/shared_prefs_provider.dart';
import '../data/high_score_repository.dart';

/// Provider exposing the [HighScoreRepository] instance.
final highScoreRepositoryProvider = Provider<HighScoreRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return HighScoreRepository(prefs);
});

/// AsyncNotifier managing player's persistent high score state.
class HighScoreNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    final repository = ref.watch(highScoreRepositoryProvider);
    return repository.getHighScore();
  }

  /// Updates high score in storage and state if [newScore] is higher.
  Future<void> recordScore(int newScore) async {
    final repository = ref.read(highScoreRepositoryProvider);
    final highest = await repository.saveHighScore(newScore);
    state = AsyncData(highest);
  }

  /// Resets stored high score to 0.
  Future<void> reset() async {
    final repository = ref.read(highScoreRepositoryProvider);
    await repository.resetHighScore();
    state = const AsyncData(0);
  }
}

/// Global provider for the high score value.
final highScoreProvider = AsyncNotifierProvider<HighScoreNotifier, int>(() {
  return HighScoreNotifier();
});
