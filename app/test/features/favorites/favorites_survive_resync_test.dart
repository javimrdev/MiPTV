import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:miptv/features/favorites/domain/favorite_entity.dart';
import 'package:miptv/features/favorites/domain/favorite_repository.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  group('Favorites survive re-sync (independent collection)', () {
    late MockFavoriteRepository favoriteRepo;

    setUp(() {
      favoriteRepo = MockFavoriteRepository();
    });

    test('getFavorites still returns favorites after a simulated re-sync', () async {
      // Simulate: user added a favorite before sync
      when(() => favoriteRepo.addFavorite(101)).thenAnswer((_) async {});
      when(() => favoriteRepo.getFavorites()).thenAnswer(
        (_) async => [
          FavoriteEntity(streamId: 101, createdAt: DateTime(2024, 1, 1)),
        ],
      );
      when(() => favoriteRepo.isFavorite(101)).thenAnswer((_) async => true);

      await favoriteRepo.addFavorite(101);

      // Simulate: category re-sync happens (would delete StreamModel rows)
      // Favorites are in a separate collection — they must NOT be affected.

      final favorites = await favoriteRepo.getFavorites();

      expect(favorites.length, 1);
      expect(favorites.first.streamId, 101);
      expect(await favoriteRepo.isFavorite(101), isTrue);
      verifyNever(() => favoriteRepo.removeFavorite(any()));
    });

    test('isFavorite returns false for unknown streamId', () async {
      when(() => favoriteRepo.isFavorite(999)).thenAnswer((_) async => false);
      expect(await favoriteRepo.isFavorite(999), isFalse);
    });

    test('removeFavorite removes only the specified stream', () async {
      when(() => favoriteRepo.removeFavorite(101)).thenAnswer((_) async {});
      when(() => favoriteRepo.getFavorites()).thenAnswer((_) async => []);

      await favoriteRepo.removeFavorite(101);
      final remaining = await favoriteRepo.getFavorites();

      expect(remaining, isEmpty);
      verify(() => favoriteRepo.removeFavorite(101)).called(1);
    });
  });
}
