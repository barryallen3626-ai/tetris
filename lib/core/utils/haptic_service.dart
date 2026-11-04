import 'package:flutter/services.dart';

/// Service handling haptic feedback triggers based on user settings.
class HapticService {
  const HapticService();

  /// Light feedback for piece translation or rotation
  void lightImpact({required bool enabled}) {
    if (enabled) {
      HapticFeedback.lightImpact();
    }
  }

  /// Medium feedback for piece locking
  void mediumImpact({required bool enabled}) {
    if (enabled) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Heavy feedback for hard drop and line clear
  void heavyImpact({required bool enabled}) {
    if (enabled) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Feedback for UI button taps
  void selectionClick({required bool enabled}) {
    if (enabled) {
      HapticFeedback.selectionClick();
    }
  }
}
