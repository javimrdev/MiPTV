import 'dart:isolate';
import 'package:isar_community/isar.dart';
import 'package:miptv/core/db/isar_service.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/logging/app_logger.dart';
import 'package:miptv/core/storage/secure_storage.dart';
import 'package:miptv/features/categories/data/category_sync_model.dart';
import 'package:miptv/features/provider/data/xtream_api.dart';
import 'package:miptv/features/provider/data/xtream_models.dart';
import 'package:miptv/features/provider/domain/iptv_provider_repository.dart';
import 'package:miptv/features/streams/data/stream_model.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';
import 'package:miptv/features/streams/domain/stream_repository.dart';

class StreamRepositoryImpl implements StreamRepository {
  StreamRepositoryImpl({
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
  Future<bool> isCategorySynced(String categoryId) async {
    final sync = await _isar.categorySyncModels
        .where()
        .categoryIdEqualTo(categoryId)
        .findFirst();
    return sync != null && !sync.isSyncing;
  }

  @override
  Future<List<StreamEntity>> getStreamsForCategory(String categoryId) async {
    final synced = await isCategorySynced(categoryId);
    if (!synced) {
      await _syncCategory(categoryId);
    }
    return _loadFromDb(categoryId);
  }

  Future<void> _syncCategory(String categoryId) async {
    final provider = await _providerRepo.getProvider();
    if (provider == null) return;
    final password = await _secureStorage.readPassword();
    if (password == null) return;

    // Mark as syncing
    final syncRecord = (await _isar.categorySyncModels
            .where()
            .categoryIdEqualTo(categoryId)
            .findFirst()) ??
        (CategorySyncModel()..categoryId = categoryId);
    syncRecord
      ..isSyncing = true
      ..streamCount = 0;
    await _isar.writeTxn(() => _isar.categorySyncModels.put(syncRecord));

    log.i('[Streams] Lazy sync category=$categoryId');
    try {
      final rawStreams = await _api.getLiveStreams(
        server: provider.server,
        username: provider.username,
        password: password,
        categoryId: categoryId,
      );

      final models = await Isolate.run(() => _mapStreams(rawStreams));

      await _isar.writeTxn(() async {
        await _isar.streamModels
            .where()
            .categoryIdEqualTo(categoryId)
            .deleteAll();
        await _isar.streamModels.putAll(models);
      });

      syncRecord
        ..isSyncing = false
        ..lastSync = DateTime.now()
        ..streamCount = models.length;
      await _isar.writeTxn(() => _isar.categorySyncModels.put(syncRecord));
      log.i('[Streams] Synced ${models.length} streams for $categoryId');
    } on AppError catch (e) {
      final cached = await _loadFromDb(categoryId);
      syncRecord.isSyncing = false;
      await _isar.writeTxn(() => _isar.categorySyncModels.put(syncRecord));
      if (cached.isNotEmpty) {
        log.w('[Streams] Offline — serving ${cached.length} cached streams for $categoryId');
        return;
      }
      log.e('[Streams] Offline and no cache for $categoryId', error: e);
      rethrow;
    }
  }

  Future<List<StreamEntity>> _loadFromDb(String categoryId) async {
    final models = await _isar.streamModels
        .where()
        .categoryIdEqualTo(categoryId)
        .findAll();
    return models
        .map((m) => StreamEntity(
              id: m.streamId,
              name: m.name,
              logo: m.logo,
              categoryId: m.categoryId,
              extension: m.extension,
            ))
        .toList();
  }
}

List<StreamModel> _mapStreams(List<XtreamStream> raw) => raw
    .map((s) => StreamModel()
      ..streamId = s.streamId
      ..name = s.name
      ..logo = s.logo
      ..categoryId = s.categoryId
      ..extension = s.extension)
    .toList();
