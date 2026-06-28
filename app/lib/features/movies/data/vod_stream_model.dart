import 'package:isar_community/isar.dart';

part 'vod_stream_model.g.dart';

@collection
class VodStreamModel {
  Id id = Isar.autoIncrement;

  // NOT unique: VOD stream_ids may numerically collide with live stream_ids,
  // and VOD lives in its own collection so no constraint is needed.
  late int streamId;

  // Indexed (case-insensitive) to back the global movie search.
  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  @Index()
  late String categoryId;

  late String logo;

  late String extension;
  // full URL is NEVER stored — built dynamically via buildStreamUrl(type: 'movie')
}
