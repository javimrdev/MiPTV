import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/widgets/skeleton.dart';
import 'package:miptv/features/movies/presentation/movie_tile.dart';

class MovieCategoryScreen extends ConsumerWidget {
  const MovieCategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(vodCategoryMoviesProvider(categoryId));

    return Scaffold(
      appBar: AppBar(title: const Text('Películas')),
      body: moviesAsync.when(
        data: (movies) => movies.isEmpty
            ? const Center(child: Text('No hay películas en esta categoría.'))
            : ListView.builder(
                itemCount: movies.length,
                itemExtent: 72,
                itemBuilder: (_, i) => MovieTile(movie: movies[i]),
              ),
        loading: () => const SkeletonList.movies(),
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
                      ref.invalidate(vodCategoryMoviesProvider(categoryId)),
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
