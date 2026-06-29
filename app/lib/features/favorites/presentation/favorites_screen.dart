import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/favorites/domain/favorite_category_entity.dart';
import 'package:miptv/features/favorites/domain/favorite_entity.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

/// Loads favorites (categories + channels) and hydrates the channels' stream
/// details in a single batch query.
final _favoritesViewProvider = FutureProvider<
    (
      List<FavoriteCategoryEntity>,
      List<FavoriteEntity>,
      Map<int, StreamEntity>,
    )>((ref) async {
  final favRepo = ref.watch(favoriteRepositoryProvider);
  final categories = await favRepo.getFavoriteCategories();
  final favorites = await favRepo.getFavorites();
  final streams = await ref
      .watch(streamRepositoryProvider)
      .getStreamsByIds(favorites.map((f) => f.streamId).toList());
  final byId = {for (final s in streams) s.id: s};
  return (categories, favorites, byId);
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
          final (categories, favorites, byId) = data;
          if (categories.isEmpty && favorites.isEmpty) {
            return const Center(child: Text('No tienes favoritos'));
          }
          return CustomScrollView(
            slivers: [
              if (categories.isNotEmpty) ...[
                const _SectionHeader('Categorías'),
                SliverFixedExtentList.builder(
                  itemExtent: 72,
                  itemCount: categories.length,
                  itemBuilder: (_, i) =>
                      _FavoriteCategoryTile(category: categories[i]),
                ),
              ],
              if (favorites.isNotEmpty) ...[
                const _SectionHeader('Canales'),
                SliverFixedExtentList.builder(
                  itemExtent: 72,
                  itemCount: favorites.length,
                  itemBuilder: (_, i) {
                    final fav = favorites[i];
                    return _FavoriteTile(
                      streamId: fav.streamId,
                      stream: byId[fav.streamId],
                    );
                  },
                ),
              ],
            ],
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}

class _FavoriteCategoryTile extends ConsumerWidget {
  const _FavoriteCategoryTile({required this.category});

  final FavoriteCategoryEntity category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.category),
      title: Text(
        category.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.star),
        tooltip: 'Quitar de favoritos',
        onPressed: () async {
          await ref
              .read(favoriteRepositoryProvider)
              .removeFavoriteCategory(category.categoryId);
          ref.invalidate(_favoritesViewProvider);
        },
      ),
      onTap: () => context.push('/category/${category.categoryId}'),
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
