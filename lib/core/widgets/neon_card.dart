import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Reusable dark-glass cyber container with customizable neon glowing border and header.
class NeonCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color accentColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool glow;
  final VoidCallback? onTap;

  const NeonCard({
    super.key,
    required this.child,
    this.title,
    this.accentColor = AppColors.neonCyan,
    this.padding = const EdgeInsets.all(AppConstants.spacingSm),
    this.borderRadius = AppConstants.cardBorderRadius,
    this.glow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.6),
          width: AppConstants.cardBorderWidth,
        ),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.15),
                  blurRadius: AppConstants.glowBlurRadius,
                  spreadRadius: 1.0,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null) ...[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    title!,
                    style: AppTextStyles.panelLabel.copyWith(
                      color: accentColor.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingXs),
          ],
          child,
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}
