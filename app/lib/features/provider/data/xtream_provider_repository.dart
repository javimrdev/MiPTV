import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:miptv/core/db/isar_service.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/logging/app_logger.dart';
import 'package:miptv/core/storage/secure_storage.dart';
import 'package:miptv/features/categories/data/category_model.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/provider/data/provider_model.dart';
import 'package:miptv/features/provider/data/xtream_api.dart';
import 'package:miptv/features/provider/data/xtream_models.dart';
import 'package:miptv/features/provider/domain/iptv_provider_repository.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences key storing the id of the currently active source.
const _kActiveProviderIdKey = 'active_provider_id';

class XtreamProviderRepository implements IPTVProviderRepository {
  XtreamProviderRepository({
    required XtreamApi api,
    required SecureStorageService secureStorage,
    required IsarService isarService,
    required SharedPreferences prefs,
  })  : _api = api,
        _secureStorage = secureStorage,
        _isarService = isarService,
        _isar = isarService.db,
        _prefs = prefs;

  final XtreamApi _api;
  final SecureStorageService _secureStorage;
  final IsarService _isarService;
  final Isar _isar;
  final SharedPreferences _prefs;

  @override
  Future<ProviderEntity> addProvider({
    required String name,
    required String server,
    required String username,
    required String password,
  }) async {
    log.i('[Provider] Adding "$name" ($server)');
    await _api.authenticate(server: server, username: username, password: password);

    final model = ProviderModel()
      ..name = name
      ..server = server
      ..username = username;

    await _isar.writeTxn(() => _isar.providerModels.put(model));
    await _secureStorage.writePassword(model.id, password);

    // The newly added source becomes the active one: reset provider-scoped
    // caches so it starts from a clean slate instead of showing whatever the
    // previous source had synced/favorited.
    await _prefs.setInt(_kActiveProviderIdKey, model.id);
    await _isarService.resetProviderScopedData();

    log.i('[Provider] Saved provider id=${model.id}');
    return ProviderEntity(id: model.id, name: name, server: server, username: username);
  }

  @override
  Future<List<ProviderEntity>> getProviders() async {
    final models = await _isar.providerModels.where().findAll();
    return models.map(_toEntity).toList();
  }

  @override
  Future<ProviderEntity?> getProvider() async {
    final models = await _isar.providerModels.where().findAll();
    if (models.isEmpty) return null;

    final activeId = _prefs.getInt(_kActiveProviderIdKey);
    for (final model in models) {
      if (model.id == activeId) return _toEntity(model);
    }

    // No active id persisted yet, or it points at a since-deleted row: fall
    // back to the first source and persist that as the new active one.
    final fallback = models.first;
    await _prefs.setInt(_kActiveProviderIdKey, fallback.id);
    return _toEntity(fallback);
  }

  @override
  Future<void> switchProvider(int id) async {
    final exists = await _isar.providerModels.get(id) != null;
    if (!exists) return;
    log.i('[Provider] Switching active provider to id=$id');
    await _prefs.setInt(_kActiveProviderIdKey, id);
    await _isarService.resetProviderScopedData();
  }

  @override
  Future<void> removeProvider(int id) async {
    await _isar.writeTxn(() => _isar.providerModels.delete(id));
    await _secureStorage.deletePassword(id);
    log.i('[Provider] Removed provider id=$id');

    final activeId = _prefs.getInt(_kActiveProviderIdKey);
    if (activeId != id) return;

    // The active source was removed: activate another one (if any) and
    // reset caches so its content doesn't leak into the new active source.
    final remaining = await _isar.providerModels.where().findAll();
    if (remaining.isEmpty) {
      await _prefs.remove(_kActiveProviderIdKey);
    } else {
      await _prefs.setInt(_kActiveProviderIdKey, remaining.first.id);
    }
    await _isarService.resetProviderScopedData();
  }

  @override
  Future<List<CategoryEntity>> syncCategories() async {
    final provider = await getProvider();
    if (provider == null) return [];

    final password = await _secureStorage.readPassword(provider.id);
    if (password == null) return [];

    log.i('[Provider] syncCategories using server=${provider.server}');
    try {
      final rawCategories = await _api.getLiveCategories(
        server: provider.server,
        username: provider.username,
        password: password,
      );

      final models = await compute(_mapCategories, rawCategories);

      await _isar.writeTxn(() async {
        await _isar.categoryModels.putAll(models);
      });

      log.i('[Provider] Synced ${models.length} categories');
      return models
          .map((m) => CategoryEntity(id: m.categoryId, name: m.name))
          .toList();
    } on AppError catch (e) {
      final cached = await _isar.categoryModels.where().findAll();
      if (cached.isNotEmpty) {
        log.w('[Provider] Offline — serving ${cached.length} cached categories');
        return cached.map((m) => CategoryEntity(id: m.categoryId, name: m.name)).toList();
      }
      log.e('[Provider] Offline and no cached categories', error: e);
      rethrow;
    } catch (e, st) {
      // Cualquier fallo inesperado (parseo, isolate…) se normaliza a AppError
      // para que la UI muestre un mensaje útil en vez de un error crudo.
      log.e('[Provider] Unexpected error syncing categories', error: e, stackTrace: st);
      throw const ParseError();
    }
  }
}

ProviderEntity _toEntity(ProviderModel m) =>
    ProviderEntity(id: m.id, name: m.name, server: m.server, username: m.username);

List<CategoryModel> _mapCategories(List<XtreamCategory> raw) =>
    raw
        .map((c) => CategoryModel()
          ..categoryId = c.categoryId
          ..name = c.categoryName)
        .toList();
