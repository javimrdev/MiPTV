import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/home/data/filters/country_filters.dart';
import 'package:miptv/features/home/domain/home_filters.dart';

/// Reverse lookup display name → ISO code, built once from
/// [kPopularIptvCountries] so the pill (which stores the display name, e.g.
/// "Spain") can be matched against the `{ISO}|` category-name prefix ("ES").
final Map<String, String> _kCountryNameToCode = {
  for (final e in kPopularIptvCountries.entries) e.value: e.key,
};

/// Known alias patterns for the predefined quality pill values. IPTV category
/// names have no structured quality field, so this matches whole-word tags
/// (and common synonyms) inside the free-text name, e.g. "Movies 4K" or
/// "Sports UHD" both match the "4K" filter.
const Map<String, List<String>> _kQualityAliasPatterns = {
  'SD': [r'\bSD\b'],
  'HD': [r'\bHD\b'],
  'Full HD': [r'\bFHD\b', r'\bFULL\s*HD\b', r'\b1080P?\b'],
  '4K': [r'\b4K\b', r'\bUHD\b', r'\b2160P?\b'],
  '8K': [r'\b8K\b', r'\b4320P?\b'],
};

/// Known alias patterns for the predefined codec pill values.
const Map<String, List<String>> _kCodecAliasPatterns = {
  'HEVC': [r'\bHEVC\b', r'\bH\.?265\b'],
  'AV1': [r'\bAV1\b'],
};

/// Applies the Home pill filters to the category list.
///
/// `country` matches the `{ISO}|` category-name prefix (e.g. "ES| Deportes",
/// sometimes "ES | Deportes"). `quality` and `codec` have no structured field
/// either, so they match known tag aliases (or the raw value, for custom
/// entries) as a whole word anywhere in the category name. `category` stays
/// pass-through until keyword metadata exists for it.
List<CategoryEntity> applyHomeFilters(
  List<CategoryEntity> input,
  HomeFilters filters,
) {
  // TODO: apply kCategoryKeywords once metadata exists.
  var result = input;

  final country = filters.country;
  if (country != null) {
    // Predefined pills store the display name; custom values may already be
    // a code, so fall back to the raw value normalised.
    final code = (_kCountryNameToCode[country] ?? country).trim().toUpperCase();
    result = result.where((c) => _matchesCountryPrefix(c.name, code)).toList();
  }

  final quality = filters.quality;
  if (quality != null) {
    result = result
        .where((c) => _matchesKeyword(c.name, quality, _kQualityAliasPatterns))
        .toList();
  }

  final codec = filters.codec;
  if (codec != null) {
    result = result
        .where((c) => _matchesKeyword(c.name, codec, _kCodecAliasPatterns))
        .toList();
  }

  return result;
}

/// Whether [name] starts with the `{code}|` prefix, trimming surrounding
/// spaces (handles "ES| X", "ES | X", " ES| X").
bool _matchesCountryPrefix(String name, String code) {
  final idx = name.indexOf('|');
  if (idx <= 0) return false;
  return name.substring(0, idx).trim().toUpperCase() == code;
}

/// Whether [name] contains, as a whole word, one of the alias patterns for
/// [value] in [aliasPatterns] — or, for custom (non-predefined) values, the
/// value itself as a whole word.
bool _matchesKeyword(
  String name,
  String value,
  Map<String, List<String>> aliasPatterns,
) {
  final patterns =
      aliasPatterns[value] ?? [r'\b' + RegExp.escape(value.toUpperCase()) + r'\b'];
  return patterns.any(
    (p) => RegExp(p, caseSensitive: false).hasMatch(name),
  );
}
