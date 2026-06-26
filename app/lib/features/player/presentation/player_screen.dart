import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/logging/app_logger.dart';
import 'package:miptv/core/url_builder.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({
    super.key,
    required this.streamId,
    required this.extension,
  });

  final int streamId;
  final String extension;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late final Player _player;
  late final VideoController _controller;
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);
    _initPlayback();
  }

  Future<void> _initPlayback() async {
    try {
      final providerRepo = ref.read(providerRepositoryProvider);
      final provider = await providerRepo.getProvider();
      if (provider == null) {
        setState(() => _error = 'No hay proveedor configurado.');
        return;
      }
      final password = await ref.read(secureStorageProvider).readPassword();
      if (password == null) {
        setState(() => _error = 'No se encontró la contraseña.');
        return;
      }

      final url = buildStreamUrl(
        server: provider.server,
        username: provider.username,
        password: password,
        streamId: widget.streamId,
        extension: widget.extension,
      );

      log.i('[Player] Opening $url');
      await _player.open(Media(url));
      setState(() => _initialized = true);
    } catch (e) {
      log.e('[Player] Error', error: e);
      setState(() => _error = 'Error al reproducir el canal.');
    }
  }

  @override
  void dispose() {
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
                child: const Text('Reintentar'),
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
          Video(controller: _controller),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
