import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/core/responsive/breakpoints.dart';

/// Sets the test window to a tablet-width viewport and registers the
/// teardown that restores it. Call once per test before `pumpWidget`.
void setTabletViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1024, 768);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Sets the test window to a phone-width viewport (below [kTabletBreakpoint])
/// and registers the teardown that restores it.
void setPhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = Size(kTabletBreakpoint - 100, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}
