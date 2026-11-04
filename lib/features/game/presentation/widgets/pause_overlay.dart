import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../application/game_controller.dart';

/// Overlay displayed when the session is paused, offering Resume, Restart, and Exit options.
class PauseOverlay extends ConsumerWidget {
  final VoidCallback onExitToHome;

  const PauseOverlay({
    super.key,
    required this.onExitToHome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                color: AppColors.neonCyan.withValues(alpha: 0.7),
                width: AppConstants.cardBorderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonCyan.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.pausedTitle,
                  style: AppTextStyles.overlayTitle.copyWith(
                    color: AppColors.neonCyan,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXs),
                Text(
                  AppStrings.pausedSubtitle,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppConstants.spacingXl),
                NeonButton(
                  label: AppStrings.resume,
                  icon: Icons.play_arrow_rounded,
                  color: AppColors.neonCyan,
                  width: 200,
                  isFilled: true,
                  onPressed: controller.resume,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                NeonButton(
                  label: AppStrings.restart,
                  icon: Icons.refresh_rounded,
                  color: AppColors.neonAmber,
                  width: 200,
                  onPressed: controller.restart,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                NeonButton(
                  label: AppStrings.home,
                  icon: Icons.home_rounded,
                  color: AppColors.neonPurple,
                  width: 200,
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
