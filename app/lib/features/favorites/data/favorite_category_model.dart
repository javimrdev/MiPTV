import 'package:isar_community/isar.dart';

part 'favorite_category_model.g.dart';

@collection
class FavoriteCategoryModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String categoryId;

  late String name;

  late DateTime createdAt;
}
