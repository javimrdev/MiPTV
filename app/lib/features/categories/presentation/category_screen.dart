import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

final _streamsProvider =
    FutureProvider.family<List<StreamEntity>, String>((ref, categoryId) {
  return ref.watch(streamRepositoryProvider).getStreamsForCategory(categoryId);
});

final _favoriteToggleProvider =
    FutureProvider.family<bool, int>((ref, streamId) {
  return ref.watch(favoriteRepositoryProvider).isFavorite(streamId);
});

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamsAsync = ref.watch(_streamsProvider(categoryId));

    return Scaffold(
      appBar: AppBar(title: Text('Canales')),
      body: streamsAsync.when(
        data: (streams) => ListView.builder(
          itemCount: streams.length,
          itemExtent: 72,
          itemBuilder: (_, i) => _StreamTile(stream: streams[i]),
        ),
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Sincronizando canales…'),
            ],
          ),
        ),
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
                  onPressed: () => ref.invalidate(_streamsProvider(categoryId)),
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

class _StreamTile extends ConsumerWidget {
  const _StreamTile({required this.stream});
  final StreamEntity stream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavAsync = ref.watch(_favoriteToggleProvider(stream.id));

    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: stream.logo,
        width: 48,
        height: 48,
        fit: BoxFit.contain,
        placeholder: (_, __) =>
            const SizedBox.square(dimension: 48, child: Icon(Icons.live_tv)),
        errorWidget: (_, __, ___) => const Icon(Icons.live_tv),
      ),
      title: Text(stream.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: isFavAsync.maybeWhen(
        data: (isFav) => IconButton(
          icon: Icon(isFav ? Icons.star : Icons.star_border),
          onPressed: () async {
            final repo = ref.read(favoriteRepositoryProvider);
            if (isFav) {
              await repo.removeFavorite(stream.id);
            } else {
              await repo.addFavorite(stream.id);
            }
            ref.invalidate(_favoriteToggleProvider(stream.id));
          },
        ),
        orElse: () => const SizedBox.shrink(),
      ),
      onTap: () => context.push('/player/${stream.id}?ext=${stream.extension}'),
    );
  }
}
