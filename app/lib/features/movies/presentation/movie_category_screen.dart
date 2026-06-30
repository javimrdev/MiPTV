import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/widgets/adaptive_scaffold.dart';
import 'package:miptv/core/widgets/skeleton.dart';
import 'package:miptv/features/movies/presentation/movie_tile.dart';
import 'package:miptv/l10n/app_localizations.dart';

class MovieCategoryScreen extends ConsumerWidget {
  const MovieCategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final moviesAsync = ref.watch(vodCategoryMoviesProvider(categoryId));

    return AppScaffold(
      title: Text(l10n.movies),
      body: moviesAsync.when(
        data: (movies) => movies.isEmpty
            ? Center(child: Text(l10n.movieCategoryEmpty))
            : ListView.builder(
                itemCount: movies.length,
                itemExtent: 72,
                itemBuilder: (_, i) => MovieTile(movie: movies[i]),
              ),
        loading: () => const SkeletonList.movies(),
        error: (e, _) {
          final msg = e is AppError ? e.userMessage(l10n) : l10n.errorUnexpected;
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
                      ref.invalidate(vodCategoryMoviesProvider(categoryId)),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
