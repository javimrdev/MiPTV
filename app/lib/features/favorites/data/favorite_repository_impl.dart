import 'package:isar_community/isar.dart';
import 'package:miptv/core/db/isar_service.dart';
import 'package:miptv/core/logging/app_logger.dart';
import 'package:miptv/features/favorites/data/favorite_model.dart';
import 'package:miptv/features/favorites/domain/favorite_entity.dart';
import 'package:miptv/features/favorites/domain/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl({required IsarService isarService})
      : _isar = isarService.db;

  final Isar _isar;

  @override
  Future<List<FavoriteEntity>> getFavorites() async {
    final models = await _isar.favoriteModels.where().findAll();
    return models
        .map((m) => FavoriteEntity(streamId: m.streamId, createdAt: m.createdAt))
        .toList();
  }

  @override
  Future<void> addFavorite(int streamId) async {
    log.i('[Favorites] addFavorite streamId=$streamId');
    final model = FavoriteModel()
      ..streamId = streamId
      ..createdAt = DateTime.now();
    await _isar.writeTxn(() => _isar.favoriteModels.put(model));
  }

  @override
  Future<void> removeFavorite(int streamId) async {
    log.i('[Favorites] removeFavorite streamId=$streamId');
    await _isar.writeTxn(() async {
      await _isar.favoriteModels.where().streamIdEqualTo(streamId).deleteAll();
    });
  }

  @override
  Future<bool> isFavorite(int streamId) async {
    final model =
        await _isar.favoriteModels.where().streamIdEqualTo(streamId).findFirst();
    return model != null;
  }
}
