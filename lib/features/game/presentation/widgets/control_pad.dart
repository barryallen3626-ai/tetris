import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/game_controller.dart';
import 'control_button.dart';

/// Ergonomic on-screen cyber control pad with hold-to-repeat for directional movements.
class ControlPad extends ConsumerWidget {
  const ControlPad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingXs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Cluster: Directional controls (Left, Soft Drop, Right)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ControlButton(
                onTap: controller.moveLeft,
                label: AppStrings.controlLeft,
                enableRepeat: true,
                color: AppColors.neonCyan,
                size: 50.0,
              ),
              const SizedBox(width: AppConstants.spacingSm),
              ControlButton(
                onTap: controller.softDrop,
                label: AppStrings.controlDown,
                enableRepeat: true,
                color: AppColors.neonLime,
                size: 50.0,
              ),
              const SizedBox(width: AppConstants.spacingSm),
              ControlButton(
                onTap: controller.moveRight,
                label: AppStrings.controlRight,
                enableRepeat: true,
                color: AppColors.neonCyan,
                size: 50.0,
              ),
            ],
          ),

          // Right Cluster: Rotations and Drops (CCW, CW, Hard Drop)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ControlButton(
                onTap: controller.rotateCcw,
                label: AppStrings.controlRotateCcw,
                color: AppColors.neonPurple,
                size: 50.0,
              ),
              const SizedBox(width: AppConstants.spacingSm),
              ControlButton(
                onTap: controller.rotateCw,
                label: AppStrings.controlRotateCw,
                color: AppColors.neonCyan,
                size: 50.0,
              ),
              const SizedBox(width: AppConstants.spacingSm),
              ControlButton(
                onTap: controller.hardDrop,
                label: AppStrings.controlDrop,
                color: AppColors.neonMagenta,
                size: 50.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
