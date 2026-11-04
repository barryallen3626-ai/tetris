import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

/// Animated cyberpunk background with perspective grid, moving scanline,
/// and subtle floating cyber particles.
class CyberBackground extends StatefulWidget {
  final Widget child;

  const CyberBackground({
    super.key,
    required this.child,
  });

  @override
  State<CyberBackground> createState() => _CyberBackgroundState();
}

class _CyberBackgroundState extends State<CyberBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Pre-computed normalized particle offsets for zero runtime allocations
  static final List<Point<double>> _particles = List.generate(14, (i) {
    final random = Random(i * 37 + 11);
    return Point(random.nextDouble(), random.nextDouble());
  });

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.scanlineCycleDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background painter isolated with RepaintBoundary
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _CyberBackgroundPainter(
                    progress: _controller.value,
                    particles: _particles,
                  ),
                );
              },
            ),
          ),
        ),
        // Screen foreground content
        widget.child,
      ],
    );
  }
}

class _CyberBackgroundPainter extends CustomPainter {
  final double progress;
  final List<Point<double>> particles;

  _CyberBackgroundPainter({
    required this.progress,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Dark cyber gradient fill
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [
        AppColors.backgroundSecondary,
        AppColors.background,
        AppColors.backgroundDark,
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final bgPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // 2. Subtle neon grid lines
    final gridPaint = Paint()
      ..color = AppColors.gridLineSubtle
      ..strokeWidth = 1.0;

    const cellSize = 36.0;
    final cols = (size.width / cellSize).ceil();
    final rows = (size.height / cellSize).ceil();

    // Subtle drifting vertical lines
    for (int i = 0; i <= cols; i++) {
      final x = i * cellSize;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // Horizontal lines
    for (int j = 0; j <= rows; j++) {
      final y = j * cellSize;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // 3. Floating cyber particles
    final particlePaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < particles.length; i++) {
      final pt = particles[i];
      // Subtle sine wave floating motion
      final offsetY = (pt.y + progress * 0.3) % 1.0;
      final waveX = sin((progress + i) * pi * 2) * 8.0;

      final px = pt.x * size.width + waveX;
      final py = offsetY * size.height;

      final alpha = (sin((progress * 2 + i) * pi) * 0.25 + 0.35).clamp(0.1, 0.6);
      particlePaint.color = (i.isEven ? AppColors.neonCyan : AppColors.neonMagenta)
          .withValues(alpha: alpha);

      canvas.drawCircle(Offset(px, py), i % 3 == 0 ? 1.8 : 1.2, particlePaint);
    }

    // 4. Moving cyber scanline
    final scanlineY = progress * size.height;
    final scanlinePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.neonCyan.withValues(alpha: 0.12),
          AppColors.neonCyan.withValues(alpha: 0.28),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 0.55, 1.0],
      ).createShader(
        Rect.fromLTWH(0, scanlineY - 20, size.width, 40),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, scanlineY - 20, size.width, 40),
      scanlinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CyberBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
