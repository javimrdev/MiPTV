import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/core/widgets/glass/glass_surface.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

/// List tile for a VOD movie. Tapping opens the player with the `movie` URL.
class MovieTile extends StatelessWidget {
  const MovieTile({super.key, required this.movie});
  final StreamEntity movie;

  @override
  Widget build(BuildContext context) {
    return GlassTileBackground(
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: movie.logo,
          width: 48,
          height: 48,
          fit: BoxFit.contain,
          placeholder: (_, __) =>
              const SizedBox.square(dimension: 48, child: Icon(Icons.movie)),
          errorWidget: (_, __, ___) => const Icon(Icons.movie),
        ),
        title: Text(movie.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: () => context.push(
          '/player/${movie.id}?ext=${movie.extension}&type=movie',
        ),
      ),
    );
  }
}
