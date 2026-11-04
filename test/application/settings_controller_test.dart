import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_surge/core/utils/shared_prefs_provider.dart';
import 'package:pixel_surge/features/high_score/application/high_score_provider.dart';
import 'package:pixel_surge/features/settings/application/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsNotifier and HighScoreNotifier', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('settings toggles update state and persist', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(settingsProvider.notifier);

      await notifier.setSound(false);
      expect(container.read(settingsProvider).soundEnabled, isFalse);

      await notifier.setHaptics(false);
      expect(container.read(settingsProvider).hapticsEnabled, isFalse);

      await notifier.setGhost(false);
      expect(container.read(settingsProvider).ghostEnabled, isFalse);
    });

    test('high score notifier records higher scores', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(highScoreProvider.notifier);
      await notifier.recordScore(1200);

      expect(container.read(highScoreProvider).value, equals(1200));

      // Lower score does not overwrite high score
      await notifier.recordScore(800);
      expect(container.read(highScoreProvider).value, equals(1200));

      // Reset wipes score to 0
      await notifier.reset();
      expect(container.read(highScoreProvider).value, equals(0));
    });
  });
}
