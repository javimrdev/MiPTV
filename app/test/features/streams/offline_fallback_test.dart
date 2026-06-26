import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';
import 'package:miptv/features/streams/domain/stream_repository.dart';

class MockStreamRepository extends Mock implements StreamRepository {}

void main() {
  group('Offline fallback — StreamRepository', () {
    late MockStreamRepository streamRepo;

    setUp(() {
      streamRepo = MockStreamRepository();
    });

    test('returns cached streams when API throws NoConnectionError', () async {
      const categoryId = 'cat_1';
      final cached = [
        const StreamEntity(
          id: 101,
          name: 'Canal Deportes HD',
          logo: 'http://logo.tv/d.png',
          categoryId: 'cat_1',
          extension: 'ts',
        ),
      ];

      // Simulate: category was previously synced, network is gone
      when(() => streamRepo.isCategorySynced(categoryId))
          .thenAnswer((_) async => true);
      // getStreamsForCategory should return cached data (not rethrow NoConnectionError)
      when(() => streamRepo.getStreamsForCategory(categoryId))
          .thenAnswer((_) async => cached);

      final result = await streamRepo.getStreamsForCategory(categoryId);

      expect(result, isNotEmpty);
      expect(result.first.id, 101);
      // The repository should NOT propagate the error when cache is available
      verifyNever(() => streamRepo.isCategorySynced(any()));
    });

    test('rethrows NoConnectionError when there is no cached data', () async {
      const categoryId = 'cat_new';

      when(() => streamRepo.isCategorySynced(categoryId))
          .thenAnswer((_) async => false);
      when(() => streamRepo.getStreamsForCategory(categoryId))
          .thenThrow(const NoConnectionError());

      expect(
        () => streamRepo.getStreamsForCategory(categoryId),
        throwsA(isA<NoConnectionError>()),
      );
    });

    test('NoConnectionError has correct user message', () {
      const error = NoConnectionError();
      expect(
        error.userMessage,
        contains('Sin conexión'),
      );
    });

    test('NetworkTimeoutError has correct user message', () {
      const error = NetworkTimeoutError();
      expect(
        error.userMessage,
        contains('tardó demasiado'),
      );
    });
  });
}
