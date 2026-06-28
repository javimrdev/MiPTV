import 'package:miptv/features/streams/domain/stream_entity.dart';

abstract class StreamRepository {
  /// Returns streams for [categoryId]. Syncs from API on first visit.
  Future<List<StreamEntity>> getStreamsForCategory(String categoryId);

  /// Returns true if the category has been synced at least once.
  Future<bool> isCategorySynced(String categoryId);

  /// Hydrates streams by their [ids] from the local cache in a single query.
  /// Streams whose category was never synced won't be returned.
  Future<List<StreamEntity>> getStreamsByIds(List<int> ids);
}
