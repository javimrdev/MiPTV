import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:miptv/core/db/isar_service.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/logging/app_logger.dart';
import 'package:miptv/core/storage/secure_storage.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/movies/data/vod_category_model.dart';
import 'package:miptv/features/movies/data/vod_stream_model.dart';
import 'package:miptv/features/movies/data/vod_sync_model.dart';
import 'package:miptv/features/movies/domain/movies_repository.dart';
import 'package:miptv/features/provider/data/xtream_api.dart';
import 'package:miptv/features/provider/data/xtream_models.dart';
import 'package:miptv/features/provider/domain/iptv_provider_repository.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  MoviesRepositoryImpl({
    required XtreamApi api,
    required IPTVProviderRepository providerRepo,
    required SecureStorageService secureStorage,
    required IsarService isarService,
  })  : _api = api,
        _providerRepo = providerRepo,
        _secureStorage = secureStorage,
        _isar = isarService.db;

  final XtreamApi _api;
  final IPTVProviderRepository _providerRepo;
  final SecureStorageService _secureStorage;
  final Isar _isar;

  @override
  Future<void> syncCatalog({bool force = false}) async {
    final marker = await _isar.vodSyncModels.where().findFirst() ?? VodSyncModel();
    if (!force && marker.lastSync != null) {
      // Already synced — browsing/search use the local cache.
      return;
    }

    final provider = await _providerRepo.getProvider();
    if (provider == null) return;
    final password = await _secureStorage.readPassword(provider.id);
    if (password == null) return;

    marker.isSyncing = true;
    await _isar.writeTxn(() => _isar.vodSyncModels.put(marker));

    log.i('[Movies] Syncing full VOD catalogue');
    try {
      final rawCategories = await _api.getVodCategories(
        server: provider.server,
        username: provider.username,
        password: password,
      );
      final rawStreams = await _api.getVodStreams(
        server: provider.server,
        username: provider.username,
        password: password,
      );

      final categories = await compute(_mapCategories, rawCategories);
      final streams = await compute(_mapStreams, rawStreams);

      await _isar.writeTxn(() async {
        await _isar.vodCategoryModels.clear();
        await _isar.vodStreamModels.clear();
        await _isar.vodCategoryModels.putAll(categories);
        await _isar.vodStreamModels.putAll(streams);
      });

      marker
        ..isSyncing = false
        ..lastSync = DateTime.now();
      await _isar.writeTxn(() => _isar.vodSyncModels.put(marker));
      log.i('[Movies] Synced ${categories.length} categories / ${streams.length} movies');
    } on AppError catch (e) {
      marker.isSyncing = false;
      await _isar.writeTxn(() => _isar.vodSyncModels.put(marker));
      final cachedCount = await _isar.vodStreamModels.count();
      if (cachedCount > 0) {
        log.w('[Movies] Offline — serving $cachedCount cached movies');
        return;
      }
      log.e('[Movies] Offline and no cached catalogue', error: e);
      rethrow;
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final models = await _isar.vodCategoryModels.where().findAll();
    return models
        .map((m) => CategoryEntity(id: m.categoryId, name: m.name))
        .toList();
  }

  @override
  Future<List<StreamEntity>> getMoviesForCategory(String categoryId) async {
    final models = await _isar.vodStreamModels
        .where()
        .categoryIdEqualTo(categoryId)
        .findAll();
    return models.map(_toEntity).toList();
  }

  @override
  Future<List<StreamEntity>> searchMovies(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];
    final models = await _isar.vodStreamModels
        .filter()
        .nameContains(trimmed, caseSensitive: false)
        .findAll();
    return models.map(_toEntity).toList();
  }
}

StreamEntity _toEntity(VodStreamModel m) => StreamEntity(
      id: m.streamId,
      name: m.name,
      logo: m.logo,
      categoryId: m.categoryId,
      extension: m.extension,
    );

List<VodCategoryModel> _mapCategories(List<XtreamCategory> raw) => raw
    .map((c) => VodCategoryModel()
      ..categoryId = c.categoryId
      ..name = c.categoryName)
    .toList();

List<VodStreamModel> _mapStreams(List<XtreamStream> raw) => raw
    .map((s) => VodStreamModel()
      ..streamId = s.streamId
      ..name = s.name
      ..logo = s.logo
      ..categoryId = s.categoryId
      ..extension = s.extension)
    .toList();
