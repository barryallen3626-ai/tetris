import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_surge/app.dart';
import 'package:pixel_surge/core/constants/strings.dart';
import 'package:pixel_surge/core/utils/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PixelSurgeApp boots and renders home screen', (tester) async {
    SharedPreferences.setMockInitialValues({'pixel_surge_high_score': 1000});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const PixelSurgeApp(),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.play), findsOneWidget);
  });
}
