import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/core/responsive/content_width_cap.dart';

void main() {
  final childKey = UniqueKey();

  Future<double> renderedWidthAt(WidgetTester tester, Size viewport) async {
    tester.view.physicalSize = viewport;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: ContentWidthCap(
          maxWidth: 480,
          child: SizedBox.expand(key: childKey),
        ),
      ),
    );
    return tester.getSize(find.byKey(childKey)).width;
  }

  testWidgets('is a no-op below maxWidth', (tester) async {
    expect(await renderedWidthAt(tester, const Size(360, 800)), 360);
  });

  testWidgets('clamps to maxWidth above it', (tester) async {
    expect(await renderedWidthAt(tester, const Size(1024, 800)), 480);
  });
}
