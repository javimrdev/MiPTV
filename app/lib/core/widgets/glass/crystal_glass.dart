import 'dart:ui';

import 'package:flutter/material.dart';

/// A richer frosted-glass container than [GlassSurface]: same blur plumbing,
/// but with a vertical gradient tint and a specular highlight along the top
/// edge, so it reads as a "crystal" pane rather than a flat tinted panel.
///
/// Intended for STATIC iOS-only chrome (filter pills, the clear-filters chip,
/// the filter options sheet, the search field) — never for per-row use inside
/// a long virtualized list, for the same blur-per-frame reason as
/// [GlassSurface].
class CrystalGlass extends StatelessWidget {
  const CrystalGlass({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.blurSigma = 20,
    this.tintAlpha = 0.55,
    this.highlightAlpha = 0.18,
    this.borderAlpha = 0.16,
    this.selected = false,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double blurSigma;

  /// Alpha of the [ColorScheme.surface] tint at the bottom of the gradient.
  /// The top of the gradient is lightened by [highlightAlpha] on top of this.
  final double tintAlpha;

  /// Extra white alpha layered along the top edge to simulate a specular
  /// highlight, on top of the base tint gradient.
  final double highlightAlpha;
  final double borderAlpha;

  /// When true, intensifies tint and highlight to visually mark the active
  /// state (e.g. a filter pill with a value set).
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveTint = selected ? tintAlpha + 0.2 : tintAlpha;
    final effectiveHighlight = selected
        ? highlightAlpha + 0.1
        : highlightAlpha;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.alphaBlend(
                  Colors.white.withValues(alpha: effectiveHighlight),
                  scheme.surface.withValues(alpha: effectiveTint),
                ),
                scheme.surface.withValues(alpha: effectiveTint),
              ],
            ),
            border: Border.all(
              color: scheme.onSurface.withValues(alpha: borderAlpha),
              width: 0.6,
            ),
          ),
          // Any ListTile/InkWell/etc. inside `child` paints its ink splashes
          // on the nearest Material ancestor; without this, the opaque
          // DecoratedBox above would sit in between and hide them.
          child: Material(type: MaterialType.transparency, child: child),
        ),
      ),
    );
  }
}
