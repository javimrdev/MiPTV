import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/home/domain/home_filters.dart';

/// Applies the Home pill filters to the category list.
///
/// MOCK: currently a pass-through that returns the input list unchanged. The
/// real matching (quality/country metadata, and `kCategoryKeywords` for the
/// category dimension) is wired here later once that metadata is available.
List<CategoryEntity> applyHomeFilters(
  List<CategoryEntity> input,
  HomeFilters filters,
) {
  // TODO: apply kCategoryKeywords / quality / country once metadata exists.
  return input;
}
