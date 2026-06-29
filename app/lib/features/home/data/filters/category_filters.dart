/// Predefined category filter options shown in the Home "Category" pill.
const List<String> kCategoryFilters = [
  'Sport',
  'Futbol',
  'Kids',
  'Movies',
  'News',
  'Documentary',
];

/// Keyword dictionary per category option, used to match items when filtering.
///
/// Empty for now — the matching logic is mocked (see `applyHomeFilters`).
/// Fill each list with the keywords that should match a given category once
/// real stream/category metadata is available.
const Map<String, List<String>> kCategoryKeywords = {
  'Sport': [],
  'Futbol': [],
  'Kids': [],
  'Movies': [],
  'News': [],
  'Documentary': [],
};
