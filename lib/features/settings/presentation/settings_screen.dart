import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/neon_card.dart';
import '../../high_score/application/high_score_provider.dart';
import '../application/settings_controller.dart';

/// Settings configuration screen offering toggles for audio, haptics,
/// ghost piece projections, and record management.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CyberBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingSm,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.neonCyan,
                        size: 22,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Text(
                      AppStrings.settings,
                      style: AppTextStyles.overlayTitle.copyWith(
                        fontSize: 20,
                        color: AppColors.neonCyan,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingMd),

              // Configuration items list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingLg,
                  ),
                  children: [
                    _buildSettingCard(
                      title: AppStrings.soundToggle,
                      description: AppStrings.soundDesc,
                      value: settings.soundEnabled,
                      accentColor: AppColors.neonCyan,
                      onChanged: notifier.setSound,
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _buildSettingCard(
                      title: AppStrings.hapticsToggle,
                      description: AppStrings.hapticsDesc,
                      value: settings.hapticsEnabled,
                      accentColor: AppColors.neonPurple,
                      onChanged: notifier.setHaptics,
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _buildSettingCard(
                      title: AppStrings.ghostToggle,
                      description: AppStrings.ghostDesc,
                      value: settings.ghostEnabled,
                      accentColor: AppColors.neonLime,
                      onChanged: notifier.setGhost,
                    ),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Reset High Score section
                    NeonCard(
                      accentColor: AppColors.neonRed,
                      padding: const EdgeInsets.all(AppConstants.spacingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.resetHighScore,
                            style: AppTextStyles.settingTitle.copyWith(
                              color: AppColors.neonRed,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingXs),
                          Text(
                            AppStrings.resetHighScoreDesc,
                            style: AppTextStyles.body,
                          ),
                          const SizedBox(height: AppConstants.spacingMd),
                          NeonButton(
                            label: AppStrings.reset,
                            icon: Icons.delete_outline_rounded,
                            color: AppColors.neonRed,
                            height: 44,
                            onPressed: () async {
                              await ref.read(highScoreProvider.notifier).reset();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.surfaceGlassElevated,
                                    content: Text(
                                      AppStrings.resetSuccess,
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.neonCyan,
                                      ),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String description,
    required bool value,
    required Color accentColor,
    required ValueChanged<bool> onChanged,
  }) {
    return NeonCard(
      accentColor: accentColor,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.settingTitle.copyWith(
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: accentColor,
            activeTrackColor: accentColor.withValues(alpha: 0.35),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.cellEmpty,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
