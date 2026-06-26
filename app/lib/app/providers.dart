import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miptv/core/db/isar_service.dart';
import 'package:miptv/core/network/dio_client.dart';
import 'package:miptv/core/storage/secure_storage.dart';
import 'package:miptv/features/categories/data/category_repository_impl.dart';
import 'package:miptv/features/categories/domain/category_repository.dart';
import 'package:miptv/features/favorites/data/favorite_repository_impl.dart';
import 'package:miptv/features/favorites/domain/favorite_repository.dart';
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

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(isarService: ref.watch(isarServiceProvider));
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
