// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navMovies => 'Film';

  @override
  String get navFavorites => 'Preferiti';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get retry => 'Riprova';

  @override
  String get addProvider => 'Aggiungi provider';

  @override
  String get errorUnexpected => 'Qualcosa è andato storto. Riprova.';

  @override
  String get noResults => 'Nessun risultato.';

  @override
  String get addToFavorites => 'Aggiungi ai preferiti';

  @override
  String get removeFromFavorites => 'Rimuovi dai preferiti';

  @override
  String get errorNetworkTimeout =>
      'La connessione ha impiegato troppo tempo. Riprova.';

  @override
  String get errorNoConnection =>
      'Nessuna connessione a internet. Controlla la rete.';

  @override
  String get errorInvalidServerUrl =>
      'L\'URL del server non esiste. Verifica che sia scritto correttamente.';

  @override
  String get errorBadCredentials => 'Nome utente o password errati.';

  @override
  String get errorParse => 'La risposta del server non è valida. Riprova.';

  @override
  String get errorInvalidStream =>
      'Questo canale non è disponibile al momento.';

  @override
  String errorPlayer(String message) {
    return 'Errore di riproduzione: $message';
  }

  @override
  String errorUnknown(String message) {
    return 'Errore imprevisto: $message';
  }

  @override
  String get homeNoProvider => 'Non hai ancora aggiunto alcun provider IPTV.';

  @override
  String get searchCategoriesHint => 'Cerca categorie…';

  @override
  String get filterQuality => 'Qualità';

  @override
  String get filterCodec => 'Codec';

  @override
  String get filterCategory => 'Categoria';

  @override
  String get filterCountry => 'Paese';

  @override
  String get filtersClear => 'Cancella';

  @override
  String get filterOptionsLoadError => 'Impossibile caricare le opzioni.';

  @override
  String filterPill(String label, String value) {
    return '$label: $value';
  }

  @override
  String get channels => 'Canali';

  @override
  String get viewModeList => 'Elenco';

  @override
  String get viewModeGuide => 'Guida';

  @override
  String get epgLoading => 'Caricamento guida…';

  @override
  String get epgUnavailable => 'Nessuna guida disponibile';

  @override
  String get epgNow => 'Ora';

  @override
  String get epgNext => 'Dopo';

  @override
  String epgProgramLine(String label, String range, String title) {
    return '$label · $range · $title';
  }

  @override
  String get movies => 'Film';

  @override
  String get searchMoviesHint => 'Cerca film…';

  @override
  String get moviesNoProvider =>
      'Aggiungi un provider IPTV per guardare i film.';

  @override
  String get movieCategoryEmpty => 'Nessun film in questa categoria.';

  @override
  String get favorites => 'Preferiti';

  @override
  String get favoritesEmpty => 'Non hai preferiti';

  @override
  String get categories => 'Categorie';

  @override
  String get favoritesLoadError => 'Impossibile caricare i preferiti.';

  @override
  String channelFallbackName(int streamId) {
    return 'Canale $streamId';
  }

  @override
  String get playerNoProvider => 'Nessun provider configurato.';

  @override
  String get playerNoPassword => 'Password non trovata.';

  @override
  String get playerError => 'Errore durante la riproduzione del canale.';

  @override
  String get playerTimeout =>
      'Lo stream ha impiegato troppo tempo per avviarsi.';

  @override
  String get serverUrlLabel => 'URL del server';

  @override
  String get serverUrlValidation => 'Inserisci l\'URL del server';

  @override
  String get usernameLabel => 'Nome utente';

  @override
  String get usernameValidation => 'Inserisci il nome utente';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordValidation => 'Inserisci la password';

  @override
  String get nativeDiagnostic => 'Diagnostica nativa (dart:io)';

  @override
  String get connect => 'Connetti';

  @override
  String get settingsTitle => 'Configurazione';

  @override
  String get sectionProvider => 'Provider';

  @override
  String get sectionFilters => 'Filtri';

  @override
  String get sectionAppearance => 'Aspetto';

  @override
  String get sectionInfo => 'Informazioni';

  @override
  String get loading => 'Caricamento…';

  @override
  String get customFilters => 'Filtri personalizzati';

  @override
  String appVersion(String version) {
    return 'Versione $version — MVP v0.1';
  }

  @override
  String get syncCategoriesSuccess => 'Categorie sincronizzate';

  @override
  String get syncCategoriesError => 'Impossibile sincronizzare';

  @override
  String get sync => 'Sincronizza';

  @override
  String get remove => 'Rimuovi';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get language => 'Lingua';

  @override
  String get languageSystem => 'Lingua di sistema';

  @override
  String get addFilterHint => 'Aggiungi filtro…';

  @override
  String get add => 'Aggiungi';

  @override
  String get noCustomFilters => 'Nessun filtro personalizzato.';

  @override
  String get delete => 'Elimina';

  @override
  String get filtersLoadError => 'Impossibile caricare i filtri.';
}
