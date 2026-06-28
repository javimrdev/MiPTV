import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:miptv/features/provider/data/xtream_api.dart';

const _server = 'http://test.tv';
const _user = 'alice';
const _pass = 'secret';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late XtreamApi api;

  setUp(() {
    dio = Dio(BaseOptions());
    adapter = DioAdapter(dio: dio);
    api = XtreamApi(dio: dio);
  });

  group('XtreamApi.getLiveCategories — convención string|number', () {
    test('normaliza category_id numérico a String', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {
          'username': _user,
          'password': _pass,
          'action': 'get_live_categories',
        },
        (server) => server.reply(200, [
          {'category_id': 10, 'category_name': 'Deportes'},
          {'category_id': '11', 'category_name': 'Cine'},
        ]),
      );

      final cats = await api.getLiveCategories(
        server: _server,
        username: _user,
        password: _pass,
      );

      expect(cats.length, 2);
      expect(cats[0].categoryId, '10');
      expect(cats[1].categoryId, '11');
    });

    test('tolera category_name nulo sin lanzar', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {
          'username': _user,
          'password': _pass,
          'action': 'get_live_categories',
        },
        (server) => server.reply(200, [
          {'category_id': '1', 'category_name': null},
        ]),
      );

      final cats = await api.getLiveCategories(
        server: _server,
        username: _user,
        password: _pass,
      );

      expect(cats.single.categoryId, '1');
      expect(cats.single.categoryName, '');
    });

    test('decodifica el cuerpo aunque llegue como String (text/html)', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {
          'username': _user,
          'password': _pass,
          'action': 'get_live_categories',
        },
        (server) => server.reply(
          200,
          jsonEncode([
            {'category_id': '5', 'category_name': 'Noticias'},
          ]),
          headers: {
            Headers.contentTypeHeader: ['text/html'],
          },
        ),
      );

      final cats = await api.getLiveCategories(
        server: _server,
        username: _user,
        password: _pass,
      );

      expect(cats.single.categoryId, '5');
      expect(cats.single.categoryName, 'Noticias');
    });
  });

  group('XtreamApi.authenticate — convención string|number', () {
    test('tolera port numérico en server_info', () async {
      adapter.onGet(
        '$_server/player_api.php',
        queryParameters: {'username': _user, 'password': _pass},
        (server) => server.reply(200, {
          'user_info': {
            'username': _user,
            'password': _pass,
            'status': 'Active',
          },
          'server_info': {'url': 'test.tv', 'port': 8080},
        }),
      );

      final auth = await api.authenticate(
        server: _server,
        username: _user,
        password: _pass,
      );

      expect(auth.serverInfo.port, '8080');
      expect(auth.userInfo.status, 'Active');
    });
  });
}
