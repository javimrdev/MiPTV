import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/features/provider/data/xtream_api.dart';

const _server = 'http://test.tv';
const _user = 'alice';
const _pass = 'secret';

final _validAuthData = {
  'user_info': {'username': 'alice', 'password': 'secret', 'status': 'Active'},
  'server_info': {'url': 'test.tv', 'port': '80'},
};

final _disabledAuthData = {
  'user_info': {'username': 'alice', 'password': 'x', 'status': 'Disabled'},
  'server_info': {'url': 'test.tv', 'port': '80'},
};

final _categoriesData = [
  {'category_id': '1', 'category_name': 'Deportes'},
  {'category_id': '2', 'category_name': 'Cine'},
];

final _streamsData = [
  {
    'stream_id': 101,
    'name': 'Canal Deportes HD',
    'stream_icon': 'http://logo.tv/d.png',
    'category_id': '1',
    'container_extension': 'ts',
  },
];

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late XtreamApi api;

  setUp(() {
    dio = Dio(BaseOptions());
    adapter = DioAdapter(dio: dio);
    api = XtreamApi(dio: dio);
  });

  group('XtreamApi.authenticate', () {
    test('returns auth response on valid credentials', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {'username': _user, 'password': _pass},
        (server) => server.reply(200, _validAuthData),
      );

      final result = await api.authenticate(
        server: _server,
        username: _user,
        password: _pass,
      );

      expect(result.userInfo.username, _user);
      expect(result.userInfo.status, 'Active');
    });

    test('throws BadCredentialsError on Disabled account', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {'username': _user, 'password': _pass},
        (server) => server.reply(200, _disabledAuthData),
      );

      expect(
        () => api.authenticate(server: _server, username: _user, password: _pass),
        throwsA(isA<BadCredentialsError>()),
      );
    });

    test('throws NetworkTimeoutError on connection timeout', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {'username': _user, 'password': _pass},
        (server) => server.throws(
          0,
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        ),
      );

      await expectLater(
        () => api.authenticate(server: _server, username: _user, password: _pass),
        throwsA(isA<NetworkTimeoutError>()),
      );
    });

    test('throws NoConnectionError on connection failure', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {'username': _user, 'password': _pass},
        (server) => server.throws(
          0,
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError,
          ),
        ),
      );

      await expectLater(
        () => api.authenticate(server: _server, username: _user, password: _pass),
        throwsA(isA<NoConnectionError>()),
      );
    });
  });

  group('XtreamApi.getLiveCategories', () {
    test('parses categories from Xtream response', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {
          'username': _user,
          'password': _pass,
          'action': 'get_live_categories',
        },
        (server) => server.reply(200, _categoriesData),
      );

      final categories = await api.getLiveCategories(
        server: _server,
        username: _user,
        password: _pass,
      );

      expect(categories.length, 2);
      expect(categories[0].categoryId, '1');
      expect(categories[0].categoryName, 'Deportes');
    });
  });

  group('XtreamApi.getLiveStreams', () {
    test('parses streams and model has no full URL field', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {
          'username': _user,
          'password': _pass,
          'action': 'get_live_streams',
          'category_id': '1',
        },
        (server) => server.reply(200, _streamsData),
      );

      final streams = await api.getLiveStreams(
        server: _server,
        username: _user,
        password: _pass,
        categoryId: '1',
      );

      expect(streams.length, 1);
      expect(streams[0].streamId, 101);
      expect(streams[0].extension, 'ts');
      // Verify: XtreamStream has no streamUrl field (compile-time enforced).
    });
  });
}
