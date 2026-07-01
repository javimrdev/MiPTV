import 'package:flutter/widgets.dart';

/// Caps [child]'s width at [maxWidth] and centers it, so content doesn't
/// stretch edge-to-edge on wide (tablet) screens.
///
/// `ConstrainedBox` only clamps an upper bound, so on phone widths (already
/// narrower than [maxWidth]) this is a structural no-op — it can be applied
/// unconditionally at call sites without an `if (context.isTablet)` check.
class ContentWidthCap extends StatelessWidget {
  const ContentWidthCap({
    super.key,
    required this.maxWidth,
    required this.child,
  });

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
