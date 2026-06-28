import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/favorites/domain/favorite_entity.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

/// Loads favorites and hydrates their stream details in a single batch query.
final _favoritesViewProvider =
    FutureProvider<(List<FavoriteEntity>, Map<int, StreamEntity>)>((ref) async {
  final favorites = await ref.watch(favoriteRepositoryProvider).getFavorites();
  final streams = await ref
      .watch(streamRepositoryProvider)
      .getStreamsByIds(favorites.map((f) => f.streamId).toList());
  final byId = {for (final s in streams) s.id: s};
  return (favorites, byId);
});

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewAsync = ref.watch(_favoritesViewProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: viewAsync.when(
        data: (data) {
          final (favorites, byId) = data;
          if (favorites.isEmpty) {
            return const Center(child: Text('No tienes favoritos'));
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemExtent: 72,
            itemBuilder: (_, i) {
              final fav = favorites[i];
              return _FavoriteTile(
                streamId: fav.streamId,
                stream: byId[fav.streamId],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text('No se pudieron cargar los favoritos.'),
        ),
      ),
    );
  }
}

class _FavoriteTile extends ConsumerWidget {
  const _FavoriteTile({required this.streamId, required this.stream});

  final int streamId;
  final StreamEntity? stream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = stream;
    return ListTile(
      leading: s == null
          ? const SizedBox.square(dimension: 48, child: Icon(Icons.live_tv))
          : CachedNetworkImage(
              imageUrl: s.logo,
              width: 48,
              height: 48,
              fit: BoxFit.contain,
              placeholder: (_, __) =>
                  const SizedBox.square(dimension: 48, child: Icon(Icons.live_tv)),
              errorWidget: (_, __, ___) => const Icon(Icons.live_tv),
            ),
      title: Text(
        s?.name ?? 'Canal $streamId',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.star),
        tooltip: 'Quitar de favoritos',
        onPressed: () async {
          await ref.read(favoriteRepositoryProvider).removeFavorite(streamId);
          ref.invalidate(_favoritesViewProvider);
        },
      ),
      onTap: s == null
          ? null
          : () => context.push('/player/${s.id}?ext=${s.extension}'),
    );
  }
}
