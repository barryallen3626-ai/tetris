import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../application/game_providers.dart';
import 'tetromino_preview.dart';

/// Panel previewing the upcoming tetrominoes from the 7-bag queue.
class NextQueuePanel extends ConsumerWidget {
  const NextQueuePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(nextQueueProvider);
    final displayQueue = queue.take(GameConstants.nextQueueDisplayCount).toList();

    return NeonCard(
      title: AppStrings.next,
      accentColor: AppColors.neonPurple,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: AppConstants.spacingXs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < displayQueue.length; i++) ...[
            TetrominoPreview(
              type: displayQueue[i],
              size: i == 0 ? 44.0 : 36.0,
            ),
            if (i < displayQueue.length - 1)
              const SizedBox(height: AppConstants.spacingXs),
          ],
        ],
      ),
    );
  }
}
