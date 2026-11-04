import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_surge/core/utils/shared_prefs_provider.dart';
import 'package:pixel_surge/features/game/application/game_controller.dart';
import 'package:pixel_surge/features/game/domain/game_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameController state transitions', () {
    late ProviderContainer container;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'pixel_surge_high_score': 500});
      prefs = await SharedPreferences.getInstance();
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has empty board and uninitialized piece', () {
      final state = container.read(gameControllerProvider);
      expect(state.status, equals(GameStatus.initial));
      expect(state.currentPiece, isNull);
      expect(state.score, equals(0));
    });

    test('start() initializes game session with active piece and queue', () {
      final controller = container.read(gameControllerProvider.notifier);
      controller.start();

      final state = container.read(gameControllerProvider);
      expect(state.status, equals(GameStatus.playing));
      expect(state.currentPiece, isNotNull);
      expect(state.nextQueue.length, equals(3));
      expect(state.canHold, isTrue);
    });

    test('pause() and resume() update session status', () {
      final controller = container.read(gameControllerProvider.notifier);
      controller.start();

      controller.pause();
      expect(container.read(gameControllerProvider).status, equals(GameStatus.paused));

      controller.resume();
      expect(container.read(gameControllerProvider).status, equals(GameStatus.playing));
    });

    test('moveLeft() and moveRight() translate the active piece', () {
      final controller = container.read(gameControllerProvider.notifier);
      controller.start();

      final initialX = container.read(gameControllerProvider).currentPiece!.position.x;

      controller.moveLeft();
      expect(
        container.read(gameControllerProvider).currentPiece!.position.x,
        equals(initialX - 1),
      );

      controller.moveRight();
      expect(
        container.read(gameControllerProvider).currentPiece!.position.x,
        equals(initialX),
      );
    });

    test('rotateCw() modifies piece rotation', () {
      final controller = container.read(gameControllerProvider.notifier);
      controller.start();

      final initialRot = container.read(gameControllerProvider).currentPiece!.rotation;
      controller.rotateCw();

      final newRot = container.read(gameControllerProvider).currentPiece!.rotation;
      expect(newRot, equals(initialRot + 1));
    });

    test('softDrop() moves piece down and increases score', () {
      final controller = container.read(gameControllerProvider.notifier);
      controller.start();

      final initialY = container.read(gameControllerProvider).currentPiece!.position.y;
      final initialScore = container.read(gameControllerProvider).score;

      controller.softDrop();

      expect(
        container.read(gameControllerProvider).currentPiece!.position.y,
        equals(initialY + 1),
      );
      expect(container.read(gameControllerProvider).score, greaterThan(initialScore));
    });

    test('hold() swaps piece once and disables further holds until lock', () {
      final controller = container.read(gameControllerProvider.notifier);
      controller.start();

      final firstType = container.read(gameControllerProvider).currentPiece!.type;
      controller.hold();

      final stateAfterFirstHold = container.read(gameControllerProvider);
      expect(stateAfterFirstHold.holdPiece, equals(firstType));
      expect(stateAfterFirstHold.canHold, isFalse);

      // Attempting second hold before piece locks must be rejected
      final activeType = stateAfterFirstHold.currentPiece!.type;
      controller.hold();

      final stateAfterSecondHold = container.read(gameControllerProvider);
      expect(stateAfterSecondHold.holdPiece, equals(firstType));
      expect(stateAfterSecondHold.currentPiece!.type, equals(activeType));
    });

    test('hardDrop() instantly locks piece and spawns next piece', () {
      final controller = container.read(gameControllerProvider.notifier);
      controller.start();

      final expectedNextType = container.read(gameControllerProvider).nextQueue.first;

      controller.hardDrop();

      final nextState = container.read(gameControllerProvider);
      // New active piece is spawned from the queue
      expect(nextState.currentPiece!.type, equals(expectedNextType));
      // Hold is reset to enabled
      expect(nextState.canHold, isTrue);
      // Score increased by hard drop points
      expect(nextState.score, greaterThan(0));
    });
  });
}
