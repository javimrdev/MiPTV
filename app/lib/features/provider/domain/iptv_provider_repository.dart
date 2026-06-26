import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';

abstract class IPTVProviderRepository {
  Future<ProviderEntity> addProvider({
    required String server,
    required String username,
    required String password,
  });

  Future<ProviderEntity?> getProvider();

  Future<void> removeProvider();

  Future<List<CategoryEntity>> syncCategories();
}
