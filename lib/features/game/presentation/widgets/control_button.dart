import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Tactile on-screen control button supporting hold-to-repeat (DAS / ARR) for rapid movement.
class ControlButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget? icon;
  final String? label;
  final Color color;
  final bool enableRepeat;
  final double size;

  const ControlButton({
    super.key,
    required this.onTap,
    this.icon,
    this.label,
    this.color = AppColors.neonCyan,
    this.enableRepeat = false,
    this.size = 54.0,
  });

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool _isPressed = false;
  Timer? _initialDelayTimer;
  Timer? _repeatTimer;

  void _handleTapDown() {
    setState(() => _isPressed = true);
    widget.onTap();

    if (widget.enableRepeat) {
      _initialDelayTimer?.cancel();
      _repeatTimer?.cancel();

      _initialDelayTimer = Timer(GameConstants.holdRepeatInitialDelay, () {
        _repeatTimer = Timer.periodic(GameConstants.holdRepeatInterval, (_) {
          if (mounted && _isPressed) {
            widget.onTap();
          }
        });
      });
    }
  }

  void _handleTapUp() {
    _cleanupTimers();
    if (mounted) {
      setState(() => _isPressed = false);
    }
  }

  void _cleanupTimers() {
    _initialDelayTimer?.cancel();
    _initialDelayTimer = null;
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  @override
  void dispose() {
    _cleanupTimers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: () => _handleTapUp(),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 70),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _isPressed
                ? widget.color.withValues(alpha: 0.28)
                : AppColors.surfaceGlass,
            borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
            border: Border.all(
              color: widget.color.withValues(alpha: _isPressed ? 1.0 : 0.65),
              width: AppConstants.cardBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _isPressed ? 0.45 : 0.15),
                blurRadius: _isPressed ? 12 : 6,
                spreadRadius: _isPressed ? 1.5 : 0,
              ),
            ],
          ),
          child: Center(
            child: widget.icon ??
                (widget.label != null
                    ? Text(
                        widget.label!,
                        style: AppTextStyles.button.copyWith(
                          fontSize: 13,
                          color: widget.color,
                        ),
                      )
                    : const SizedBox.shrink()),
          ),
        ),
      ),
    );
  }
}
