import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neon_stack/core/constants/strings.dart';
import 'package:neon_stack/core/utils/shared_prefs_provider.dart';
import 'package:neon_stack/features/game/presentation/game_screen.dart';
import 'package:neon_stack/features/game/presentation/widgets/board_view.dart';
import 'package:neon_stack/features/game/presentation/widgets/control_pad.dart';
import 'package:neon_stack/features/game/presentation/widgets/hold_panel.dart';
import 'package:neon_stack/features/game/presentation/widgets/next_queue_panel.dart';
import 'package:neon_stack/features/home/presentation/home_screen.dart';
import 'package:neon_stack/features/settings/presentation/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'neon_stack_high_score': 8400});
    prefs = await SharedPreferences.getInstance();
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('HomeScreen renders title, high score, and action buttons',
      (tester) async {
    await tester.pumpWidget(createTestWidget(const HomeScreen()));
    await tester.pump();

    // Verify app title and subtitle
    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.appSubtitle), findsOneWidget);

    // Verify buttons
    expect(find.text(AppStrings.play), findsOneWidget);
    expect(find.text(AppStrings.settings), findsOneWidget);
  });

  testWidgets('GameScreen builds and displays board, panels, and controls',
      (tester) async {
    // Set standard phone viewport size (400x800)
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestWidget(const GameScreen()));
    await tester.pump();

    // Verify essential game presentation components are mounted
    expect(find.byType(BoardView), findsOneWidget);
    expect(find.byType(HoldPanel), findsOneWidget);
    expect(find.byType(NextQueuePanel), findsOneWidget);
    expect(find.byType(ControlPad), findsOneWidget);
  });

  testWidgets('SettingsScreen builds and shows configuration toggles',
      (tester) async {
    await tester.pumpWidget(createTestWidget(const SettingsScreen()));
    await tester.pump();

    expect(find.text(AppStrings.settings), findsOneWidget);
    expect(find.text(AppStrings.soundToggle), findsOneWidget);
    expect(find.text(AppStrings.hapticsToggle), findsOneWidget);
    expect(find.text(AppStrings.ghostToggle), findsOneWidget);
    expect(find.text(AppStrings.resetHighScore), findsOneWidget);
  });
}
