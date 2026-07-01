// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get navHome => 'Início';

  @override
  String get navMovies => 'Filmes';

  @override
  String get navFavorites => 'Favoritos';

  @override
  String get navSettings => 'Definições';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get addProvider => 'Adicionar fornecedor';

  @override
  String get errorUnexpected => 'Algo correu mal. Tente novamente.';

  @override
  String get noResults => 'Sem resultados.';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get removeFromFavorites => 'Remover dos favoritos';

  @override
  String get errorNetworkTimeout =>
      'A ligação demorou demasiado. Tente novamente.';

  @override
  String get errorNoConnection =>
      'Sem ligação à internet. Verifique a sua rede.';

  @override
  String get errorInvalidServerUrl =>
      'O URL do servidor não existe. Verifique se está escrito corretamente.';

  @override
  String get errorBadCredentials => 'Utilizador ou palavra-passe incorretos.';

  @override
  String get errorParse =>
      'A resposta do servidor é inválida. Tente novamente.';

  @override
  String get errorInvalidStream =>
      'Este canal não está disponível neste momento.';

  @override
  String errorPlayer(String message) {
    return 'Erro de reprodução: $message';
  }

  @override
  String errorUnknown(String message) {
    return 'Erro inesperado: $message';
  }

  @override
  String get homeNoProvider => 'Ainda não adicionou nenhum fornecedor IPTV.';

  @override
  String get searchCategoriesHint => 'Pesquisar categorias…';

  @override
  String get filterQuality => 'Qualidade';

  @override
  String get filterCodec => 'Codec';

  @override
  String get filterCategory => 'Categoria';

  @override
  String get filterCountry => 'País';

  @override
  String get filtersClear => 'Limpar';

  @override
  String get filterOptionsLoadError => 'Não foi possível carregar as opções.';

  @override
  String filterPill(String label, String value) {
    return '$label: $value';
  }

  @override
  String get channels => 'Canais';

  @override
  String get viewModeList => 'Lista';

  @override
  String get viewModeGuide => 'Guia';

  @override
  String get epgLoading => 'A carregar guia…';

  @override
  String get epgUnavailable => 'Sem guia disponível';

  @override
  String get epgNow => 'Agora';

  @override
  String get epgNext => 'A seguir';

  @override
  String epgProgramLine(String label, String range, String title) {
    return '$label · $range · $title';
  }

  @override
  String get movies => 'Filmes';

  @override
  String get searchMoviesHint => 'Pesquisar filmes…';

  @override
  String get moviesNoProvider => 'Adicione um fornecedor IPTV para ver filmes.';

  @override
  String get movieCategoryEmpty => 'Não há filmes nesta categoria.';

  @override
  String get favorites => 'Favoritos';

  @override
  String get favoritesEmpty => 'Não tem favoritos';

  @override
  String get categories => 'Categorias';

  @override
  String get favoritesLoadError => 'Não foi possível carregar os favoritos.';

  @override
  String channelFallbackName(int streamId) {
    return 'Canal $streamId';
  }

  @override
  String get playerNoProvider => 'Nenhum fornecedor configurado.';

  @override
  String get playerNoPassword => 'Palavra-passe não encontrada.';

  @override
  String get playerError => 'Erro ao reproduzir o canal.';

  @override
  String get playerTimeout => 'O stream demorou demasiado tempo a iniciar.';

  @override
  String get providerNameLabel => 'Nome';

  @override
  String get providerNameValidation =>
      'Introduza um nome para identificar esta fonte';

  @override
  String get serverUrlLabel => 'URL do servidor';

  @override
  String get serverUrlValidation => 'Introduza o URL do servidor';

  @override
  String get usernameLabel => 'Utilizador';

  @override
  String get usernameValidation => 'Introduza o utilizador';

  @override
  String get passwordLabel => 'Palavra-passe';

  @override
  String get passwordValidation => 'Introduza a palavra-passe';

  @override
  String get nativeDiagnostic => 'Diagnóstico nativo (dart:io)';

  @override
  String get connect => 'Ligar';

  @override
  String get settingsTitle => 'Configuração';

  @override
  String get sectionProvider => 'Fornecedor';

  @override
  String get sectionFilters => 'Filtros';

  @override
  String get sectionAppearance => 'Aparência';

  @override
  String get sectionInfo => 'Informação';

  @override
  String get loading => 'A carregar…';

  @override
  String get customFilters => 'Filtros personalizados';

  @override
  String appVersion(String version) {
    return 'Versão $version — MVP v0.1';
  }

  @override
  String get syncCategoriesSuccess => 'Categorias sincronizadas';

  @override
  String get syncCategoriesError => 'Não foi possível sincronizar';

  @override
  String get sync => 'Sincronizar';

  @override
  String get remove => 'Remover';

  @override
  String get activate => 'Usar esta fonte';

  @override
  String get addSource => 'Adicionar fonte';

  @override
  String get sources => 'Fontes';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Idioma do sistema';

  @override
  String get addFilterHint => 'Adicionar filtro…';

  @override
  String get add => 'Adicionar';

  @override
  String get noCustomFilters => 'Sem filtros personalizados.';

  @override
  String get delete => 'Eliminar';

  @override
  String get filtersLoadError => 'Não foi possível carregar os filtros.';
}
