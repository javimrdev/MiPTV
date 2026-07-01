import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/logging/app_logger.dart';
import 'package:miptv/core/url_builder.dart';
import 'package:miptv/l10n/app_localizations.dart';

/// Generous ceiling for the stream to actually start playing before we give
/// up and surface a retry option, instead of leaving the user on an
/// infinite spinner. mpv's `open()` only acks that the command was queued,
/// not that playback started, so this is the real "did it work" signal.
const _kPlaybackTimeout = Duration(seconds: 25);

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({
    super.key,
    required this.streamId,
    required this.extension,
    this.type = 'live',
  });

  final int streamId;
  final String extension;

  /// URL path segment: `live` for channels, `movie` for VOD.
  final String type;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late final Player _player;
  late final VideoController _controller;
  bool _initialized = false;
  String? _error;

  StreamSubscription<String>? _errorSub;
  StreamSubscription<bool>? _bufferingSub;
  StreamSubscription<int?>? _widthSub;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);
    _initPlayback();
  }

  void _cancelWatchers() {
    _errorSub?.cancel();
    _bufferingSub?.cancel();
    _widthSub?.cancel();
    _timeoutTimer?.cancel();
  }

  Future<void> _initPlayback() async {
    // Captured before any await so it can be used without a BuildContext gap.
    final l10n = AppLocalizations.of(context);
    _cancelWatchers();
    try {
      final providerRepo = ref.read(providerRepositoryProvider);
      final provider = await providerRepo.getProvider();
      if (provider == null) {
        setState(() => _error = l10n.playerNoProvider);
        return;
      }
      final password = await ref.read(secureStorageProvider).readPassword();
      if (password == null) {
        setState(() => _error = l10n.playerNoPassword);
        return;
      }

      final url = buildStreamUrl(
        server: provider.server,
        username: provider.username,
        password: password,
        streamId: widget.streamId,
        extension: widget.extension,
        type: widget.type,
      );

      // `open()` only awaits mpv acking that the command was queued, not
      // that the stream actually started — real failures (auth, unreachable
      // server, unsupported codec) surface later via `stream.error`, so we
      // must listen for them explicitly instead of relying on this await.
      _errorSub = _player.stream.error.listen((message) {
        log.e('[Player] mpv stream error: $message');
        _cancelWatchers();
        if (mounted) setState(() => _error = l10n.playerError);
      });
      // `playing` reflects the pause/play command state and flips to true
      // almost immediately on open, even while the stream is still stuck
      // buffering — it's not proof anything is actually on screen. Only a
      // resolved video width proves the decoder produced a real frame, so
      // that's what clears the stuck-buffering timeout below.
      _bufferingSub = _player.stream.buffering.listen((isBuffering) {
        log.i('[Player] buffering=$isBuffering');
      });
      _widthSub = _player.stream.width.listen((width) {
        if (width != null && width > 0) {
          log.i('[Player] video width resolved: $width');
          _timeoutTimer?.cancel();
        }
      });
      _timeoutTimer = Timer(_kPlaybackTimeout, () {
        log.w('[Player] Timed out waiting for playback to start');
        if (mounted) setState(() => _error = l10n.playerTimeout);
      });

      log.i('[Player] Opening $url');
      await _player.open(Media(url));
      setState(() => _initialized = true);
    } catch (e) {
      log.e('[Player] Error', error: e);
      _cancelWatchers();
      setState(() => _error = l10n.playerError);
    }
  }

  @override
  void dispose() {
    _cancelWatchers();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(_error!),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  setState(() => _error = null);
                  _initPlayback();
                },
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
      );
    }

    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Built-in MediaKit controls: play/pause, seek bar, ±seek.
          // AdaptiveVideoControls resolves to Material on both platforms
          // (media_kit_video 2.0.1 has no Cupertino control set yet).
          //
          // Default state shows clean video (visibleOnMount is false); tapping
          // reveals the controls and they auto-hide. The only override is
          // lifting the red seek bar off the bottom edge (default margin is
          // zero, so it sits flush against the bottom).
          MaterialVideoControlsTheme(
            normal: kDefaultMaterialVideoControlsThemeData.copyWith(
              visibleOnMount: false,
              seekBarMargin: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 12.0,
              ),
            ),
            fullscreen: kDefaultMaterialVideoControlsThemeDataFullscreen,
            child: Video(
              controller: _controller,
              controls: AdaptiveVideoControls,
            ),
          ),
          // Back/close button overlaid on top of the controls.
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
