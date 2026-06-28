import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:miptv/features/provider/data/xtream_api.dart';

const _server = 'http://test.tv';
const _user = 'alice';
const _pass = 'secret';

final _vodCategoriesData = [
  {'category_id': '10', 'category_name': 'Acción'},
  {'category_id': '11', 'category_name': 'Comedia'},
];

final _vodStreamsData = [
  {
    'stream_id': 5001,
    'name': 'Película Uno',
    'stream_icon': 'http://logo.tv/m1.png',
    'category_id': '10',
    'container_extension': 'mp4',
  },
  {
    'stream_id': 5002,
    'name': 'Película Dos',
    'stream_icon': 'http://logo.tv/m2.png',
    'category_id': '11',
    'container_extension': 'mkv',
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

  group('XtreamApi.getVodCategories', () {
    test('parses VOD categories from Xtream response', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {
          'username': _user,
          'password': _pass,
          'action': 'get_vod_categories',
        },
        (server) => server.reply(200, _vodCategoriesData),
      );

      final categories = await api.getVodCategories(
        server: _server,
        username: _user,
        password: _pass,
      );

      expect(categories.length, 2);
      expect(categories[0].categoryId, '10');
      expect(categories[1].categoryName, 'Comedia');
    });
  });

  group('XtreamApi.getVodStreams', () {
    test('fetches the entire catalogue when categoryId is null', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {
          'username': _user,
          'password': _pass,
          'action': 'get_vod_streams',
        },
        (server) => server.reply(200, _vodStreamsData),
      );

      final movies = await api.getVodStreams(
        server: _server,
        username: _user,
        password: _pass,
      );

      expect(movies.length, 2);
      expect(movies[0].streamId, 5001);
      expect(movies[0].extension, 'mp4');
      expect(movies[1].extension, 'mkv');
    });

    test('filters by category_id when provided', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {
          'username': _user,
          'password': _pass,
          'action': 'get_vod_streams',
          'category_id': '10',
        },
        (server) => server.reply(200, [_vodStreamsData.first]),
      );

      final movies = await api.getVodStreams(
        server: _server,
        username: _user,
        password: _pass,
        categoryId: '10',
      );

      expect(movies.length, 1);
      expect(movies.first.categoryId, '10');
    });
  });
}
