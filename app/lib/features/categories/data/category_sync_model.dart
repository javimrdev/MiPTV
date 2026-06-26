import 'package:isar_community/isar.dart';

part 'category_sync_model.g.dart';

@collection
class CategorySyncModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String categoryId;

  late DateTime lastSync;

  late bool isSyncing;

  late int streamCount;
}
