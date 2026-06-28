import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/logging/app_logger.dart';
import 'xtream_models.dart';

class XtreamApi {
  XtreamApi({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<XtreamAuthResponse> authenticate({
    required String server,
    required String username,
    required String password,
  }) async {
    final normalizedServer = _normalizeServer(server);
    final url = '$normalizedServer/player_api.php';
    try {
      log.i('[XtreamApi] Auth → $url');
      final response = await _dio.get(
        url,
        queryParameters: {'username': username, 'password': password},
        options: Options(
          headers: {
            'User-Agent':
                'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) '
                'AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
          },
        ),
      );
      log.d('[XtreamApi] Auth response status=${response.statusCode}');
      final data = _asMap(response.data);
      if (data['user_info']?['status'] == 'Disabled') {
        throw const BadCredentialsError();
      }
      return XtreamAuthResponse.fromJson(data);
    } on AppError {
      rethrow;
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e, st) {
      log.e('[XtreamApi] Parse error during auth', error: e, stackTrace: st);
      throw const ParseError();
    }
  }

  Future<List<XtreamCategory>> getLiveCategories({
    required String server,
    required String username,
    required String password,
  }) async {
    final normalizedServer = _normalizeServer(server);
    try {
      log.i('[XtreamApi] Fetching categories');
      final response = await _dio.get(
        '$normalizedServer/player_api.php',
        queryParameters: {
          'username': username,
          'password': password,
          'action': 'get_live_categories',
        },
      );
      return _parseList(response.data, XtreamCategory.fromJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<XtreamStream>> getLiveStreams({
    required String server,
    required String username,
    required String password,
    required String categoryId,
  }) async {
    final normalizedServer = _normalizeServer(server);
    try {
      log.i('[XtreamApi] Fetching streams for category $categoryId');
      final response = await _dio.get(
        '$normalizedServer/player_api.php',
        queryParameters: {
          'username': username,
          'password': password,
          'action': 'get_live_streams',
          'category_id': categoryId,
        },
      );
      return _parseList(response.data, XtreamStream.fromJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<XtreamCategory>> getVodCategories({
    required String server,
    required String username,
    required String password,
  }) async {
    final normalizedServer = _normalizeServer(server);
    try {
      log.i('[XtreamApi] Fetching VOD categories');
      final response = await _dio.get(
        '$normalizedServer/player_api.php',
        queryParameters: {
          'username': username,
          'password': password,
          'action': 'get_vod_categories',
        },
      );
      return _parseList(response.data, XtreamCategory.fromJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// Fetches VOD streams. When [categoryId] is null, returns the **entire**
  /// VOD catalogue in a single request (used for the global movie search).
  Future<List<XtreamStream>> getVodStreams({
    required String server,
    required String username,
    required String password,
    String? categoryId,
  }) async {
    final normalizedServer = _normalizeServer(server);
    try {
      log.i('[XtreamApi] Fetching VOD streams for category ${categoryId ?? 'ALL'}');
      final response = await _dio.get(
        '$normalizedServer/player_api.php',
        queryParameters: {
          'username': username,
          'password': password,
          'action': 'get_vod_streams',
          if (categoryId != null) 'category_id': categoryId,
        },
      );
      return _parseList(response.data, XtreamStream.fromJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<String> testConnectionNative({
    required String server,
    required String username,
    required String password,
  }) async {
    final normalizedServer = _normalizeServer(server);
    final uri = Uri.parse('$normalizedServer/player_api.php').replace(
      queryParameters: {'username': username, 'password': password},
    );
    log.i('[XtreamApi][Native] Testing → $uri');
    try {
      final client = HttpClient()
        // ignore: avoid_returning_null_for_void
        ..badCertificateCallback = (cert, host, port) {
          return true;
        }
        ..connectionTimeout = const Duration(seconds: 15);
      final request = await client.getUrl(uri);
      // No seguir redirecciones: queremos ver a dónde nos manda el panel.
      request.followRedirects = false;
      request.headers.set(
        'User-Agent',
        'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) '
        'AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
      );
      final response = await request.close();
      final location = response.headers.value('location');
      final body = await response.transform(utf8.decoder).join();
      client.close();
      log.i(
        '[XtreamApi][Native] Status=${response.statusCode} '
        'location=$location body[:100]=${body.substring(0, min(100, body.length))}',
      );
      final locationPart = location != null ? '\n→ Location: $location' : '';
      return 'HTTP ${response.statusCode}$locationPart\n${body.substring(0, min(200, body.length))}';
    } catch (e) {
      log.e('[XtreamApi][Native] Error: $e');
      return 'Error: $e';
    }
  }

  /// Decodifica el cuerpo como [Map] aunque Dio lo haya dejado como `String`
  /// (paneles que responden JSON con `Content-Type: text/html`).
  static Map<String, dynamic> _asMap(Object? data) => data is String
      ? jsonDecode(data) as Map<String, dynamic>
      : data as Map<String, dynamic>;

  static List<dynamic> _asList(Object? data) =>
      data is String ? jsonDecode(data) as List<dynamic> : data as List<dynamic>;

  /// Decodifica y deserializa una lista de la API, convirtiendo cualquier fallo
  /// de parseo (Content-Type erróneo, tipos inconsistentes, JSON inválido) en un
  /// [ParseError] en vez de dejar escapar un `TypeError`/`FormatException` crudo.
  static List<T> _parseList<T>(
    Object? data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      return _asList(data)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      log.e('[XtreamApi] Parse error', error: e, stackTrace: st);
      throw const ParseError();
    }
  }

  static String _normalizeServer(String server) {
    final trimmed = server.trim().replaceAll(RegExp(r'/$'), '');
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'http://$trimmed';
  }

  AppError _mapDioError(DioException e) {
    log.e(
      '[XtreamApi] DioException type=${e.type} status=${e.response?.statusCode} '
      'msg=${e.message} error=${e.error}',
    );
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkTimeoutError();
    }
    if (e.type == DioExceptionType.connectionError) {
      final err = e.error?.toString() ?? '';
      if (err.contains('Failed host lookup') || err.contains('nodename nor servname')) {
        return const InvalidServerUrlError();
      }
      return const NoConnectionError();
    }
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return const BadCredentialsError();
    }
    return UnknownError(e.message ?? 'Unknown network error');
  }
}
