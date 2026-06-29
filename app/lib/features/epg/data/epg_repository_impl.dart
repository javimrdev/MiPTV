import 'dart:convert';

import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/logging/app_logger.dart';
import 'package:miptv/core/storage/secure_storage.dart';
import 'package:miptv/features/epg/domain/epg_entity.dart';
import 'package:miptv/features/epg/domain/epg_repository.dart';
import 'package:miptv/features/provider/data/xtream_api.dart';
import 'package:miptv/features/provider/data/xtream_models.dart';
import 'package:miptv/features/provider/domain/iptv_provider_repository.dart';

class EpgRepositoryImpl implements EpgRepository {
  EpgRepositoryImpl({
    required XtreamApi api,
    required IPTVProviderRepository providerRepo,
    required SecureStorageService secureStorage,
  })  : _api = api,
        _providerRepo = providerRepo,
        _secureStorage = secureStorage;

  final XtreamApi _api;
  final IPTVProviderRepository _providerRepo;
  final SecureStorageService _secureStorage;

  /// Cache en memoria con TTL corto. El EPG *now/next* es efímero, pero al hacer
  /// scroll en modo Guía un mismo canal se reconstruye varias veces: cachear
  /// evita re-pegar al panel en cada rebuild. No se persiste en Isar.
  static const _ttl = Duration(minutes: 5);
  final Map<int, _CacheEntry> _cache = {};

  @override
  Future<ChannelEpg> getNowNext(int streamId) async {
    final cached = _cache[streamId];
    if (cached != null && DateTime.now().isBefore(cached.expiresAt)) {
      return cached.epg;
    }

    final epg = await _fetch(streamId);
    _cache[streamId] = _CacheEntry(epg, DateTime.now().add(_ttl));
    return epg;
  }

  Future<ChannelEpg> _fetch(int streamId) async {
    try {
      final provider = await _providerRepo.getProvider();
      if (provider == null) return const ChannelEpg();
      final password = await _secureStorage.readPassword();
      if (password == null) return const ChannelEpg();

      final listings = await _api.getShortEpg(
        server: provider.server,
        username: provider.username,
        password: password,
        streamId: streamId,
      );
      return _toChannelEpg(listings);
    } on AppError catch (e) {
      // Muchos paneles no sirven guía fiable: degradar a "sin guía" en vez de
      // propagar el error a la UI.
      log.d('[Epg] No EPG for stream $streamId: ${e.runtimeType}');
      return const ChannelEpg();
    } catch (e, st) {
      log.w('[Epg] Unexpected error fetching EPG for $streamId',
          error: e, stackTrace: st);
      return const ChannelEpg();
    }
  }

  /// Elige *ahora/siguiente* **por timestamp**, no por posición: el panel puede
  /// devolver el programa en emisión en `[0]` o sólo programas futuros.
  static ChannelEpg _toChannelEpg(List<XtreamEpgListing> listings) {
    if (listings.isEmpty) return const ChannelEpg();

    final programs = listings.map(_toProgram).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    final now = DateTime.now();

    EpgProgram? current;
    EpgProgram? upcoming;
    for (final p in programs) {
      if (!p.start.isAfter(now) && p.end.isAfter(now)) {
        current ??= p;
      } else if (p.start.isAfter(now)) {
        upcoming ??= p;
      }
    }

    return ChannelEpg(now: current, next: upcoming);
  }

  static EpgProgram _toProgram(XtreamEpgListing l) => EpgProgram(
        title: _decodeTitle(l.title),
        // fromMillisecondsSinceEpoch → instante en hora local del dispositivo.
        start: DateTime.fromMillisecondsSinceEpoch(l.startTimestamp * 1000),
        end: DateTime.fromMillisecondsSinceEpoch(l.stopTimestamp * 1000),
      );

  /// Los títulos del short EPG llegan en base64. Si la decodificación falla,
  /// se devuelve el texto original.
  static String _decodeTitle(String raw) {
    if (raw.isEmpty) return '';
    try {
      return utf8.decode(base64.decode(base64.normalize(raw)));
    } catch (_) {
      return raw;
    }
  }
}

class _CacheEntry {
  _CacheEntry(this.epg, this.expiresAt);
  final ChannelEpg epg;
  final DateTime expiresAt;
}
