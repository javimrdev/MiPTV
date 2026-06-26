import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/favorites/domain/favorite_entity.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

final _categoriesProvider = FutureProvider<List<CategoryEntity>>((ref) {
  return ref.watch(categoryRepositoryProvider).getCategories();
});

final _favoritesProvider = FutureProvider<List<FavoriteEntity>>((ref) {
  return ref.watch(favoriteRepositoryProvider).getFavorites();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(_categoriesProvider);
    final favoritesAsync = ref.watch(_favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MiPTV'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar proveedor',
            onPressed: () async {
              await ref.read(providerRepositoryProvider).removeProvider();
              if (context.mounted) context.go('/add-provider');
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          favoritesAsync.when(
            data: (favs) => favs.isEmpty
                ? const SliverToBoxAdapter(child: SizedBox.shrink())
                : SliverToBoxAdapter(
                    child: _FavoritesCarousel(favorites: favs),
                  ),
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
          categoriesAsync.when(
            data: (cats) => SliverList.builder(
              itemCount: cats.length,
              itemBuilder: (_, i) => _CategoryTile(category: cats[i]),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.signal_wifi_off, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        e is AppError
                            ? e.userMessage
                            : 'Error inesperado. Inténtalo de nuevo.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => ref.invalidate(_categoriesProvider),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesCarousel extends StatelessWidget {
  const _FavoritesCarousel({required this.favorites});
  final List<FavoriteEntity> favorites;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: favorites.length,
        itemExtent: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (_, i) => _FavoriteChip(streamId: favorites[i].streamId),
      ),
    );
  }
}

class _FavoriteChip extends ConsumerWidget {
  const _FavoriteChip({required this.streamId});
  final int streamId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: InkWell(
        onTap: () => context.push('/player/$streamId'),
        child: Container(
          width: 72,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.live_tv, size: 32),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});
  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.category),
      title: Text(category.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/category/${category.id}'),
    );
  }
}
