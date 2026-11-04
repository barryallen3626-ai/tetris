import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/game_controller.dart';
import '../../application/game_providers.dart';
import 'board_painter.dart';

/// Interactive board view widget with gesture controls, line clear flash animations,
/// and responsive aspect ratio fitting.
class BoardView extends ConsumerStatefulWidget {
  const BoardView({super.key});

  @override
  ConsumerState<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends ConsumerState<BoardView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flashController;
  double _dragCumulativeX = 0.0;
  double _dragCumulativeY = 0.0;
  static const double _dragThresholdX = 22.0;
  static const double _dragThresholdY = 24.0;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: AppConstants.lineClearDuration,
    );
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _dragCumulativeX = 0.0;
    _dragCumulativeY = 0.0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final controller = ref.read(gameControllerProvider.notifier);
    _dragCumulativeX += details.delta.dx;
    _dragCumulativeY += details.delta.dy;

    // Horizontal swipe detection
    if (_dragCumulativeX > _dragThresholdX) {
      controller.moveRight();
      _dragCumulativeX = 0.0;
    } else if (_dragCumulativeX < -_dragThresholdX) {
      controller.moveLeft();
      _dragCumulativeX = 0.0;
    }

    // Vertical drag downwards (soft drop)
    if (_dragCumulativeY > _dragThresholdY) {
      controller.softDrop();
      _dragCumulativeY = 0.0;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    // Fast downward velocity flings trigger hard drop
    if (details.velocity.pixelsPerSecond.dy > 800) {
      ref.read(gameControllerProvider.notifier).hardDrop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for line clears to trigger the flash animation
    ref.listen<List<int>>(lastClearedRowsProvider, (previous, next) {
      if (next.isNotEmpty) {
        _flashController.forward(from: 0.0);
      }
    });

    final board = ref.watch(boardProvider);
    final currentPiece = ref.watch(currentPieceProvider);
    final ghostPiece = ref.watch(ghostPieceProvider);
    final clearedRows = ref.watch(lastClearedRowsProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Board has 10 columns by 20 visible rows -> aspect ratio 1 : 2
        const aspectRatio = GameConstants.boardWidth / GameConstants.boardVisibleHeight;

        double boardHeight = constraints.maxHeight;
        double boardWidth = boardHeight * aspectRatio;

        if (boardWidth > constraints.maxWidth) {
          boardWidth = constraints.maxWidth;
          boardHeight = boardWidth / aspectRatio;
        }

        return Center(
          child: Container(
            width: boardWidth,
            height: boardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(
                color: AppColors.neonCyan.withValues(alpha: 0.6),
                width: AppConstants.cardBorderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonCyan.withValues(alpha: 0.18),
                  blurRadius: AppConstants.glowBlurRadius * 1.5,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius - 1),
              child: GestureDetector(
                onTap: () =>
                    ref.read(gameControllerProvider.notifier).rotateCw(),
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _flashController,
                    builder: (context, _) {
                      return CustomPaint(
                        size: Size(boardWidth, boardHeight),
                        painter: BoardPainter(
                          board: board,
                          currentPiece: currentPiece,
                          ghostPiece: ghostPiece,
                          clearedRowIndices: clearedRows,
                          flashProgress: 1.0 - _flashController.value,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
