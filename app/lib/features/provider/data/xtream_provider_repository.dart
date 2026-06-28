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

class XtreamProviderRepository implements IPTVProviderRepository {
  XtreamProviderRepository({
    required XtreamApi api,
    required SecureStorageService secureStorage,
    required IsarService isarService,
  })  : _api = api,
        _secureStorage = secureStorage,
        _isar = isarService.db;

  final XtreamApi _api;
  final SecureStorageService _secureStorage;
  final Isar _isar;

  @override
  Future<ProviderEntity> addProvider({
    required String server,
    required String username,
    required String password,
  }) async {
    log.i('[Provider] Adding $server');
    await _api.authenticate(server: server, username: username, password: password);

    final model = ProviderModel()
      ..server = server
      ..username = username;

    await _isar.writeTxn(() async {
      await _isar.providerModels.clear();
      await _isar.providerModels.put(model);
    });

    await _secureStorage.writePassword(password);

    log.i('[Provider] Saved provider id=${model.id}');
    return ProviderEntity(id: model.id, server: server, username: username);
  }

  @override
  Future<ProviderEntity?> getProvider() async {
    final model = await _isar.providerModels.where().findFirst();
    if (model == null) return null;
    return ProviderEntity(id: model.id, server: model.server, username: model.username);
  }

  @override
  Future<void> removeProvider() async {
    await _isar.writeTxn(() async {
      await _isar.providerModels.clear();
    });
    await _secureStorage.deletePassword();
    log.i('[Provider] Removed provider');
  }

  @override
  Future<List<CategoryEntity>> syncCategories() async {
    final provider = await getProvider();
    if (provider == null) return [];

    final password = await _secureStorage.readPassword();
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

List<CategoryModel> _mapCategories(List<XtreamCategory> raw) =>
    raw
        .map((c) => CategoryModel()
          ..categoryId = c.categoryId
          ..name = c.categoryName)
        .toList();
