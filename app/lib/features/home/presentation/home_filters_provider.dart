import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miptv/features/home/domain/home_filters.dart';

/// Holds the Home pill filter selection (in-memory; resets on app restart).
class HomeFiltersNotifier extends Notifier<HomeFilters> {
  @override
  HomeFilters build() => const HomeFilters();

  void setQuality(String? value) => state = state.copyWith(quality: value);

  void setCodec(String? value) => state = state.copyWith(codec: value);

  void setCategory(String? value) => state = state.copyWith(category: value);

  void setCountry(String? value) => state = state.copyWith(country: value);

  /// Sets the value for [type], or clears it when [value] is `null`.
  void setValue(HomeFilterType type, String? value) {
    switch (type) {
      case HomeFilterType.quality:
        setQuality(value);
      case HomeFilterType.codec:
        setCodec(value);
      case HomeFilterType.category:
        setCategory(value);
      case HomeFilterType.country:
        setCountry(value);
    }
  }

  void reset() => state = const HomeFilters();
}

final homeFiltersProvider =
    NotifierProvider<HomeFiltersNotifier, HomeFilters>(HomeFiltersNotifier.new);
