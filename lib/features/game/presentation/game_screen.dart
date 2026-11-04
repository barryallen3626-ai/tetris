import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../core/utils/sound_service.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../high_score/application/high_score_provider.dart';
import '../../settings/application/settings_controller.dart';
import '../application/game_controller.dart';
import '../application/game_providers.dart';
import '../domain/game_event.dart';
import '../domain/game_state.dart';
import 'widgets/board_view.dart';
import 'widgets/control_pad.dart';
import 'widgets/game_over_overlay.dart';
import 'widgets/hold_panel.dart';
import 'widgets/next_queue_panel.dart';
import 'widgets/pause_overlay.dart';
import 'widgets/score_panel.dart';

/// Main gameplay screen assembling top controls, side panels, board view,
/// and game state overlays within the animated cyber environment.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;

  static const _hapticService = HapticService();
  static const _soundService = StubSoundService();

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: AppConstants.screenShakeDuration,
    );

    // Auto-start game session on screen mount if not already playing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final status = ref.read(gameStatusProvider);
      if (status != GameStatus.playing && status != GameStatus.paused) {
        ref.read(gameControllerProvider.notifier).start();
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerScreenShake() {
    _shakeController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for transient game events to fire haptics, sounds, and save records
    ref.listen<GameEvent>(gameEventProvider, (previous, next) {
      final hapticsEnabled = ref.read(settingsProvider).hapticsEnabled;

      switch (next) {
        case GameEvent.move:
          _hapticService.lightImpact(enabled: hapticsEnabled);
          _soundService.playMove();
          break;
        case GameEvent.rotate:
          _hapticService.lightImpact(enabled: hapticsEnabled);
          _soundService.playRotate();
          break;
        case GameEvent.softDrop:
          _soundService.playSoftDrop();
          break;
        case GameEvent.hardDrop:
          _hapticService.heavyImpact(enabled: hapticsEnabled);
          _soundService.playHardDrop();
          _triggerScreenShake();
          break;
        case GameEvent.lock:
          _hapticService.mediumImpact(enabled: hapticsEnabled);
          _soundService.playLock();
          break;
        case GameEvent.lineClear:
          _hapticService.heavyImpact(enabled: hapticsEnabled);
          _soundService.playLineClear();
          break;
        case GameEvent.tetris:
          _hapticService.heavyImpact(enabled: hapticsEnabled);
          _soundService.playTetris();
          _triggerScreenShake();
          break;
        case GameEvent.levelUp:
          _soundService.playLevelUp();
          break;
        case GameEvent.gameOver:
          _soundService.playGameOver();
          final finalScore = ref.read(scoreProvider);
          ref.read(highScoreProvider.notifier).recordScore(finalScore);
          break;
        case GameEvent.hold:
          _hapticService.lightImpact(enabled: hapticsEnabled);
          break;
        case GameEvent.none:
          break;
      }
    });

    final status = ref.watch(gameStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CyberBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              final offset = sin(_shakeController.value * pi * 4) * 4.0 * (1.0 - _shakeController.value);
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    // Top App Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMd,
                        vertical: AppConstants.spacingXs,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.pause_circle_outline_rounded,
                              color: AppColors.neonCyan,
                              size: 28,
                            ),
                            onPressed: () {
                              ref.read(gameControllerProvider.notifier).pause();
                            },
                          ),
                          Text(
                            AppStrings.appTitle,
                            style: AppTextStyles.panelLabel.copyWith(
                              fontSize: 14,
                              letterSpacing: 3.0,
                              color: AppColors.neonCyan,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: AppColors.textSecondary,
                              size: 24,
                            ),
                            onPressed: () {
                              ref.read(gameControllerProvider.notifier).restart();
                            },
                          ),
                        ],
                      ),
                    ),

                    // Score, Level, Lines Panel
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMd,
                        vertical: AppConstants.spacingXs,
                      ),
                      child: ScorePanel(),
                    ),

                    // Central Game Matrix with side panels
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingSm,
                          vertical: AppConstants.spacingXs,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Hold slot
                            const SizedBox(
                              width: 72,
                              child: HoldPanel(),
                            ),

                            // Center: Board
                            const Expanded(
                              child: BoardView(),
                            ),

                            // Right: Next queue preview
                            const SizedBox(
                              width: 72,
                              child: NextQueuePanel(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Control Pad
                    const ControlPad(),
                  ],
                ),

                // Overlays
                if (status == GameStatus.paused)
                  Positioned.fill(
                    child: PauseOverlay(
                      onExitToHome: () => Navigator.of(context).pop(),
                    ),
                  ),

                if (status == GameStatus.gameOver)
                  Positioned.fill(
                    child: GameOverOverlay(
                      onExitToHome: () => Navigator.of(context).pop(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
