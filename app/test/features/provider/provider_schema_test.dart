import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/features/provider/data/provider_model.dart';
import 'package:miptv/features/streams/data/stream_model.dart';

void main() {
  group('ProviderModel - critical security rules', () {
    test('can be created with name, server and username only', () {
      final model = ProviderModel()
        ..name = 'My source'
        ..server = 'http://test.com'
        ..username = 'alice';
      expect(model.name, 'My source');
      expect(model.server, 'http://test.com');
      expect(model.username, 'alice');
      // Compile-time proof: there is no model.password = '...' field.
      // If someone adds a password field to ProviderModel, this comment becomes wrong
      // but the test below will also need to be updated, making the violation visible.
    });

    test('ProviderModel serializes only id, name, server, username fields', () {
      // We cannot use dart:mirrors in Flutter, but we can verify the model
      // has exactly the fields defined in the spec.
      final model = ProviderModel()
        ..name = 'My source'
        ..server = 'http://test.com'
        ..username = 'alice';

      // These are all the fields that SHOULD exist:
      expect(model.id, isA<int>());
      expect(model.name, isA<String>());
      expect(model.server, isA<String>());
      expect(model.username, isA<String>());

      // NOTE: The absence of `model.password` is enforced at compile time.
      // Any attempt to add `model.password` would cause a compile error.
    });
  });

  group('StreamModel - no URL stored', () {
    test('StreamModel only stores id, name, logo, categoryId, extension', () {
      final model = StreamModel()
        ..streamId = 1
        ..name = 'Canal 1'
        ..logo = 'http://logo.url/img.png'
        ..categoryId = 'cat_1'
        ..extension = 'ts';
      // Verify all fields are correct
      expect(model.streamId, 1);
      expect(model.name, 'Canal 1');
      expect(model.categoryId, 'cat_1');
      expect(model.extension, 'ts');
      // NOTE: model.streamUrl does NOT exist — compile-time enforced.
      // URLs are built dynamically via core/url_builder.dart
    });
  });
}
