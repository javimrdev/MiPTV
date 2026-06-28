import 'package:isar_community/isar.dart';

part 'vod_category_model.g.dart';

@collection
class VodCategoryModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String categoryId;

  late String name;
}
