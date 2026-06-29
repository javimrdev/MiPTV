import 'package:miptv/features/home/domain/home_filters.dart';

/// Persists user-added filter values per [HomeFilterType].
abstract class CustomFilterRepository {
  /// Manually-added values for [type], in insertion order.
  Future<List<String>> getValues(HomeFilterType type);

  /// Adds [value] to [type]. No-op if it already exists (composite-unique).
  Future<void> add(HomeFilterType type, String value);

  /// Removes [value] from [type].
  Future<void> remove(HomeFilterType type, String value);
}
