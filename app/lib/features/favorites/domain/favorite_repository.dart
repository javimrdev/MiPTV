import 'package:miptv/features/favorites/domain/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteEntity>> getFavorites();
  Future<void> addFavorite(int streamId);
  Future<void> removeFavorite(int streamId);
  Future<bool> isFavorite(int streamId);
}
