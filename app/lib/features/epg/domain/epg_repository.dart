import 'package:miptv/features/epg/domain/epg_entity.dart';

abstract class EpgRepository {
  /// Returns the *now/next* programs for a live [streamId].
  ///
  /// Never throws: when the panel serves no EPG or the request fails, returns an
  /// empty [ChannelEpg] (both `now` and `next` are `null`).
  Future<ChannelEpg> getNowNext(int streamId);
}
