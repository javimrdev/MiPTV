import 'package:isar_community/isar.dart';
import 'package:miptv/core/db/isar_service.dart';
import 'package:miptv/core/logging/app_logger.dart';
import 'package:miptv/features/home/data/custom_filter_model.dart';
import 'package:miptv/features/home/domain/custom_filter_repository.dart';
import 'package:miptv/features/home/domain/home_filters.dart';

class CustomFilterRepositoryImpl implements CustomFilterRepository {
  CustomFilterRepositoryImpl({required IsarService isarService})
      : _isar = isarService.db;

  final Isar _isar;

  @override
  Future<List<String>> getValues(HomeFilterType type) async {
    final models = await _isar.customFilterModels
        .filter()
        .typeEqualTo(type.name)
        .findAll();
    return models.map((m) => m.value).toList();
  }

  @override
  Future<void> add(HomeFilterType type, String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    await _isar.writeTxn(() async {
      await _isar.customFilterModels.put(
        CustomFilterModel()
          ..type = type.name
          ..value = trimmed,
      );
    });
    log.i('[Filters] Added custom ${type.name} filter "$trimmed"');
  }

  @override
  Future<void> remove(HomeFilterType type, String value) async {
    await _isar.writeTxn(() async {
      await _isar.customFilterModels
          .filter()
          .typeEqualTo(type.name)
          .valueEqualTo(value)
          .deleteAll();
    });
    log.i('[Filters] Removed custom ${type.name} filter "$value"');
  }
}
