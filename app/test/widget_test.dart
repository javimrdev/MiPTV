import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/core/url_builder.dart';

void main() {
  test('buildStreamUrl constructs correct URL', () {
    final url = buildStreamUrl(
      server: 'http://example.com',
      username: 'user',
      password: 'pass',
      streamId: 42,
      extension: 'ts',
    );
    expect(url, equals('http://example.com/live/user/pass/42.ts'));
  });
}
