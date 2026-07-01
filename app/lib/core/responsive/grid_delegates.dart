import 'package:flutter/rendering.dart';

/// Shared grid delegate for poster/logo-driven grids (VOD movie posters
/// today). Lives in `core/` — not `features/movies/` — so
/// `core/widgets/skeleton.dart` can build a loading-state grid with the
/// exact same cell geometry as the real content, without `core/` depending
/// on a feature.
SliverGridDelegateWithMaxCrossAxisExtent postersGridDelegate({
  double maxCrossAxisExtent = 180,
  double mainAxisExtent = 240,
  double spacing = 12,
}) {
  return SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: maxCrossAxisExtent,
    mainAxisExtent: mainAxisExtent,
    crossAxisSpacing: spacing,
    mainAxisSpacing: spacing,
  );
}
