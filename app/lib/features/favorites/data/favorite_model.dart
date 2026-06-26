import 'package:isar_community/isar.dart';

part 'favorite_model.g.dart';

@collection
class FavoriteModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int streamId;

  late DateTime createdAt;
}
