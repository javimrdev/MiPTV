import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';

abstract class IPTVProviderRepository {
  Future<ProviderEntity> addProvider({
    required String name,
    required String server,
    required String username,
    required String password,
  });

  /// All configured sources, in the order they were added.
  Future<List<ProviderEntity>> getProviders();

  /// The active source (used for every playback/sync request). `null` when
  /// none is configured.
  Future<ProviderEntity?> getProvider();

  /// Makes [id] the active source and resets provider-scoped caches
  /// (categories/channels/VOD/favorites/custom filters) so the new source
  /// starts from a clean slate.
  Future<void> switchProvider(int id);

  Future<void> removeProvider(int id);

  Future<List<CategoryEntity>> syncCategories();
}
