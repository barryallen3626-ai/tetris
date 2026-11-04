import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Reusable neon button with glowing cyber borders, tactile feedback, and optional icon.
class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final double? width;
  final double height;
  final bool isFilled;

  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.neonCyan,
    this.width,
    this.height = 48.0,
    this.isFilled = false,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.onPressed != null
        ? widget.color
        : AppColors.textMuted;

    return GestureDetector(
      onTapDown: widget.onPressed != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed!();
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 90),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingSm,
          ),
          decoration: BoxDecoration(
            color: widget.isFilled
                ? effectiveColor.withValues(alpha: _isPressed ? 0.4 : 0.25)
                : AppColors.surfaceGlass,
            borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
            border: Border.all(
              color: effectiveColor.withValues(alpha: _isPressed ? 1.0 : 0.7),
              width: AppConstants.cardBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: effectiveColor.withValues(alpha: _isPressed ? 0.45 : 0.2),
                blurRadius: _isPressed ? 14 : AppConstants.glowBlurRadius,
                spreadRadius: _isPressed ? 2 : 0,
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 18,
                    color: effectiveColor,
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                ],
                Text(
                  widget.label,
                  style: AppTextStyles.button.copyWith(
                    color: effectiveColor,
                    shadows: [
                      Shadow(
                        color: effectiveColor.withValues(alpha: 0.7),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
