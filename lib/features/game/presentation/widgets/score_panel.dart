import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../application/game_providers.dart';

/// Panel displaying real-time session statistics: score, level, lines cleared, and record.
class ScorePanel extends ConsumerWidget {
  const ScorePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(scoreProvider);
    final level = ref.watch(levelProvider);
    final lines = ref.watch(linesProvider);

    return NeonCard(
      accentColor: AppColors.neonCyan,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            label: AppStrings.score,
            child: TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: score),
              duration: AppConstants.scoreCountDuration,
              builder: (context, val, _) {
                return Text(
                  val.toString(),
                  style: AppTextStyles.panelValue,
                );
              },
            ),
          ),
          _buildDivider(),
          _buildStatItem(
            label: AppStrings.level,
            child: Text(
              level.toString(),
              style: AppTextStyles.panelValue.copyWith(
                color: AppColors.neonLime,
              ),
            ),
          ),
          _buildDivider(),
          _buildStatItem(
            label: AppStrings.lines,
            child: Text(
              lines.toString(),
              style: AppTextStyles.panelValue.copyWith(
                color: AppColors.neonAmber,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required Widget child,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyles.panelLabel,
        ),
        const SizedBox(height: 2),
        child,
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      color: AppColors.gridLine,
    );
  }
}
