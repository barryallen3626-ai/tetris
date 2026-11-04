# PIXEL SURGE ⚡

A cyber-themed Tetris-style falling block game built with Flutter and Riverpod. Featuring high-contrast neon aesthetics, an animated cyber grid background, tactile haptics, and pure Dart game logic following strict DRY and layered architecture principles.

---

## 🎮 Key Features

- **Cyberpunk Visual Identity**:
  - High-contrast near-black navy palette (`#0A0E1A`) with vivid neon cyan, magenta, purple, lime, amber, and crimson accents.
  - Custom-painted animated `CyberBackground` with a perspective neon grid, drifting scanline, and floating cyber particles.
  - Rounded matrix cells with high-visibility neon gradient fills, glowing bevels, and ghost piece landing projections.
  - Line-clear flash animations and screen shake on hard drops and Tetris clears.
- **Pure Dart Domain Layer**:
  - Zero Flutter imports in `lib/features/game/domain/`.
  - Super Rotation System (SRS) rotations with wall kick validation.
  - Fair 7-Bag randomizer.
  - Lock delay buffer (500 ms) allowing last-moment sliding with up to 15 resets.
  - Standard scoring: Single (100), Double (300), Triple (500), Tetris (800) multiplied by level, with a 1.5x back-to-back Tetris bonus.
  - Automatic level progression every 10 lines with exponential gravity speed decay.
- **Strict Riverpod Architecture**:
  - Powered by `Notifier` and `AsyncNotifier` APIs (`flutter_riverpod`).
  - Single Timer gravity loop owned by `GameController` and safely disposed via `ref.onDispose`.
  - Fine-grained derived providers (`ghostPieceProvider`, `nextQueueProvider`, `scoreProvider`, `boardProvider`, etc.) to eliminate unnecessary canvas repaints.
  - Side effects (haptic impulses, audio hooks, persistent high scores) handled cleanly through `ref.listen`.
- **Controls & Interaction**:
  - Responsive layout maintaining a 1:2 board aspect ratio across portrait screen heights without overflow.
  - On-screen cyber control pad with hold-to-repeat (DAS / ARR) support for smooth lateral shifting and soft drops.
  - Touch gestures directly on the board: swipe left/right, downward swipe for soft drop, fast fling for hard drop, and tap to rotate clockwise.
- **Persistence & User Settings**:
  - High score persistence via `HighScoreRepository` and `shared_preferences`.
  - Configuration screen with switches for sound effects, haptic motors, and ghost projection.

---

## 📁 Architecture & Folder Structure

```
lib/
  main.dart                               # Entrypoint, SharedPreferences DI into ProviderScope
  app.dart                                # MaterialApp, dark theme configuration, routes
  core/
    constants/
      app_constants.dart                  # UI dimensions, animation durations, storage keys
      game_constants.dart                 # Board dimensions, scoring rules, timings, wall kicks
      strings.dart                        # Centralized UI copy & cyberpunk terminology
    theme/
      app_colors.dart                     # Neon palette, surfaces, raw ARGB values
      app_text_styles.dart                # Orbitron and Rajdhani typography
      app_theme.dart                      # Material 3 dark theme definition
    utils/
      haptic_service.dart                 # HapticFeedback wrapper with settings gating
      sound_service.dart                  # SoundService interface and stub implementation
      shared_prefs_provider.dart          # Dependency-injected SharedPreferences provider
    widgets/
      cyber_background.dart               # Reusable animated cyber canvas with scanline
      glow_text.dart                      # Layered glowing neon text widget
      neon_button.dart                    # Reusable tactile cyber button
      neon_card.dart                      # Translucent dark-glass container with neon border
  features/
    game/
      domain/                             # PURE DART (No Flutter dependencies)
        tetromino_type.dart               # Enum + data-driven rotation matrices & colors
        piece.dart                        # Immutable Position and Piece models
        board.dart                        # Grid matrix, collision, wall kicks, locking, line clear
        bag_randomizer.dart               # 7-bag generator
        scoring.dart                      # Pure functions for score, levels, gravity interval
        game_state.dart                   # Immutable GameState (copyWith)
        game_event.dart                   # Transient event enum for side effects
      application/
        game_controller.dart              # GameController (Notifier<GameState>)
        game_providers.dart               # Fine-grained derived providers
      presentation/
        game_screen.dart                  # Responsive game layout with screen shake
        widgets/
          board_painter.dart              # CustomPainter rendering the 10x20 matrix
          board_view.dart                 # Interactive board widget with gestures & flash
          cell_preview_painter.dart       # Miniature piece renderer
          control_button.dart             # DAS/ARR tactile button
          control_pad.dart                # Directional and action button clusters
          hold_panel.dart                 # Hold slot with canHold state
          next_queue_panel.dart           # Preview queue of upcoming 3 tetrominoes
          score_panel.dart                # Score tween, level, and lines panel
          pause_overlay.dart              # Pause modal with resume/restart/home
          game_over_overlay.dart          # Game over modal with record highlights
    home/
      presentation/
        home_screen.dart                  # Main title menu with best score card
    settings/
      application/
        settings_controller.dart          # SettingsNotifier + persistence
      presentation/
        settings_screen.dart              # Audio, haptics, ghost, and wipe record toggles
    high_score/
      data/
        high_score_repository.dart        # SharedPreferences high score storage
      application/
        high_score_provider.dart          # HighScoreNotifier (AsyncNotifier)
test/
  domain/                                 # Unit tests for pure Dart logic
    collision_test.dart
    rotation_test.dart
    bag_randomizer_test.dart
    line_clearing_test.dart
    scoring_test.dart
  application/                            # Riverpod controller & notifier tests
    game_controller_test.dart
    settings_controller_test.dart
  presentation/                           # Widget smoke & layout tests
    smoke_test.dart
```

---

## 🚀 Running the Project

### Prerequisites
- Flutter SDK (stable, 3.22+ recommended)
- Dart SDK 3.4+

### Install Dependencies
```bash
flutter pub get
```

### Run on Device or Emulator
```bash
flutter run
```

### Execute Tests
```bash
flutter test
```

### Run Static Analysis
```bash
flutter analyze
```

---

## 🧩 How to Add a New Tetromino

All piece definitions are completely data-driven within a single table in [`lib/features/game/domain/tetromino_type.dart`](lib/features/game/domain/tetromino_type.dart):

1. **Add enum value**:
   ```dart
   enum TetrominoType { i, o, t, s, z, j, l, pentominoX }
   ```
2. **Assign neon color** in `rawColor`:
   ```dart
   case TetrominoType.pentominoX:
     return 0xFF00FFCC;
   ```
3. **Specify spawn position** in `spawnPosition`:
   ```dart
   case TetrominoType.pentominoX:
     return const Position(3, 1);
   ```
4. **Define rotation offsets** in `_rotationsTable`:
   Add 4 lists of relative `Position(dx, dy)` offsets corresponding to rotations 0, 1, 2, and 3.

No new classes or widget alterations are needed; preview rendering, collision detection, wall kicks, and ghost calculations will handle the new piece automatically.

---

## 🎨 How to Add a New Theme Color or Palette

All styling tokens are centralized in [`lib/core/theme/app_colors.dart`](lib/core/theme/app_colors.dart):

1. **Add color constant**:
   ```dart
   static const Color neonPink = Color(0xFFFF1493);
   ```
2. **Apply to components**:
   Assign `neonPink` to `accentColor` in `NeonCard`, `NeonButton`, or inside `AppTheme`.

---

## 🔊 Audio & Haptics Stubs

- **Haptics**: Active via `HapticService` using Flutter's native `HapticFeedback`, respecting user toggle settings.
- **Audio**: An extensible `SoundService` interface is implemented with a `StubSoundService`. To add sound synthesis (e.g., with `audioplayers` or `just_audio`), implement `SoundService` and inject the implementation without altering any game domain code.
