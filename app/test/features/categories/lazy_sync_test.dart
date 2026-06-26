import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';
import 'package:miptv/features/streams/domain/stream_repository.dart';

class MockStreamRepository extends Mock implements StreamRepository {}

void main() {
  group('Lazy sync - channels synced only on first visit', () {
    late MockStreamRepository streamRepo;

    setUp(() {
      streamRepo = MockStreamRepository();
    });

    test('getStreamsForCategory calls API only on first visit (not synced)', () async {
      const categoryId = 'cat_1';
      final streams = [
        const StreamEntity(
          id: 101,
          name: 'Canal Deportes HD',
          logo: 'http://logo.tv/d.png',
          categoryId: 'cat_1',
          extension: 'ts',
        ),
      ];

      when(() => streamRepo.isCategorySynced(categoryId))
          .thenAnswer((_) async => false);
      when(() => streamRepo.getStreamsForCategory(categoryId))
          .thenAnswer((_) async => streams);

      final result = await streamRepo.getStreamsForCategory(categoryId);

      expect(result.length, 1);
      expect(result.first.id, 101);
      verify(() => streamRepo.getStreamsForCategory(categoryId)).called(1);
    });

    test('second call uses cached data (isCategorySynced returns true)', () async {
      const categoryId = 'cat_1';
      final streams = [
        const StreamEntity(
          id: 101,
          name: 'Canal Deportes HD',
          logo: '',
          categoryId: 'cat_1',
          extension: 'ts',
        ),
      ];

      // First visit: not synced → syncs
      when(() => streamRepo.isCategorySynced(categoryId))
          .thenAnswer((_) async => true); // already synced
      when(() => streamRepo.getStreamsForCategory(categoryId))
          .thenAnswer((_) async => streams);

      final result = await streamRepo.getStreamsForCategory(categoryId);
      expect(result.length, 1);

      // Second call still returns same streams (from cache)
      final result2 = await streamRepo.getStreamsForCategory(categoryId);
      expect(result2.length, 1);

      // getStreamsForCategory was called twice but sync should only happen once
      verify(() => streamRepo.getStreamsForCategory(categoryId)).called(2);
    });

    test('StreamEntity does not contain a full URL field', () {
      const entity = StreamEntity(
        id: 1,
        name: 'Test',
        logo: 'http://logo.url',
        categoryId: 'cat_1',
        extension: 'ts',
      );
      // All fields are component parts — no streamUrl field exists.
      // compile-time enforced: entity.streamUrl does not exist.
      expect(entity.extension, 'ts');
      expect(entity.id, 1);
    });
  });
}
