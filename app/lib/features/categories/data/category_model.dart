import 'package:isar_community/isar.dart';

part 'category_model.g.dart';

@collection
class CategoryModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String categoryId;

  late String name;
}
