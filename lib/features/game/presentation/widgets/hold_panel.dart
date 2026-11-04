import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../application/game_controller.dart';
import '../../application/game_providers.dart';
import 'tetromino_preview.dart';

/// Hold panel displaying the stored piece and its availability state.
class HoldPanel extends ConsumerWidget {
  const HoldPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdPiece = ref.watch(holdPieceProvider);
    final canHold = ref.watch(canHoldProvider);

    return NeonCard(
      title: AppStrings.hold,
      accentColor: canHold ? AppColors.neonCyan : AppColors.textMuted,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: AppConstants.spacingXs,
      ),
      onTap: () => ref.read(gameControllerProvider.notifier).hold(),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: canHold ? 1.0 : 0.45,
        child: TetrominoPreview(
          type: holdPiece,
          size: 44.0,
        ),
      ),
    );
  }
}
