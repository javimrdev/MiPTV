import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/home/data/filters/country_filters.dart';
import 'package:miptv/features/home/domain/home_filters.dart';

/// Reverse lookup display name → ISO code, built once from
/// [kPopularIptvCountries] so the pill (which stores the display name, e.g.
/// "Spain") can be matched against the `{ISO}|` category-name prefix ("ES").
final Map<String, String> _kCountryNameToCode = {
  for (final e in kPopularIptvCountries.entries) e.value: e.key,
};

/// Applies the Home pill filters to the category list.
///
/// Currently only the `country` dimension matches against real data: IPTV
/// category names are prefixed with the country in `{ISO}| Name` form (e.g.
/// "ES| Deportes", sometimes "ES | Deportes"). `quality` and `category` stay
/// pass-through until that metadata is available.
List<CategoryEntity> applyHomeFilters(
  List<CategoryEntity> input,
  HomeFilters filters,
) {
  // TODO: apply kCategoryKeywords / quality once metadata exists.
  final country = filters.country;
  if (country == null) return input;

  // Predefined pills store the display name; custom values may already be a
  // code, so fall back to the raw value normalised.
  final code = (_kCountryNameToCode[country] ?? country).trim().toUpperCase();

  return input.where((c) => _matchesCountryPrefix(c.name, code)).toList();
}

/// Whether [name] starts with the `{code}|` prefix, trimming surrounding
/// spaces (handles "ES| X", "ES | X", " ES| X").
bool _matchesCountryPrefix(String name, String code) {
  final idx = name.indexOf('|');
  if (idx <= 0) return false;
  return name.substring(0, idx).trim().toUpperCase() == code;
}
