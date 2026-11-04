import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../core/widgets/glow_text.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/neon_card.dart';
import '../../game/presentation/game_screen.dart';
import '../../high_score/application/high_score_provider.dart';
import '../../settings/presentation/settings_screen.dart';

/// Title landing screen featuring cyberpunk branding, high score preview,
/// and primary entry points to gameplay and configuration.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highScoreAsync = ref.watch(highScoreProvider);
    final highScore = highScoreAsync.value ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CyberBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Cyberpunk Glowing Title
                  Text(
                    AppStrings.appTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayTitle,
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(
                    AppStrings.appSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      letterSpacing: 3.0,
                      color: AppColors.neonCyan.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXl * 1.5),

                  // High Score Preview Card
                  NeonCard(
                    title: AppStrings.best,
                    accentColor: AppColors.neonMagenta,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingXl,
                      vertical: AppConstants.spacingMd,
                    ),
                    child: GlowText(
                      highScore.toString(),
                      style: AppTextStyles.numericDisplay,
                      glowColor: AppColors.neonMagenta,
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingXl * 1.5),

                  // Play Button
                  NeonButton(
                    label: AppStrings.play,
                    icon: Icons.play_arrow_rounded,
                    color: AppColors.neonCyan,
                    width: 240,
                    height: 54,
                    isFilled: true,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const GameScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Settings Button
                  NeonButton(
                    label: AppStrings.settings,
                    icon: Icons.tune_rounded,
                    color: AppColors.neonPurple,
                    width: 240,
                    height: 50,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
