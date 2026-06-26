import 'package:isar_community/isar.dart';
import 'package:miptv/features/categories/data/category_model.dart';
import 'package:miptv/features/categories/data/category_sync_model.dart';
import 'package:miptv/features/favorites/data/favorite_model.dart';
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
      ],
      directory: dir.path,
    );
    _instance = IsarService._();
    _instance!._isar = isar;
    return _instance!;
  }
}
