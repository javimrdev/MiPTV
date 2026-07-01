import 'package:isar_community/isar.dart';
import 'package:miptv/features/categories/data/category_model.dart';
import 'package:miptv/features/categories/data/category_sync_model.dart';
import 'package:miptv/features/favorites/data/favorite_category_model.dart';
import 'package:miptv/features/favorites/data/favorite_model.dart';
import 'package:miptv/features/home/data/custom_filter_model.dart';
import 'package:miptv/features/movies/data/vod_category_model.dart';
import 'package:miptv/features/movies/data/vod_stream_model.dart';
import 'package:miptv/features/movies/data/vod_sync_model.dart';
import 'package:miptv/features/provider/data/provider_model.dart';
import 'package:miptv/features/streams/data/stream_model.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  IsarService._();

  static IsarService? _instance;
  static IsarService get instance => _instance!;

  late Isar _isar;
  Isar get db => _isar;

  static Future<IsarService> init() async {
    if (_instance != null) return _instance!;
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        ProviderModelSchema,
        CategoryModelSchema,
        CategorySyncModelSchema,
        StreamModelSchema,
        FavoriteModelSchema,
        FavoriteCategoryModelSchema,
        VodCategoryModelSchema,
        VodStreamModelSchema,
        VodSyncModelSchema,
        CustomFilterModelSchema,
      ],
      directory: dir.path,
    );
    _instance = IsarService._();
    _instance!._isar = isar;
    return _instance!;
  }

  /// Clears every collection that is scoped to "whichever provider is
  /// active" — live categories/channels, VOD, favorites and custom filters —
  /// but leaves [ProviderModel] rows untouched. Called when the active
  /// provider changes (add, switch, remove) so the new source starts from a
  /// clean slate instead of showing another source's cached content or
  /// favorites pointing at the wrong streamId.
  Future<void> resetProviderScopedData() async {
    await _isar.writeTxn(() async {
      await _isar.categoryModels.clear();
      await _isar.categorySyncModels.clear();
      await _isar.streamModels.clear();
      await _isar.favoriteModels.clear();
      await _isar.favoriteCategoryModels.clear();
      await _isar.vodCategoryModels.clear();
      await _isar.vodStreamModels.clear();
      await _isar.vodSyncModels.clear();
      await _isar.customFilterModels.clear();
    });
  }
}
