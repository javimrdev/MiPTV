import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/movies/presentation/movie_tile.dart';

class MoviesScreen extends ConsumerStatefulWidget {
  const MoviesScreen({super.key});

  @override
  ConsumerState<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends ConsumerState<MoviesScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerAsync = ref.watch(providerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Películas')),
      body: providerAsync.when(
        data: (provider) {
          if (provider == null) return const _NoProviderView();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Buscar películas…',
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
                child: _query.isEmpty
                    ? const _CategoriesView()
                    : _SearchResultsView(query: _query),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const _NoProviderView(),
      ),
    );
  }
}

class _CategoriesView extends ConsumerWidget {
  const _CategoriesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(vodCategoriesProvider);

    return categoriesAsync.when(
      data: (cats) => ListView.builder(
        itemCount: cats.length,
        itemBuilder: (_, i) => _CategoryTile(category: cats[i]),
      ),
      loading: () => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Sincronizando catálogo…'),
          ],
        ),
      ),
      error: (e, _) => _ErrorView(
        message: e is AppError
            ? e.userMessage
            : 'Error inesperado. Inténtalo de nuevo.',
        onRetry: () => ref.invalidate(vodCategoriesProvider),
      ),
    );
  }
}

class _SearchResultsView extends ConsumerWidget {
  const _SearchResultsView({required this.query});
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(vodSearchProvider(query));

    return resultsAsync.when(
      data: (movies) => movies.isEmpty
          ? const Center(child: Text('Sin resultados.'))
          : ListView.builder(
              itemCount: movies.length,
              itemExtent: 72,
              itemBuilder: (_, i) => MovieTile(movie: movies[i]),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(
        message: e is AppError
            ? e.userMessage
            : 'Error inesperado. Inténtalo de nuevo.',
        onRetry: () => ref.invalidate(vodSearchProvider(query)),
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
      leading: const Icon(Icons.movie),
      title: Text(category.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/movies/category/${category.id}'),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.signal_wifi_off, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
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
            const Icon(Icons.movie_outlined, size: 56),
            const SizedBox(height: 16),
            const Text(
              'Añade un proveedor IPTV para ver películas.',
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
