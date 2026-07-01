// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navHome => 'Inicio';

  @override
  String get navMovies => 'Películas';

  @override
  String get navFavorites => 'Favoritos';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get retry => 'Reintentar';

  @override
  String get addProvider => 'Añadir proveedor';

  @override
  String get errorUnexpected => 'Error inesperado. Inténtalo de nuevo.';

  @override
  String get noResults => 'Sin resultados.';

  @override
  String get addToFavorites => 'Añadir a favoritos';

  @override
  String get removeFromFavorites => 'Quitar de favoritos';

  @override
  String get errorNetworkTimeout =>
      'La conexión tardó demasiado. Inténtalo de nuevo.';

  @override
  String get errorNoConnection => 'Sin conexión a internet. Revisa tu red.';

  @override
  String get errorInvalidServerUrl =>
      'La URL del servidor no existe. Comprueba que esté bien escrita.';

  @override
  String get errorBadCredentials => 'Usuario o contraseña incorrectos.';

  @override
  String get errorParse =>
      'La respuesta del servidor no es válida. Inténtalo de nuevo.';

  @override
  String get errorInvalidStream => 'El canal no está disponible ahora.';

  @override
  String errorPlayer(String message) {
    return 'Error al reproducir: $message';
  }

  @override
  String errorUnknown(String message) {
    return 'Error inesperado: $message';
  }

  @override
  String get homeNoProvider => 'Aún no has añadido ningún proveedor IPTV.';

  @override
  String get searchCategoriesHint => 'Buscar categorías…';

  @override
  String get filterQuality => 'Calidad';

  @override
  String get filterCodec => 'Códec';

  @override
  String get filterCategory => 'Categoría';

  @override
  String get filterCountry => 'País';

  @override
  String get filtersClear => 'Borrar';

  @override
  String get filterOptionsLoadError => 'No se pudieron cargar las opciones.';

  @override
  String filterPill(String label, String value) {
    return '$label: $value';
  }

  @override
  String get channels => 'Canales';

  @override
  String get viewModeList => 'Lista';

  @override
  String get viewModeGuide => 'Guía';

  @override
  String get epgLoading => 'Cargando guía…';

  @override
  String get epgUnavailable => 'Sin guía disponible';

  @override
  String get epgNow => 'Ahora';

  @override
  String get epgNext => 'Después';

  @override
  String epgProgramLine(String label, String range, String title) {
    return '$label · $range · $title';
  }

  @override
  String get movies => 'Películas';

  @override
  String get searchMoviesHint => 'Buscar películas…';

  @override
  String get moviesNoProvider => 'Añade un proveedor IPTV para ver películas.';

  @override
  String get movieCategoryEmpty => 'No hay películas en esta categoría.';

  @override
  String get favorites => 'Favoritos';

  @override
  String get favoritesEmpty => 'No tienes favoritos';

  @override
  String get categories => 'Categorías';

  @override
  String get favoritesLoadError => 'No se pudieron cargar los favoritos.';

  @override
  String channelFallbackName(int streamId) {
    return 'Canal $streamId';
  }

  @override
  String get playerNoProvider => 'No hay proveedor configurado.';

  @override
  String get playerNoPassword => 'No se encontró la contraseña.';

  @override
  String get playerError => 'Error al reproducir el canal.';

  @override
  String get playerTimeout => 'El stream tardó demasiado en iniciar.';

  @override
  String get providerNameLabel => 'Nombre';

  @override
  String get providerNameValidation =>
      'Introduce un nombre para identificar esta fuente';

  @override
  String get serverUrlLabel => 'URL del servidor';

  @override
  String get serverUrlValidation => 'Introduce la URL del servidor';

  @override
  String get usernameLabel => 'Usuario';

  @override
  String get usernameValidation => 'Introduce el usuario';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordValidation => 'Introduce la contraseña';

  @override
  String get nativeDiagnostic => 'Diagnóstico nativo (dart:io)';

  @override
  String get connect => 'Conectar';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get sectionProvider => 'Proveedor';

  @override
  String get sectionFilters => 'Filtros';

  @override
  String get sectionAppearance => 'Apariencia';

  @override
  String get sectionInfo => 'Información';

  @override
  String get loading => 'Cargando…';

  @override
  String get customFilters => 'Filtros personalizados';

  @override
  String appVersion(String version) {
    return 'Versión $version — MVP v0.1';
  }

  @override
  String get syncCategoriesSuccess => 'Categorías sincronizadas';

  @override
  String get syncCategoriesError => 'No se pudo sincronizar';

  @override
  String get sync => 'Sincronizar';

  @override
  String get remove => 'Eliminar';

  @override
  String get activate => 'Usar esta fuente';

  @override
  String get addSource => 'Añadir fuente';

  @override
  String get sources => 'Fuentes';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get addFilterHint => 'Añadir filtro…';

  @override
  String get add => 'Añadir';

  @override
  String get noCustomFilters => 'Sin filtros personalizados.';

  @override
  String get delete => 'Eliminar';

  @override
  String get filtersLoadError => 'No se pudieron cargar los filtros.';
}
