// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navHome => 'Accueil';

  @override
  String get navMovies => 'Films';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get navSettings => 'Réglages';

  @override
  String get retry => 'Réessayer';

  @override
  String get addProvider => 'Ajouter un fournisseur';

  @override
  String get errorUnexpected => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get noResults => 'Aucun résultat.';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get errorNetworkTimeout =>
      'La connexion a pris trop de temps. Veuillez réessayer.';

  @override
  String get errorNoConnection =>
      'Pas de connexion internet. Vérifiez votre réseau.';

  @override
  String get errorInvalidServerUrl =>
      'L\'URL du serveur n\'existe pas. Vérifiez qu\'elle est correctement saisie.';

  @override
  String get errorBadCredentials =>
      'Nom d\'utilisateur ou mot de passe incorrect.';

  @override
  String get errorParse =>
      'La réponse du serveur est invalide. Veuillez réessayer.';

  @override
  String get errorInvalidStream =>
      'Cette chaîne n\'est pas disponible pour le moment.';

  @override
  String errorPlayer(String message) {
    return 'Erreur de lecture : $message';
  }

  @override
  String errorUnknown(String message) {
    return 'Erreur inattendue : $message';
  }

  @override
  String get homeNoProvider =>
      'Vous n\'avez pas encore ajouté de fournisseur IPTV.';

  @override
  String get searchCategoriesHint => 'Rechercher des catégories…';

  @override
  String get filterQuality => 'Qualité';

  @override
  String get filterCodec => 'Codec';

  @override
  String get filterCategory => 'Catégorie';

  @override
  String get filterCountry => 'Pays';

  @override
  String get filtersClear => 'Effacer';

  @override
  String get filterOptionsLoadError => 'Impossible de charger les options.';

  @override
  String filterPill(String label, String value) {
    return '$label : $value';
  }

  @override
  String get channels => 'Chaînes';

  @override
  String get viewModeList => 'Liste';

  @override
  String get viewModeGuide => 'Guide';

  @override
  String get epgLoading => 'Chargement du guide…';

  @override
  String get epgUnavailable => 'Aucun guide disponible';

  @override
  String get epgNow => 'Maintenant';

  @override
  String get epgNext => 'Ensuite';

  @override
  String epgProgramLine(String label, String range, String title) {
    return '$label · $range · $title';
  }

  @override
  String get movies => 'Films';

  @override
  String get searchMoviesHint => 'Rechercher des films…';

  @override
  String get moviesNoProvider =>
      'Ajoutez un fournisseur IPTV pour regarder des films.';

  @override
  String get movieCategoryEmpty => 'Aucun film dans cette catégorie.';

  @override
  String get favorites => 'Favoris';

  @override
  String get favoritesEmpty => 'Vous n\'avez aucun favori';

  @override
  String get categories => 'Catégories';

  @override
  String get favoritesLoadError => 'Impossible de charger les favoris.';

  @override
  String channelFallbackName(int streamId) {
    return 'Chaîne $streamId';
  }

  @override
  String get playerNoProvider => 'Aucun fournisseur configuré.';

  @override
  String get playerNoPassword => 'Mot de passe introuvable.';

  @override
  String get playerError => 'Erreur lors de la lecture de la chaîne.';

  @override
  String get serverUrlLabel => 'URL du serveur';

  @override
  String get serverUrlValidation => 'Saisissez l\'URL du serveur';

  @override
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get usernameValidation => 'Saisissez le nom d\'utilisateur';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordValidation => 'Saisissez le mot de passe';

  @override
  String get nativeDiagnostic => 'Diagnostic natif (dart:io)';

  @override
  String get connect => 'Connecter';

  @override
  String get settingsTitle => 'Configuration';

  @override
  String get sectionProvider => 'Fournisseur';

  @override
  String get sectionFilters => 'Filtres';

  @override
  String get sectionAppearance => 'Apparence';

  @override
  String get sectionInfo => 'Informations';

  @override
  String get loading => 'Chargement…';

  @override
  String get customFilters => 'Filtres personnalisés';

  @override
  String appVersion(String version) {
    return 'Version $version — MVP v0.1';
  }

  @override
  String get syncCategoriesSuccess => 'Catégories synchronisées';

  @override
  String get syncCategoriesError => 'Échec de la synchronisation';

  @override
  String get sync => 'Synchroniser';

  @override
  String get remove => 'Supprimer';

  @override
  String get theme => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Langue du système';

  @override
  String get addFilterHint => 'Ajouter un filtre…';

  @override
  String get add => 'Ajouter';

  @override
  String get noCustomFilters => 'Aucun filtre personnalisé.';

  @override
  String get delete => 'Supprimer';

  @override
  String get filtersLoadError => 'Impossible de charger les filtres.';
}
