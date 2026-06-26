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
    try {
      log.i('[XtreamApi] Auth $server');
      final response = await _dio.get(
        '$server/player_api.php',
        queryParameters: {'username': username, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      if (data['user_info']?['status'] == 'Disabled') {
        throw const BadCredentialsError();
      }
      return XtreamAuthResponse.fromJson(data);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<XtreamCategory>> getLiveCategories({
    required String server,
    required String username,
    required String password,
  }) async {
    try {
      log.i('[XtreamApi] Fetching categories');
      final response = await _dio.get(
        '$server/player_api.php',
        queryParameters: {
          'username': username,
          'password': password,
          'action': 'get_live_categories',
        },
      );
      final list = response.data as List<dynamic>;
      return list.map((e) => XtreamCategory.fromJson(e as Map<String, dynamic>)).toList();
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
    try {
      log.i('[XtreamApi] Fetching streams for category $categoryId');
      final response = await _dio.get(
        '$server/player_api.php',
        queryParameters: {
          'username': username,
          'password': password,
          'action': 'get_live_streams',
          'category_id': categoryId,
        },
      );
      final list = response.data as List<dynamic>;
      return list.map((e) => XtreamStream.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  AppError _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkTimeoutError();
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NoConnectionError();
    }
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return const BadCredentialsError();
    }
    return UnknownError(e.message ?? 'Unknown network error');
  }
}
