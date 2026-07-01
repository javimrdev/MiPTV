import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miptv/core/platform/app_platform.dart';

/// A reusable frosted-glass container: blurs whatever sits behind it and
/// overlays a translucent, theme-aware tint plus a hairline border.
///
/// Intended for STATIC chrome (app bars, the floating nav pill, chips,
/// settings sections) — never for per-row use inside a long virtualized
/// list, where a `BackdropFilter` per visible row would cost a blur pass
/// on every scroll frame. See `GlassTileBackground` for the cheap
/// alternative used on list rows.
///
/// The blur is intentionally static (no entrance animation), so this does
/// not need to special-case `MediaQuery.disableAnimations` the way
/// `core/widgets/skeleton.dart`'s pulsing placeholders do.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.blurSigma = 18,
    this.tintAlpha = 0.65,
    this.borderAlpha = 0.12,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double blurSigma;

  /// Alpha of the [ColorScheme.surface] tint layered over the blur. Keep at
  /// ~0.5 or above — lower values let background content (logos, posters)
  /// bleed through enough to hurt text contrast.
  final double tintAlpha;
  final double borderAlpha;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: tintAlpha),
            borderRadius: borderRadius,
            border: Border.all(
              color: scheme.onSurface.withValues(alpha: borderAlpha),
              width: 0.5,
            ),
          ),
          // Any ListTile/Chip/etc. inside `child` paints its background and
          // ink splashes on the nearest Material ancestor; without this, the
          // opaque DecoratedBox above would sit in between and hide them.
          child: Material(type: MaterialType.transparency, child: child),
        ),
      ),
    );
  }
}

/// Cheap translucent-tint wrapper for list rows — NO `BackdropFilter`, since
/// a real-time blur per row inside a virtualized `ListView.builder` would
/// cost a blur pass on every visible row on every scroll frame (SPECS.md
/// requires a fluid 60/120fps scroll). Pass-through on Android.
///
/// Only adds horizontal margin (never vertical), so it fits inside the
/// fixed `itemExtent` (56/72/88px) used by the channel/movie/category lists
/// without changing their row height.
class GlassTileBackground extends StatelessWidget {
  const GlassTileBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isIOSGlass) return child;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        // Side-only border: `Container` adds a decoration border's width as
        // inner padding, and a top/bottom border would eat into the row's
        // fixed `itemExtent` height (see class doc). Left/right only avoids
        // that without giving up the "card edge" look.
        border: Border.symmetric(
          vertical: BorderSide(color: scheme.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      // `ListTile` paints its background/ink splashes on the nearest
      // `Material` ancestor. Without this, the opaque DecoratedBox above
      // would sit between the tile and that ancestor and hide them
      // (Flutter raises a debug assertion for exactly this).
      child: Material(type: MaterialType.transparency, child: child),
    );
  }
}

/// Grid-cell counterpart to [GlassTileBackground]. A grid cell isn't
/// extent-constrained the way a `ListTile` row inside a fixed `itemExtent`
/// is, so this uses a full border/margin on all sides instead of the
/// horizontal-only margin [GlassTileBackground] requires to fit its row
/// height. Same cheap pass-through-on-Android, no-`BackdropFilter`
/// rationale as [GlassTileBackground] — grid cells scroll too.
class GlassGridTileBackground extends StatelessWidget {
  const GlassGridTileBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isIOSGlass) return child;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.08)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(type: MaterialType.transparency, child: child),
    );
  }
}
