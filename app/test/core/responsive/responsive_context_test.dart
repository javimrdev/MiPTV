import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/core/responsive/breakpoints.dart';
import 'package:miptv/core/responsive/responsive_context.dart';

void main() {
  Future<bool> isTabletAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    late bool result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            result = context.isTablet;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return result;
  }

  testWidgets('isTablet is false just below the breakpoint', (tester) async {
    expect(
      await isTabletAt(tester, const Size(kTabletBreakpoint - 1, 800)),
      isFalse,
    );
  });

  testWidgets('isTablet is true at and above the breakpoint', (tester) async {
    expect(
      await isTabletAt(tester, const Size(kTabletBreakpoint, 800)),
      isTrue,
    );
    expect(await isTabletAt(tester, const Size(1024, 768)), isTrue);
  });
}
