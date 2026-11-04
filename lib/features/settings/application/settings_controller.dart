import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/shared_prefs_provider.dart';

/// Immutable model representing user preferences.
class SettingsState {
  final bool soundEnabled;
  final bool hapticsEnabled;
  final bool ghostEnabled;

  const SettingsState({
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.ghostEnabled = true,
  });

  SettingsState copyWith({
    bool? soundEnabled,
    bool? hapticsEnabled,
    bool? ghostEnabled,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      ghostEnabled: ghostEnabled ?? this.ghostEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsState &&
          runtimeType == other.runtimeType &&
          soundEnabled == other.soundEnabled &&
          hapticsEnabled == other.hapticsEnabled &&
          ghostEnabled == other.ghostEnabled;

  @override
  int get hashCode => Object.hash(soundEnabled, hapticsEnabled, ghostEnabled);
}

/// Notifier managing persisted user settings.
class SettingsNotifier extends Notifier<SettingsState> {
  late SharedPreferences _prefs;

  @override
  SettingsState build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    final sound = _prefs.getBool(AppConstants.keySoundEnabled) ?? true;
    final haptics = _prefs.getBool(AppConstants.keyHapticsEnabled) ?? true;
    final ghost = _prefs.getBool(AppConstants.keyGhostEnabled) ?? true;

    return SettingsState(
      soundEnabled: sound,
      hapticsEnabled: haptics,
      ghostEnabled: ghost,
    );
  }

  /// Sets sound effects enabled state and persists.
  Future<void> setSound(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _prefs.setBool(AppConstants.keySoundEnabled, enabled);
  }

  /// Sets haptics enabled state and persists.
  Future<void> setHaptics(bool enabled) async {
    state = state.copyWith(hapticsEnabled: enabled);
    await _prefs.setBool(AppConstants.keyHapticsEnabled, enabled);
  }

  /// Sets ghost piece projection state and persists.
  Future<void> setGhost(bool enabled) async {
    state = state.copyWith(ghostEnabled: enabled);
    await _prefs.setBool(AppConstants.keyGhostEnabled, enabled);
  }
}

/// Global provider for user settings.
final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
