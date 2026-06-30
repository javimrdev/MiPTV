import 'package:miptv/features/home/domain/home_filters.dart';
import 'package:miptv/l10n/app_localizations.dart';

/// Localized display label for each [HomeFilterType]. Centralizes the mapping
/// so the Home filter bar and the custom-filters settings stay in sync.
extension HomeFilterTypeLabel on HomeFilterType {
  String label(AppLocalizations l10n) => switch (this) {
        HomeFilterType.quality => l10n.filterQuality,
        HomeFilterType.category => l10n.filterCategory,
        HomeFilterType.country => l10n.filterCountry,
      };
}
