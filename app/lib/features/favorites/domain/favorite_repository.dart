import 'package:miptv/features/favorites/domain/favorite_category_entity.dart';
import 'package:miptv/features/favorites/domain/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteEntity>> getFavorites();
  Future<void> addFavorite(int streamId);
  Future<void> removeFavorite(int streamId);
  Future<bool> isFavorite(int streamId);

  Future<List<FavoriteCategoryEntity>> getFavoriteCategories();
  Future<void> addFavoriteCategory(String categoryId, String name);
  Future<void> removeFavoriteCategory(String categoryId);
  Future<bool> isFavoriteCategory(String categoryId);
}
