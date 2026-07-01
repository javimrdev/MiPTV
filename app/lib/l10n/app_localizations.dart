import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// Bottom navigation label for the Home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation label for the Movies tab
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get navMovies;

  /// Bottom navigation label for the Favorites tab
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// Bottom navigation label for the Settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Generic retry button after an error
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Button/title to add an IPTV provider
  ///
  /// In en, this message translates to:
  /// **'Add provider'**
  String get addProvider;

  /// Generic fallback error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnexpected;

  /// Empty state when a search returns nothing
  ///
  /// In en, this message translates to:
  /// **'No results.'**
  String get noResults;

  /// Tooltip to add an item to favorites
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// Tooltip to remove an item from favorites
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @errorNetworkTimeout.
  ///
  /// In en, this message translates to:
  /// **'The connection took too long. Please try again.'**
  String get errorNetworkTimeout;

  /// No description provided for @errorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network.'**
  String get errorNoConnection;

  /// No description provided for @errorInvalidServerUrl.
  ///
  /// In en, this message translates to:
  /// **'The server URL doesn\'t exist. Make sure it\'s spelled correctly.'**
  String get errorInvalidServerUrl;

  /// No description provided for @errorBadCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password.'**
  String get errorBadCredentials;

  /// No description provided for @errorParse.
  ///
  /// In en, this message translates to:
  /// **'The server response is invalid. Please try again.'**
  String get errorParse;

  /// No description provided for @errorInvalidStream.
  ///
  /// In en, this message translates to:
  /// **'This channel is not available right now.'**
  String get errorInvalidStream;

  /// Player error including the underlying message
  ///
  /// In en, this message translates to:
  /// **'Playback error: {message}'**
  String errorPlayer(String message);

  /// Unknown error including the underlying message
  ///
  /// In en, this message translates to:
  /// **'Unexpected error: {message}'**
  String errorUnknown(String message);

  /// No description provided for @homeNoProvider.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any IPTV provider yet.'**
  String get homeNoProvider;

  /// No description provided for @searchCategoriesHint.
  ///
  /// In en, this message translates to:
  /// **'Search categories…'**
  String get searchCategoriesHint;

  /// No description provided for @filterQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get filterQuality;

  /// No description provided for @filterCodec.
  ///
  /// In en, this message translates to:
  /// **'Codec'**
  String get filterCodec;

  /// No description provided for @filterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filterCategory;

  /// No description provided for @filterCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get filterCountry;

  /// No description provided for @filtersClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get filtersClear;

  /// No description provided for @filterOptionsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the options.'**
  String get filterOptionsLoadError;

  /// A filter pill showing the selected value, e.g. 'Quality: HD'
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String filterPill(String label, String value);

  /// No description provided for @channels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get channels;

  /// No description provided for @viewModeList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get viewModeList;

  /// No description provided for @viewModeGuide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get viewModeGuide;

  /// No description provided for @epgLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading guide…'**
  String get epgLoading;

  /// No description provided for @epgUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No guide available'**
  String get epgUnavailable;

  /// No description provided for @epgNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get epgNow;

  /// No description provided for @epgNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get epgNext;

  /// A single EPG program line: now/next label, time range and program title
  ///
  /// In en, this message translates to:
  /// **'{label} · {range} · {title}'**
  String epgProgramLine(String label, String range, String title);

  /// No description provided for @movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// No description provided for @searchMoviesHint.
  ///
  /// In en, this message translates to:
  /// **'Search movies…'**
  String get searchMoviesHint;

  /// No description provided for @moviesNoProvider.
  ///
  /// In en, this message translates to:
  /// **'Add an IPTV provider to watch movies.'**
  String get moviesNoProvider;

  /// No description provided for @movieCategoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No movies in this category.'**
  String get movieCategoryEmpty;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no favorites'**
  String get favoritesEmpty;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @favoritesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load favorites.'**
  String get favoritesLoadError;

  /// Fallback channel name when the stream name is unknown
  ///
  /// In en, this message translates to:
  /// **'Channel {streamId}'**
  String channelFallbackName(int streamId);

  /// No description provided for @playerNoProvider.
  ///
  /// In en, this message translates to:
  /// **'No provider configured.'**
  String get playerNoProvider;

  /// No description provided for @playerNoPassword.
  ///
  /// In en, this message translates to:
  /// **'Password not found.'**
  String get playerNoPassword;

  /// No description provided for @playerError.
  ///
  /// In en, this message translates to:
  /// **'Error playing the channel.'**
  String get playerError;

  /// No description provided for @serverUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrlLabel;

  /// No description provided for @serverUrlValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter the server URL'**
  String get serverUrlValidation;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @usernameValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter the username'**
  String get usernameValidation;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter the password'**
  String get passwordValidation;

  /// No description provided for @nativeDiagnostic.
  ///
  /// In en, this message translates to:
  /// **'Native diagnostic (dart:io)'**
  String get nativeDiagnostic;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get sectionProvider;

  /// No description provided for @sectionFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get sectionFilters;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @sectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get sectionInfo;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @customFilters.
  ///
  /// In en, this message translates to:
  /// **'Custom filters'**
  String get customFilters;

  /// App version line shown in Settings
  ///
  /// In en, this message translates to:
  /// **'Version {version} — MVP v0.1'**
  String appVersion(String version);

  /// No description provided for @syncCategoriesSuccess.
  ///
  /// In en, this message translates to:
  /// **'Categories synced'**
  String get syncCategoriesSuccess;

  /// No description provided for @syncCategoriesError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sync'**
  String get syncCategoriesError;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @addFilterHint.
  ///
  /// In en, this message translates to:
  /// **'Add filter…'**
  String get addFilterHint;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noCustomFilters.
  ///
  /// In en, this message translates to:
  /// **'No custom filters.'**
  String get noCustomFilters;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @filtersLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load filters.'**
  String get filtersLoadError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
