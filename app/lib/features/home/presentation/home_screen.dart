import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/widgets/skeleton.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/home/domain/apply_home_filters.dart';
import 'package:miptv/features/home/presentation/home_filters_provider.dart';
import 'package:miptv/features/home/presentation/widgets/home_filters_bar.dart';

/// Whether a given category id is in favorites. Family-keyed so each tile
/// observes only its own state and rebuilds independently.
final _categoryFavoriteToggleProvider =
    FutureProvider.family<bool, String>((ref, categoryId) {
  return ref.watch(favoriteRepositoryProvider).isFavoriteCategory(categoryId);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerAsync = ref.watch(providerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MiPTV')),
      body: providerAsync.when(
        data: (provider) =>
            provider == null ? const _NoProviderView() : const _CategoriesList(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const _NoProviderView(),
      ),
    );
  }
}

class _NoProviderView extends StatelessWidget {
  const _NoProviderView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.live_tv, size: 56),
            const SizedBox(height: 16),
            const Text(
              'Aún no has añadido ningún proveedor IPTV.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Añadir proveedor'),
              onPressed: () => context.push('/add-provider'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesList extends ConsumerStatefulWidget {
  const _CategoriesList();

  @override
  ConsumerState<_CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends ConsumerState<_CategoriesList> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Column(
      children: [
        const SizedBox(height: 8),
        const HomeFiltersBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Buscar categorías…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                    ),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
        ),
        Expanded(
          child: categoriesAsync.when(
            data: (cats) {
              // Pill filters first (mocked pass-through), then text search.
              final byFilters =
                  applyHomeFilters(cats, ref.watch(homeFiltersProvider));
              final filtered = _query.isEmpty
                  ? byFilters
                  : byFilters
                      .where((c) =>
                          c.name.toLowerCase().contains(_query.toLowerCase()))
                      .toList();
              if (filtered.isEmpty) {
                return const Center(child: Text('Sin resultados.'));
              }
              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) => _CategoryTile(category: filtered[i]),
              );
            },
            loading: () => const SkeletonList.categories(),
            error: (e, _) => Center(
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
                      onPressed: () => ref.invalidate(categoriesProvider),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends ConsumerWidget {
  const _CategoryTile({required this.category});
  final CategoryEntity category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavAsync = ref.watch(_categoryFavoriteToggleProvider(category.id));

    return ListTile(
      leading: const Icon(Icons.category),
      title: Text(category.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isFavAsync.maybeWhen(
            data: (isFav) => IconButton(
              icon: Icon(isFav ? Icons.star : Icons.star_border),
              tooltip: isFav ? 'Quitar de favoritos' : 'Añadir a favoritos',
              onPressed: () async {
                final repo = ref.read(favoriteRepositoryProvider);
                if (isFav) {
                  await repo.removeFavoriteCategory(category.id);
                } else {
                  await repo.addFavoriteCategory(category.id, category.name);
                }
                ref.invalidate(_categoryFavoriteToggleProvider(category.id));
              },
            ),
            orElse: () => const SizedBox.square(dimension: 48),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => context.push('/category/${category.id}'),
    );
  }
}
