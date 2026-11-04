import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glow_text.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../application/game_controller.dart';
import '../../application/game_providers.dart';

/// Overlay displayed on game over, highlighting final statistics and records.
class GameOverOverlay extends ConsumerWidget {
  final VoidCallback onExitToHome;

  const GameOverOverlay({
    super.key,
    required this.onExitToHome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(scoreProvider);
    final highScore = ref.watch(currentHighScoreProvider);
    final isNewRecord = score >= highScore && score > 0;
    final controller = ref.read(gameControllerProvider.notifier);

    return Container(
      color: AppColors.overlayScrim,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            decoration: BoxDecoration(
              color: AppColors.surfaceGlassElevated,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(
                color: AppColors.neonRed.withValues(alpha: 0.8),
                width: AppConstants.cardBorderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonRed.withValues(alpha: 0.25),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.gameOverTitle,
                  style: AppTextStyles.overlayTitle.copyWith(
                    color: AppColors.neonRed,
                    shadows: [
                      const Shadow(
                        color: AppColors.neonRed,
                        blurRadius: 14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXs),
                Text(
                  AppStrings.gameOverSubtitle,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppConstants.spacingLg),

                if (isNewRecord) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMd,
                      vertical: AppConstants.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neonAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.neonAmber,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      AppStrings.newHighScore,
                      style: AppTextStyles.panelLabel.copyWith(
                        color: AppColors.neonAmber,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                ],

                Text(
                  AppStrings.finalScore,
                  style: AppTextStyles.panelLabel,
                ),
                const SizedBox(height: AppConstants.spacingXs),
                GlowText(
                  score.toString(),
                  style: AppTextStyles.numericDisplay,
                  glowColor: isNewRecord ? AppColors.neonAmber : AppColors.neonMagenta,
                ),
                const SizedBox(height: AppConstants.spacingMd),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppStrings.best}: ',
                      style: AppTextStyles.panelLabel,
                    ),
                    Text(
                      highScore.toString(),
                      style: AppTextStyles.panelValue.copyWith(
                        color: AppColors.neonCyan,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingXl),

                NeonButton(
                  label: AppStrings.retry,
                  icon: Icons.replay_rounded,
                  color: AppColors.neonCyan,
                  width: 220,
                  isFilled: true,
                  onPressed: controller.restart,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                NeonButton(
                  label: AppStrings.home,
                  icon: Icons.home_rounded,
                  color: AppColors.neonPurple,
                  width: 220,
                  onPressed: onExitToHome,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
