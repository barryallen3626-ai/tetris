import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Reusable cyber text widget with customizable neon glow and shadow layers.
class GlowText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color glowColor;
  final double glowBlur;
  final TextAlign? textAlign;

  const GlowText(
    this.text, {
    super.key,
    this.style,
    this.glowColor = AppColors.neonCyan,
    this.glowBlur = AppConstants.glowBlurRadius,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? AppTextStyles.panelValue;
    return Text(
      text,
      textAlign: textAlign,
      style: baseStyle.copyWith(
        shadows: [
          Shadow(
            color: glowColor.withValues(alpha: 0.8),
            blurRadius: glowBlur,
          ),
          Shadow(
            color: glowColor.withValues(alpha: 0.4),
            blurRadius: glowBlur * 2.0,
          ),
        ],
      ),
    );
  }
}
