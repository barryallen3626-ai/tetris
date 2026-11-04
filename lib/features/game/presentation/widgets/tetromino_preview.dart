import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/tetromino_type.dart';

/// Renders a centered miniature preview of a [TetrominoType] for Hold and Next panels.
class TetrominoPreview extends StatelessWidget {
  final TetrominoType? type;
  final double size;

  const TetrominoPreview({
    super.key,
    required this.type,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TetrominoPreviewPainter(type: type),
      ),
    );
  }
}

class _TetrominoPreviewPainter extends CustomPainter {
  final TetrominoType? type;

  _TetrominoPreviewPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    if (type == null) return;

    // Use default spawn rotation (rotation 0)
    final offsets = type!.rotations[0];
    final color = Color(type!.rawColor);

    // Compute bounding box of offsets to center within size
    int minX = offsets.first.x;
    int maxX = offsets.first.x;
    int minY = offsets.first.y;
    int maxY = offsets.first.y;

    for (final p in offsets) {
      if (p.x < minX) minX = p.x;
      if (p.x > maxX) maxX = p.x;
      if (p.y < minY) minY = p.y;
      if (p.y > maxY) maxY = p.y;
    }

    final pieceWidth = (maxX - minX + 1);
    final pieceHeight = (maxY - minY + 1);

    // Dynamic cell size to fit snugly inside preview canvas
    final maxDimension = pieceWidth > pieceHeight ? pieceWidth : pieceHeight;
    final cellSize = (size.width - 8) / (maxDimension > 3 ? 4 : 3);

    final startX = (size.width - (pieceWidth * cellSize)) / 2;
    final startY = (size.height - (pieceHeight * cellSize)) / 2;

    final radius = Radius.circular(AppConstants.cellBorderRadius);

    for (final pos in offsets) {
      final cellX = startX + (pos.x - minX) * cellSize;
      final cellY = startY + (pos.y - minY) * cellSize;

      final rect = Rect.fromLTWH(
        cellX + 1.0,
        cellY + 1.0,
        cellSize - 2.0,
        cellSize - 2.0,
      );
      final rrect = RRect.fromRectAndRadius(rect, radius);

      // Gradient fill
      final gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(color, Colors.white, 0.4)!,
          color,
          Color.lerp(color, Colors.black, 0.3)!,
        ],
      );

      final fillPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, fillPaint);

      // Bright border
      final borderPaint = Paint()
        ..color = Color.lerp(color, Colors.white, 0.5)!.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRRect(rrect, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TetrominoPreviewPainter oldDelegate) {
    return oldDelegate.type != type;
  }
}
