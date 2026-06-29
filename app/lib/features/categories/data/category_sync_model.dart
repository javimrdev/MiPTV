import 'package:isar_community/isar.dart';

part 'category_sync_model.g.dart';

@collection
class CategorySyncModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String categoryId;

  DateTime? lastSync;

  bool isSyncing = false;

  int streamCount = 0;
}
