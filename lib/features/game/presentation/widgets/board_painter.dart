import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/board.dart';
import '../../domain/piece.dart';

/// CustomPainter rendering the entire 10x20 Tetris matrix in a single canvas pass:
/// grid lines, ghost piece outline, active tetromino, locked stack cells, and clear flashes.
class BoardPainter extends CustomPainter {
  final Board board;
  final Piece? currentPiece;
  final Piece? ghostPiece;
  final List<int> clearedRowIndices;
  final double flashProgress;

  BoardPainter({
    required this.board,
    required this.currentPiece,
    required this.ghostPiece,
    this.clearedRowIndices = const [],
    this.flashProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / GameConstants.boardWidth;
    final radius = Radius.circular(AppConstants.cellBorderRadius);

    final emptyCellPaint = Paint()
      ..color = AppColors.cellEmpty
      ..style = PaintingStyle.fill;

    final emptyBorderPaint = Paint()
      ..color = AppColors.cellEmptyBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;

    // 1. Draw grid background & locked stack
    for (int y = GameConstants.hiddenRows; y < GameConstants.boardTotalHeight; y++) {
      final visibleY = y - GameConstants.hiddenRows;
      final isClearedRow = clearedRowIndices.contains(y);

      for (int x = 0; x < GameConstants.boardWidth; x++) {
        final cellRect = Rect.fromLTWH(
          x * cellSize + 1.0,
          visibleY * cellSize + 1.0,
          cellSize - 2.0,
          cellSize - 2.0,
        );
        final cellRRect = RRect.fromRectAndRadius(cellRect, radius);

        final cellValue = board.getCell(x, y);

        if (cellValue != null) {
          if (isClearedRow && flashProgress > 0) {
            // Blinding line clear flash
            final flashColor = Color.lerp(
              Colors.white,
              AppColors.neonCyan,
              1.0 - flashProgress,
            )!.withValues(alpha: flashProgress);

            final flashPaint = Paint()..color = flashColor;
            canvas.drawRRect(cellRRect, flashPaint);
          } else {
            _drawCyberCell(
              canvas: canvas,
              rrect: cellRRect,
              rect: cellRect,
              color: Color(cellValue),
              glow: false,
            );
          }
        } else {
          // Empty grid cell
          canvas.drawRRect(cellRRect, emptyCellPaint);
          canvas.drawRRect(cellRRect, emptyBorderPaint);
        }
      }
    }

    // 2. Draw ghost piece outline
    if (ghostPiece != null) {
      final ghostFillPaint = Paint()
        ..color = AppColors.ghostFill
        ..style = PaintingStyle.fill;

      final ghostBorderPaint = Paint()
        ..color = AppColors.ghostBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      for (final pos in ghostPiece!.absolutePositions) {
        if (pos.y >= GameConstants.hiddenRows) {
          final visibleY = pos.y - GameConstants.hiddenRows;
          final rect = Rect.fromLTWH(
            pos.x * cellSize + 1.5,
            visibleY * cellSize + 1.5,
            cellSize - 3.0,
            cellSize - 3.0,
          );
          final rrect = RRect.fromRectAndRadius(rect, radius);
          canvas.drawRRect(rrect, ghostFillPaint);
          canvas.drawRRect(rrect, ghostBorderPaint);
        }
      }
    }

    // 3. Draw active falling piece
    if (currentPiece != null) {
      final color = Color(currentPiece!.type.rawColor);
      for (final pos in currentPiece!.absolutePositions) {
        if (pos.y >= GameConstants.hiddenRows) {
          final visibleY = pos.y - GameConstants.hiddenRows;
          final cellRect = Rect.fromLTWH(
            pos.x * cellSize + 1.0,
            visibleY * cellSize + 1.0,
            cellSize - 2.0,
            cellSize - 2.0,
          );
          final cellRRect = RRect.fromRectAndRadius(cellRect, radius);
          _drawCyberCell(
            canvas: canvas,
            rrect: cellRRect,
            rect: cellRect,
            color: color,
            glow: true,
          );
        }
      }
    }
  }

  /// Draws a single rounded cyber cell with high-contrast gradient, inner bevel, and neon glow.
  void _drawCyberCell({
    required Canvas canvas,
    required RRect rrect,
    required Rect rect,
    required Color color,
    required bool glow,
  }) {
    // Outer glow for active piece
    if (glow) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawRRect(rrect, glowPaint);
    }

    // Cell gradient fill
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(color, Colors.white, 0.4)!,
        color,
        Color.lerp(color, Colors.black, 0.3)!,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final fillPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, fillPaint);

    // Inner bright border
    final borderPaint = Paint()
      ..color = Color.lerp(color, Colors.white, 0.5)!.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return oldDelegate.board != board ||
        oldDelegate.currentPiece != currentPiece ||
        oldDelegate.ghostPiece != ghostPiece ||
        oldDelegate.clearedRowIndices != clearedRowIndices ||
        oldDelegate.flashProgress != flashProgress;
  }
}
