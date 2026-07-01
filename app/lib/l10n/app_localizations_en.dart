// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navMovies => 'Movies';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navSettings => 'Settings';

  @override
  String get retry => 'Retry';

  @override
  String get addProvider => 'Add provider';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get noResults => 'No results.';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get errorNetworkTimeout =>
      'The connection took too long. Please try again.';

  @override
  String get errorNoConnection => 'No internet connection. Check your network.';

  @override
  String get errorInvalidServerUrl =>
      'The server URL doesn\'t exist. Make sure it\'s spelled correctly.';

  @override
  String get errorBadCredentials => 'Incorrect username or password.';

  @override
  String get errorParse => 'The server response is invalid. Please try again.';

  @override
  String get errorInvalidStream => 'This channel is not available right now.';

  @override
  String errorPlayer(String message) {
    return 'Playback error: $message';
  }

  @override
  String errorUnknown(String message) {
    return 'Unexpected error: $message';
  }

  @override
  String get homeNoProvider => 'You haven\'t added any IPTV provider yet.';

  @override
  String get searchCategoriesHint => 'Search categories…';

  @override
  String get filterQuality => 'Quality';

  @override
  String get filterCodec => 'Codec';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterCountry => 'Country';

  @override
  String get filtersClear => 'Clear';

  @override
  String get filterOptionsLoadError => 'Couldn\'t load the options.';

  @override
  String filterPill(String label, String value) {
    return '$label: $value';
  }

  @override
  String get channels => 'Channels';

  @override
  String get viewModeList => 'List';

  @override
  String get viewModeGuide => 'Guide';

  @override
  String get epgLoading => 'Loading guide…';

  @override
  String get epgUnavailable => 'No guide available';

  @override
  String get epgNow => 'Now';

  @override
  String get epgNext => 'Next';

  @override
  String epgProgramLine(String label, String range, String title) {
    return '$label · $range · $title';
  }

  @override
  String get movies => 'Movies';

  @override
  String get searchMoviesHint => 'Search movies…';

  @override
  String get moviesNoProvider => 'Add an IPTV provider to watch movies.';

  @override
  String get movieCategoryEmpty => 'No movies in this category.';

  @override
  String get favorites => 'Favorites';

  @override
  String get favoritesEmpty => 'You have no favorites';

  @override
  String get categories => 'Categories';

  @override
  String get favoritesLoadError => 'Couldn\'t load favorites.';

  @override
  String channelFallbackName(int streamId) {
    return 'Channel $streamId';
  }

  @override
  String get playerNoProvider => 'No provider configured.';

  @override
  String get playerNoPassword => 'Password not found.';

  @override
  String get playerError => 'Error playing the channel.';

  @override
  String get serverUrlLabel => 'Server URL';

  @override
  String get serverUrlValidation => 'Enter the server URL';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameValidation => 'Enter the username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordValidation => 'Enter the password';

  @override
  String get nativeDiagnostic => 'Native diagnostic (dart:io)';

  @override
  String get connect => 'Connect';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionProvider => 'Provider';

  @override
  String get sectionFilters => 'Filters';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionInfo => 'Information';

  @override
  String get loading => 'Loading…';

  @override
  String get customFilters => 'Custom filters';

  @override
  String appVersion(String version) {
    return 'Version $version — MVP v0.1';
  }

  @override
  String get syncCategoriesSuccess => 'Categories synced';

  @override
  String get syncCategoriesError => 'Couldn\'t sync';

  @override
  String get sync => 'Sync';

  @override
  String get remove => 'Remove';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get addFilterHint => 'Add filter…';

  @override
  String get add => 'Add';

  @override
  String get noCustomFilters => 'No custom filters.';

  @override
  String get delete => 'Delete';

  @override
  String get filtersLoadError => 'Couldn\'t load filters.';
}
