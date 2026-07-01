// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navHome => 'Start';

  @override
  String get navMovies => 'Filme';

  @override
  String get navFavorites => 'Favoriten';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get addProvider => 'Anbieter hinzufügen';

  @override
  String get errorUnexpected =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get noResults => 'Keine Ergebnisse.';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get errorNetworkTimeout =>
      'Die Verbindung hat zu lange gedauert. Bitte versuche es erneut.';

  @override
  String get errorNoConnection =>
      'Keine Internetverbindung. Überprüfe dein Netzwerk.';

  @override
  String get errorInvalidServerUrl =>
      'Die Server-URL existiert nicht. Überprüfe die Schreibweise.';

  @override
  String get errorBadCredentials => 'Benutzername oder Passwort falsch.';

  @override
  String get errorParse =>
      'Die Serverantwort ist ungültig. Bitte versuche es erneut.';

  @override
  String get errorInvalidStream => 'Dieser Sender ist derzeit nicht verfügbar.';

  @override
  String errorPlayer(String message) {
    return 'Wiedergabefehler: $message';
  }

  @override
  String errorUnknown(String message) {
    return 'Unerwarteter Fehler: $message';
  }

  @override
  String get homeNoProvider => 'Du hast noch keinen IPTV-Anbieter hinzugefügt.';

  @override
  String get searchCategoriesHint => 'Kategorien suchen…';

  @override
  String get filterQuality => 'Qualität';

  @override
  String get filterCodec => 'Codec';

  @override
  String get filterCategory => 'Kategorie';

  @override
  String get filterCountry => 'Land';

  @override
  String get filtersClear => 'Löschen';

  @override
  String get filterOptionsLoadError => 'Optionen konnten nicht geladen werden.';

  @override
  String filterPill(String label, String value) {
    return '$label: $value';
  }

  @override
  String get channels => 'Sender';

  @override
  String get viewModeList => 'Liste';

  @override
  String get viewModeGuide => 'Programm';

  @override
  String get epgLoading => 'Programm wird geladen…';

  @override
  String get epgUnavailable => 'Kein Programm verfügbar';

  @override
  String get epgNow => 'Jetzt';

  @override
  String get epgNext => 'Danach';

  @override
  String epgProgramLine(String label, String range, String title) {
    return '$label · $range · $title';
  }

  @override
  String get movies => 'Filme';

  @override
  String get searchMoviesHint => 'Filme suchen…';

  @override
  String get moviesNoProvider =>
      'Füge einen IPTV-Anbieter hinzu, um Filme anzusehen.';

  @override
  String get movieCategoryEmpty => 'Keine Filme in dieser Kategorie.';

  @override
  String get favorites => 'Favoriten';

  @override
  String get favoritesEmpty => 'Du hast keine Favoriten';

  @override
  String get categories => 'Kategorien';

  @override
  String get favoritesLoadError => 'Favoriten konnten nicht geladen werden.';

  @override
  String channelFallbackName(int streamId) {
    return 'Sender $streamId';
  }

  @override
  String get playerNoProvider => 'Kein Anbieter konfiguriert.';

  @override
  String get playerNoPassword => 'Passwort nicht gefunden.';

  @override
  String get playerError => 'Fehler beim Abspielen des Senders.';

  @override
  String get serverUrlLabel => 'Server-URL';

  @override
  String get serverUrlValidation => 'Gib die Server-URL ein';

  @override
  String get usernameLabel => 'Benutzername';

  @override
  String get usernameValidation => 'Gib den Benutzernamen ein';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get passwordValidation => 'Gib das Passwort ein';

  @override
  String get nativeDiagnostic => 'Native Diagnose (dart:io)';

  @override
  String get connect => 'Verbinden';

  @override
  String get settingsTitle => 'Konfiguration';

  @override
  String get sectionProvider => 'Anbieter';

  @override
  String get sectionFilters => 'Filter';

  @override
  String get sectionAppearance => 'Darstellung';

  @override
  String get sectionInfo => 'Informationen';

  @override
  String get loading => 'Wird geladen…';

  @override
  String get customFilters => 'Benutzerdefinierte Filter';

  @override
  String appVersion(String version) {
    return 'Version $version — MVP v0.1';
  }

  @override
  String get syncCategoriesSuccess => 'Kategorien synchronisiert';

  @override
  String get syncCategoriesError => 'Synchronisierung fehlgeschlagen';

  @override
  String get sync => 'Synchronisieren';

  @override
  String get remove => 'Entfernen';

  @override
  String get theme => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Systemsprache';

  @override
  String get addFilterHint => 'Filter hinzufügen…';

  @override
  String get add => 'Hinzufügen';

  @override
  String get noCustomFilters => 'Keine benutzerdefinierten Filter.';

  @override
  String get delete => 'Löschen';

  @override
  String get filtersLoadError => 'Filter konnten nicht geladen werden.';
}
