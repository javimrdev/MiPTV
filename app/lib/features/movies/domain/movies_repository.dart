import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

/// VOD (movies) data source. The whole catalogue is synced once
/// (see [syncCatalog]); browsing and searching are then local Isar queries.
abstract class MoviesRepository {
  /// Syncs the full VOD catalogue (categories + every movie) on first use.
  /// Subsequent calls are no-ops unless [force] is true. Serves cached data
  /// when offline. Safe to call on every Movies-tab entry.
  Future<void> syncCatalog({bool force = false});

  /// VOD categories from the local cache.
  Future<List<CategoryEntity>> getCategories();

  /// Movies belonging to [categoryId] from the local cache.
  Future<List<StreamEntity>> getMoviesForCategory(String categoryId);

  /// Global search across the whole VOD catalogue by movie name.
  Future<List<StreamEntity>> searchMovies(String query);
}
