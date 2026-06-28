import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miptv/core/db/isar_service.dart';
import 'package:miptv/core/network/dio_client.dart';
import 'package:miptv/core/storage/secure_storage.dart';
import 'package:miptv/features/categories/data/category_repository_impl.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/categories/domain/category_repository.dart';
import 'package:miptv/features/favorites/data/favorite_repository_impl.dart';
import 'package:miptv/features/favorites/domain/favorite_repository.dart';
import 'package:miptv/features/movies/data/movies_repository_impl.dart';
import 'package:miptv/features/movies/domain/movies_repository.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';
import 'package:miptv/features/provider/data/xtream_api.dart';
import 'package:miptv/features/provider/data/xtream_provider_repository.dart';
import 'package:miptv/features/provider/domain/iptv_provider_repository.dart';
import 'package:miptv/features/streams/data/stream_repository_impl.dart';
import 'package:miptv/features/streams/domain/stream_repository.dart';

final isarServiceProvider = Provider<IsarService>((ref) => IsarService.instance);

final dioProvider = Provider((ref) => createDioClient());

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => FlutterSecureStorageService(),
);

final xtreamApiProvider = Provider(
  (ref) => XtreamApi(dio: ref.watch(dioProvider)),
);

final providerRepositoryProvider = Provider<IPTVProviderRepository>((ref) {
  return XtreamProviderRepository(
    api: ref.watch(xtreamApiProvider),
    secureStorage: ref.watch(secureStorageProvider),
    isarService: ref.watch(isarServiceProvider),
  );
});

/// Current configured provider (single-provider model). `null` when none.
/// Shared by Home (empty state) and Settings (provider management).
final providerProvider = FutureProvider(
  (ref) => ref.watch(providerRepositoryProvider).getProvider(),
);

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(isarService: ref.watch(isarServiceProvider));
});

/// Cached categories of the current provider. Invalidate after a re-sync.
final categoriesProvider = FutureProvider<List<CategoryEntity>>((ref) {
  return ref.watch(categoryRepositoryProvider).getCategories();
});

final streamRepositoryProvider = Provider<StreamRepository>((ref) {
  return StreamRepositoryImpl(
    api: ref.watch(xtreamApiProvider),
    providerRepo: ref.watch(providerRepositoryProvider),
    secureStorage: ref.watch(secureStorageProvider),
    isarService: ref.watch(isarServiceProvider),
  );
});

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl(isarService: ref.watch(isarServiceProvider));
});

final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  return MoviesRepositoryImpl(
    api: ref.watch(xtreamApiProvider),
    providerRepo: ref.watch(providerRepositoryProvider),
    secureStorage: ref.watch(secureStorageProvider),
    isarService: ref.watch(isarServiceProvider),
  );
});

/// VOD categories. Triggers the one-shot full catalogue sync on first read,
/// then returns the cached categories.
final vodCategoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final repo = ref.watch(moviesRepositoryProvider);
  await repo.syncCatalog();
  return repo.getCategories();
});

/// Movies of a single VOD category (from the local cache).
final vodCategoryMoviesProvider =
    FutureProvider.family<List<StreamEntity>, String>((ref, categoryId) {
  return ref.watch(moviesRepositoryProvider).getMoviesForCategory(categoryId);
});

/// Global VOD search results for the given query.
final vodSearchProvider =
    FutureProvider.family<List<StreamEntity>, String>((ref, query) {
  return ref.watch(moviesRepositoryProvider).searchMovies(query);
});
