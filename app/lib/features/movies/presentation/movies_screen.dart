import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/responsive/content_width_cap.dart';
import 'package:miptv/core/responsive/grid_delegates.dart';
import 'package:miptv/core/responsive/responsive_context.dart';
import 'package:miptv/core/widgets/adaptive_scaffold.dart';
import 'package:miptv/core/widgets/crystal_search_field.dart';
import 'package:miptv/core/widgets/skeleton.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/movies/presentation/movie_grid_tile.dart';
import 'package:miptv/features/movies/presentation/movie_tile.dart';
import 'package:miptv/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    final providerAsync = ref.watch(providerProvider);

    return AppScaffold(
      title: Text(l10n.movies),
      body: providerAsync.when(
        data: (provider) {
          if (provider == null) return const _NoProviderView();
          return Column(
            children: [
              ContentWidthCap(
                maxWidth: 720,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CrystalSearchField(
                    controller: _controller,
                    hintText: l10n.searchMoviesHint,
                    showClear: _query.isNotEmpty,
                    onClear: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                    onChanged: (v) => setState(() => _query = v.trim()),
                  ),
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
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(vodCategoriesProvider);

    return categoriesAsync.when(
      data: (cats) => ContentWidthCap(
        maxWidth: 720,
        child: ListView.builder(
          itemCount: cats.length,
          itemBuilder: (_, i) => _CategoryTile(category: cats[i]),
        ),
      ),
      loading: () => const SkeletonList.categories(),
      error: (e, _) => _ErrorView(
        message: e is AppError ? e.userMessage(l10n) : l10n.errorUnexpected,
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
    final l10n = AppLocalizations.of(context);
    final resultsAsync = ref.watch(vodSearchProvider(query));

    return resultsAsync.when(
      data: (movies) => movies.isEmpty
          ? Center(child: Text(l10n.noResults))
          : context.isTablet
          ? GridView.builder(
              gridDelegate: postersGridDelegate(),
              itemCount: movies.length,
              itemBuilder: (_, i) => MovieGridTile(movie: movies[i]),
            )
          : ListView.builder(
              itemCount: movies.length,
              itemExtent: 72,
              itemBuilder: (_, i) => MovieTile(movie: movies[i]),
            ),
      loading: () =>
          context.isTablet ? const SkeletonGrid() : const SkeletonList.movies(),
      error: (e, _) => _ErrorView(
        message: e is AppError ? e.userMessage(l10n) : l10n.errorUnexpected,
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
            FilledButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).retry),
            ),
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
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.movie_outlined, size: 56),
            const SizedBox(height: 16),
            Text(l10n.moviesNoProvider, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l10n.addProvider),
              onPressed: () => context.push('/add-provider'),
            ),
          ],
        ),
      ),
    );
  }
}
