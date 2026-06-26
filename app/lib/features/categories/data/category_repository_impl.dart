import 'package:isar_community/isar.dart';
import 'package:miptv/core/db/isar_service.dart';
import 'package:miptv/core/logging/app_logger.dart';
import 'package:miptv/features/categories/data/category_model.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/categories/domain/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({required IsarService isarService})
      : _isar = isarService.db;

  final Isar _isar;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final models = await _isar.categoryModels.where().findAll();
    log.i('[Categories] Loaded ${models.length} categories from Isar');
    return models.map((m) => CategoryEntity(id: m.categoryId, name: m.name)).toList();
  }
}
