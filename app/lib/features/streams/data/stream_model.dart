import 'package:isar_community/isar.dart';

part 'stream_model.g.dart';

@collection
class StreamModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int streamId;

  late String name;

  @Index()
  late String categoryId;

  late String logo;

  late String extension;
  // full URL is NEVER stored — built dynamically from server + username + password + streamId + extension
}
