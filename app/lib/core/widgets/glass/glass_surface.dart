import 'dart:ui';

import 'package:flutter/material.dart';

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

/// No-op pass-through for list rows. List rows deliberately don't get the
/// frosted-glass treatment (unlike static chrome such as app bars, the nav
/// pill, or chips) — kept as a wrapper so call sites don't need to change.
class GlassTileBackground extends StatelessWidget {
  const GlassTileBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Grid-cell counterpart to [GlassTileBackground]. Same no-op pass-through —
/// grid cells (e.g. movie posters) don't get the frosted-glass treatment.
class GlassGridTileBackground extends StatelessWidget {
  const GlassGridTileBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
