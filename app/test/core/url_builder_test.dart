import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/core/url_builder.dart';

void main() {
  group('buildStreamUrl', () {
    test('formats correct path: server/live/username/password/streamId.ext', () {
      final url = buildStreamUrl(
        server: 'http://example.com',
        username: 'user',
        password: 'pass',
        streamId: 42,
        extension: 'ts',
      );
      expect(url, 'http://example.com/live/user/pass/42.ts');
    });

    test('strips trailing slash from server', () {
      final url = buildStreamUrl(
        server: 'http://example.com/',
        username: 'user',
        password: 'pass',
        streamId: 1,
        extension: 'm3u8',
      );
      expect(url, 'http://example.com/live/user/pass/1.m3u8');
    });

    test('does NOT contain password in any static field', () {
      // Validate that the URL is constructed dynamically (no partial hardcoding)
      const password = 's3cr3t';
      final url = buildStreamUrl(
        server: 'http://tv.test',
        username: 'alice',
        password: password,
        streamId: 99,
        extension: 'ts',
      );
      expect(url.contains(password), isTrue,
          reason: 'URL should include password at build time (dynamic construction)');
      expect(url, 'http://tv.test/live/alice/s3cr3t/99.ts');
    });
  });
}
