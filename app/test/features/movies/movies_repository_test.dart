import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/movies/domain/movies_repository.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

class MockMoviesRepository extends Mock implements MoviesRepository {}

void main() {
  group('MoviesRepository contract', () {
    late MockMoviesRepository repo;

    setUp(() {
      repo = MockMoviesRepository();
    });

    test('syncCatalog populates categories then they are readable', () async {
      final cats = [
        const CategoryEntity(id: '10', name: 'Acción'),
        const CategoryEntity(id: '11', name: 'Comedia'),
      ];
      when(() => repo.syncCatalog()).thenAnswer((_) async {});
      when(() => repo.getCategories()).thenAnswer((_) async => cats);

      await repo.syncCatalog();
      final result = await repo.getCategories();

      expect(result.length, 2);
      expect(result.first.id, '10');
      verify(() => repo.syncCatalog()).called(1);
    });

    test('getMoviesForCategory returns only that category', () async {
      final movies = [
        const StreamEntity(
          id: 5001,
          name: 'Película Uno',
          logo: 'http://logo.tv/m1.png',
          categoryId: '10',
          extension: 'mp4',
        ),
      ];
      when(() => repo.getMoviesForCategory('10'))
          .thenAnswer((_) async => movies);

      final result = await repo.getMoviesForCategory('10');

      expect(result.length, 1);
      expect(result.first.categoryId, '10');
      expect(result.first.extension, 'mp4');
    });

    test('searchMovies filters by name across the catalogue', () async {
      final hits = [
        const StreamEntity(
          id: 5002,
          name: 'Película Dos',
          logo: '',
          categoryId: '11',
          extension: 'mkv',
        ),
      ];
      when(() => repo.searchMovies('dos')).thenAnswer((_) async => hits);
      when(() => repo.searchMovies('inexistente'))
          .thenAnswer((_) async => <StreamEntity>[]);

      expect((await repo.searchMovies('dos')).single.id, 5002);
      expect(await repo.searchMovies('inexistente'), isEmpty);
    });
  });
}
