import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/storage/secure_storage.dart';
import 'package:miptv/features/epg/data/epg_repository_impl.dart';
import 'package:miptv/features/provider/data/xtream_api.dart';
import 'package:miptv/features/provider/data/xtream_models.dart';
import 'package:miptv/features/provider/domain/iptv_provider_repository.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';

class MockXtreamApi extends Mock implements XtreamApi {}

class MockProviderRepo extends Mock implements IPTVProviderRepository {}

class MockSecureStorage extends Mock implements SecureStorageService {}

/// Listing helper: title gets base64-encoded (the panel sends it encoded) and
/// timestamps are unix seconds relative to [now].
XtreamEpgListing listing(String title, int startSec, int stopSec) =>
    XtreamEpgListing(
      title: base64.encode(utf8.encode(title)),
      startTimestamp: startSec,
      stopTimestamp: stopSec,
    );

void main() {
  late MockXtreamApi api;
  late MockProviderRepo providerRepo;
  late MockSecureStorage storage;
  late EpgRepositoryImpl repo;

  final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  setUp(() {
    api = MockXtreamApi();
    providerRepo = MockProviderRepo();
    storage = MockSecureStorage();
    repo = EpgRepositoryImpl(
      api: api,
      providerRepo: providerRepo,
      secureStorage: storage,
    );

    when(() => providerRepo.getProvider()).thenAnswer(
      (_) async =>
          const ProviderEntity(id: 1, server: 'http://x.tv', username: 'u'),
    );
    when(() => storage.readPassword()).thenAnswer((_) async => 'pw');
  });

  void stubEpg(List<XtreamEpgListing> listings) {
    when(() => api.getShortEpg(
          server: any(named: 'server'),
          username: any(named: 'username'),
          password: any(named: 'password'),
          streamId: any(named: 'streamId'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => listings);
  }

  test('picks now/next by timestamp and decodes base64 titles', () async {
    stubEpg([
      listing('Programa anterior', nowSec - 7200, nowSec - 3600),
      listing('En emisión', nowSec - 600, nowSec + 600),
      listing('Lo siguiente', nowSec + 600, nowSec + 1800),
    ]);

    final epg = await repo.getNowNext(101);

    expect(epg.now?.title, 'En emisión');
    expect(epg.next?.title, 'Lo siguiente');
  });

  test('handles panels that return only future programs (no current)',
      () async {
    stubEpg([
      listing('Futuro 1', nowSec + 600, nowSec + 1800),
      listing('Futuro 2', nowSec + 1800, nowSec + 3600),
    ]);

    final epg = await repo.getNowNext(102);

    expect(epg.now, isNull);
    expect(epg.next?.title, 'Futuro 1');
  });

  test('is order-independent (now/next chosen by time, not position)',
      () async {
    // Deliberately out of order; current program is last in the list.
    stubEpg([
      listing('Lo siguiente', nowSec + 600, nowSec + 1800),
      listing('En emisión', nowSec - 600, nowSec + 600),
    ]);

    final epg = await repo.getNowNext(103);

    expect(epg.now?.title, 'En emisión');
    expect(epg.next?.title, 'Lo siguiente');
  });

  test('returns empty ChannelEpg when the panel serves no EPG', () async {
    stubEpg([]);

    final epg = await repo.getNowNext(104);

    expect(epg.isEmpty, isTrue);
  });

  test('degrades to empty (never throws) when the API errors', () async {
    when(() => api.getShortEpg(
          server: any(named: 'server'),
          username: any(named: 'username'),
          password: any(named: 'password'),
          streamId: any(named: 'streamId'),
          limit: any(named: 'limit'),
        )).thenThrow(const NoConnectionError());

    final epg = await repo.getNowNext(105);

    expect(epg.isEmpty, isTrue);
  });

  test('caches results so a re-fetch does not re-hit the panel', () async {
    stubEpg([listing('En emisión', nowSec - 600, nowSec + 600)]);

    await repo.getNowNext(106);
    await repo.getNowNext(106);

    verify(() => api.getShortEpg(
          server: any(named: 'server'),
          username: any(named: 'username'),
          password: any(named: 'password'),
          streamId: 106,
          limit: any(named: 'limit'),
        )).called(1);
  });
}
