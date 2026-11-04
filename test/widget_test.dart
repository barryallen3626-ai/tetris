import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neon_stack/app.dart';
import 'package:neon_stack/core/constants/strings.dart';
import 'package:neon_stack/core/utils/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('NeonStackApp boots and renders home screen', (tester) async {
    SharedPreferences.setMockInitialValues({'neon_stack_high_score': 1000});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const NeonStackApp(),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.play), findsOneWidget);
  });
}
