---
name: progress_animation_builder-progress
description: >-
  Use when animating widgets based on target fractional values (0.0 to 1.0)
  such as progress bars, gauges, or animated icons without managing AnimationControllers manually using progress_animation_builder.
---

# progress_animation_builder Progress Animation Guide

`progress_animation_builder` provides an implicit animation builder that smoothly animates an `Animation<double>` towards a target `value` (between `0.0` and `1.0`). It eliminates the need to create custom `AnimationController` and ticker boilerplate.

## Guidelines

- **Mounting the Builder**:
  - Use `ProgressAnimationBuilder(value: targetValue, duration: Duration(...), builder: (context, animation) => ...)`.
  - Ensure `value` is strictly clamped between `0.0` and `1.0`.
- **Applying Curves**:
  - Pass a curve (e.g. `curve: Curves.easeInOut`, `Curves.fastOutSlowIn`) to customize the easing behavior.
- **Animating Downstream Widgets**:
  - Forward the received `Animation<double>` directly into widgets like `AnimatedIcon(progress: animation)` or custom painters/transition widgets.
- **Dynamic Updates**:
  - Whenever the parent widget changes `value`, `ProgressAnimationBuilder` automatically calculates the difference and smoothly interpolates from the current animated position to the new value.

## Examples

### 1. Animating AnimatedIcon (Play / Pause)

```dart
import 'package:flutter/material.dart';
import 'package:progress_animation_builder/progress_animation_builder.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({super.key});

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  var _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 48,
      onPressed: () => setState(() => _isPlaying = !_isPlaying),
      icon: ProgressAnimationBuilder(
        value: _isPlaying ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, animation) {
          return AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: animation,
          );
        },
      ),
    );
  }
}
```

### 2. Smooth Custom Progress Bar

```dart
import 'package:flutter/material.dart';
import 'package:progress_animation_builder/progress_animation_builder.dart';

class SmoothProgressBar extends StatelessWidget {
  const SmoothProgressBar({super.key, required this.progressPercent});

  /// Target progress value from 0.0 to 1.0
  final double progressPercent;

  @override
  Widget build(BuildContext context) {
    return ProgressAnimationBuilder(
      value: progressPercent.clamp(0.0, 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return LinearProgressIndicator(
              value: animation.value,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            );
          },
        );
      },
    );
  }
}
```

## Common Pitfalls & Anti-Patterns

- ❌ **Anti-pattern**: Passing a `value` outside the `[0.0, 1.0]` range, triggering an assertion error.
  - ✔️ **Correct**: Always clamp values using `.clamp(0.0, 1.0)`.
- ❌ **Anti-pattern**: Manually instantiating an `AnimationController` and calling `animateTo()` in `didUpdateWidget`.
  - ✔️ **Correct**: Use `ProgressAnimationBuilder`, which encapsulates this exact pattern declaratively.
