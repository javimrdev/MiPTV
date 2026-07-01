import 'package:flutter/widgets.dart';
import 'package:miptv/core/responsive/breakpoints.dart';

/// Tablet-vs-phone detection based purely on the current window width, not
/// on `Platform`/device-idiom/shortest-side. This is deliberate:
///
/// - iPad Split View / Slide Over and Android split-screen/multi-window are
///   already allowed today (no `UIRequiresFullScreen`, no
///   `resizeableActivity="false"`), so a width check makes the layout
///   degrade to the phone list automatically as the window narrows, with no
///   extra logic needed to keep multitasking "safe".
/// - A large phone rotated to landscape will also get the wide-screen
///   layout — intended, not a bug, per the "grid on wide screens" scope.
///
/// In widget tests, `MediaQuery.sizeOf` reflects
/// `tester.view.physicalSize / tester.view.devicePixelRatio`, so tests can
/// drive this deterministically by setting `tester.view.physicalSize`
/// (with `addTearDown(tester.view.reset)`).
extension ResponsiveContext on BuildContext {
  bool get isTablet => MediaQuery.sizeOf(this).width >= kTabletBreakpoint;
}
