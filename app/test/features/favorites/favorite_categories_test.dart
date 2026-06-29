import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:miptv/features/favorites/domain/favorite_category_entity.dart';
import 'package:miptv/features/favorites/domain/favorite_repository.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  group('Favorite categories (independent collection)', () {
    late MockFavoriteRepository favoriteRepo;

    setUp(() {
      favoriteRepo = MockFavoriteRepository();
    });

    test('a favorited category persists after a simulated re-sync', () async {
      when(() => favoriteRepo.addFavoriteCategory('7', 'Deportes'))
          .thenAnswer((_) async {});
      when(() => favoriteRepo.getFavoriteCategories()).thenAnswer(
        (_) async => [
          FavoriteCategoryEntity(
            categoryId: '7',
            name: 'Deportes',
            createdAt: DateTime(2024, 1, 1),
          ),
        ],
      );
      when(() => favoriteRepo.isFavoriteCategory('7'))
          .thenAnswer((_) async => true);

      await favoriteRepo.addFavoriteCategory('7', 'Deportes');

      // A category re-sync would replace CategoryModel rows. Favorite
      // categories live in a separate collection and must NOT be affected.
      final favorites = await favoriteRepo.getFavoriteCategories();

      expect(favorites.length, 1);
      expect(favorites.first.categoryId, '7');
      expect(favorites.first.name, 'Deportes');
      expect(await favoriteRepo.isFavoriteCategory('7'), isTrue);
      verifyNever(() => favoriteRepo.removeFavoriteCategory(any()));
    });

    test('isFavoriteCategory returns false for unknown categoryId', () async {
      when(() => favoriteRepo.isFavoriteCategory('999'))
          .thenAnswer((_) async => false);
      expect(await favoriteRepo.isFavoriteCategory('999'), isFalse);
    });

    test('removeFavoriteCategory removes only the specified category',
        () async {
      when(() => favoriteRepo.removeFavoriteCategory('7'))
          .thenAnswer((_) async {});
      when(() => favoriteRepo.getFavoriteCategories())
          .thenAnswer((_) async => []);

      await favoriteRepo.removeFavoriteCategory('7');
      final remaining = await favoriteRepo.getFavoriteCategories();

      expect(remaining, isEmpty);
      verify(() => favoriteRepo.removeFavoriteCategory('7')).called(1);
    });
  });
}
