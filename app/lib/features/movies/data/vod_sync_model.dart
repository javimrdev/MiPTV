import 'package:isar_community/isar.dart';

part 'vod_sync_model.g.dart';

/// Single marker row tracking the one-shot full VOD catalogue sync.
@collection
class VodSyncModel {
  Id id = Isar.autoIncrement;

  DateTime? lastSync;

  bool isSyncing = false;
}
