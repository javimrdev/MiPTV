import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/widgets/skeleton.dart';
import 'package:miptv/features/epg/domain/epg_entity.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

final _streamsProvider =
    FutureProvider.family<List<StreamEntity>, String>((ref, categoryId) {
  return ref.watch(streamRepositoryProvider).getStreamsForCategory(categoryId);
});

final _favoriteToggleProvider =
    FutureProvider.family<bool, int>((ref, streamId) {
  return ref.watch(favoriteRepositoryProvider).isFavorite(streamId);
});

/// Vista activa de la lista de canales de una categoría.
enum _ViewMode { lista, guia }

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  // Siempre se empieza en Lista al entrar (sin estado persistente).
  _ViewMode _mode = _ViewMode.lista;

  @override
  Widget build(BuildContext context) {
    final streamsAsync = ref.watch(_streamsProvider(widget.categoryId));

    return Scaffold(
      appBar: AppBar(title: const Text('Canales')),
      body: streamsAsync.when(
        data: (streams) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: SegmentedButton<_ViewMode>(
                segments: const [
                  ButtonSegment(
                    value: _ViewMode.lista,
                    label: Text('Lista'),
                    icon: Icon(Icons.list),
                  ),
                  ButtonSegment(
                    value: _ViewMode.guia,
                    label: Text('Guía'),
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
            ),
            Expanded(
              child: _mode == _ViewMode.lista
                  ? ListView.builder(
                      itemCount: streams.length,
                      itemExtent: 72,
                      itemBuilder: (_, i) => _StreamTile(stream: streams[i]),
                    )
                  : ListView.builder(
                      itemCount: streams.length,
                      itemExtent: 88,
                      itemBuilder: (_, i) => _StreamEpgTile(stream: streams[i]),
                    ),
            ),
          ],
        ),
        loading: () => const SkeletonList.streams(),
        error: (e, _) {
          final msg = e is AppError
              ? e.userMessage
              : 'Error inesperado. Inténtalo de nuevo.';
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.signal_wifi_off, size: 48),
                const SizedBox(height: 12),
                Text(msg, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () =>
                      ref.invalidate(_streamsProvider(widget.categoryId)),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Logo del canal con placeholder/fallback compartido por ambas vistas.
class _StreamLogo extends StatelessWidget {
  const _StreamLogo({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: 48,
      height: 48,
      fit: BoxFit.contain,
      placeholder: (_, __) =>
          const SizedBox.square(dimension: 48, child: Icon(Icons.live_tv)),
      errorWidget: (_, __, ___) => const Icon(Icons.live_tv),
    );
  }
}

/// Botón de favorito reutilizado por ambas vistas.
class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.streamId});
  final int streamId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavAsync = ref.watch(_favoriteToggleProvider(streamId));
    return isFavAsync.maybeWhen(
      data: (isFav) => IconButton(
        icon: Icon(isFav ? Icons.star : Icons.star_border),
        onPressed: () async {
          final repo = ref.read(favoriteRepositoryProvider);
          if (isFav) {
            await repo.removeFavorite(streamId);
          } else {
            await repo.addFavorite(streamId);
          }
          ref.invalidate(_favoriteToggleProvider(streamId));
        },
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _StreamTile extends StatelessWidget {
  const _StreamTile({required this.stream});
  final StreamEntity stream;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _StreamLogo(url: stream.logo),
      title: Text(stream.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: _FavoriteButton(streamId: stream.id),
      onTap: () => context.push('/player/${stream.id}?ext=${stream.extension}'),
    );
  }
}

/// Tile de la vista Guía: icono + emisión actual y siguiente (ahora/después).
class _StreamEpgTile extends ConsumerWidget {
  const _StreamEpgTile({required this.stream});
  final StreamEntity stream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final epgAsync = ref.watch(channelEpgProvider(stream.id));

    return ListTile(
      leading: _StreamLogo(url: stream.logo),
      title: Text(stream.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: epgAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text('Cargando guía…'),
        ),
        error: (_, __) => const Text('Sin guía disponible'),
        data: (epg) => _EpgSubtitle(epg: epg),
      ),
      isThreeLine: true,
      trailing: _FavoriteButton(streamId: stream.id),
      onTap: () => context.push('/player/${stream.id}?ext=${stream.extension}'),
    );
  }
}

class _EpgSubtitle extends StatelessWidget {
  const _EpgSubtitle({required this.epg});
  final ChannelEpg epg;

  @override
  Widget build(BuildContext context) {
    if (epg.isEmpty) return const Text('Sin guía disponible');

    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.bodySmall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (epg.now != null)
            _EpgLine(label: 'Ahora', program: epg.now!, emphasize: true),
          if (epg.next != null)
            _EpgLine(label: 'Después', program: epg.next!, emphasize: false),
        ],
      ),
    );
  }
}

class _EpgLine extends StatelessWidget {
  const _EpgLine({
    required this.label,
    required this.program,
    required this.emphasize,
  });

  final String label;
  final EpgProgram program;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final range = '${_hm(program.start)}–${_hm(program.end)}';
    return Text(
      '$label · $range · ${program.title}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: emphasize ? const TextStyle(fontWeight: FontWeight.w600) : null,
    );
  }
}

/// `DateTime` local → `HH:mm` sin dependencia de intl.
String _hm(DateTime dt) =>
    '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
