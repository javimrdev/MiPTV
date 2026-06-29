import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_filters.freezed.dart';

/// The three filter dimensions offered as pills on the Home screen.
enum HomeFilterType { quality, category, country }

/// Currently selected Home filters. Single value per dimension (`null` = none).
@freezed
abstract class HomeFilters with _$HomeFilters {
  const factory HomeFilters({
    String? quality,
    String? category,
    String? country,
  }) = _HomeFilters;

  const HomeFilters._();

  /// Whether at least one dimension is selected (controls the reset pill).
  bool get hasAny => quality != null || category != null || country != null;

  /// The selected value for [type], or `null` if that dimension is unset.
  String? valueOf(HomeFilterType type) => switch (type) {
        HomeFilterType.quality => quality,
        HomeFilterType.category => category,
        HomeFilterType.country => country,
      };
}
