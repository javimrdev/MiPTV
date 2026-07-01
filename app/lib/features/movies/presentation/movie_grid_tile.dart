import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/core/widgets/glass/glass_surface.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

/// Grid card for a VOD movie, shown on tablet-width screens instead of
/// [MovieTile]'s list row. Same tap target as [MovieTile].
///
/// `movie.logo` is shared with live-channel logos under one generic field
/// name and today is rendered as a square 48x48 icon
/// (`BoxFit.contain`) — real poster art from the provider isn't guaranteed.
/// `BoxFit.cover` inside a fixed-size box degrades gracefully whether the
/// provider serves square icons or portrait posters; tune the exact aspect
/// ratio during on-device QA against a real Xtream account.
class MovieGridTile extends StatelessWidget {
  const MovieGridTile({super.key, required this.movie});
  final StreamEntity movie;

  @override
  Widget build(BuildContext context) {
    return GlassGridTileBackground(
      child: InkWell(
        onTap: () => context.push(
          '/player/${movie.id}?ext=${movie.extension}&type=movie',
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: movie.logo,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const ColoredBox(
                    color: Colors.black12,
                    child: Center(child: Icon(Icons.movie)),
                  ),
                  errorWidget: (_, _, _) => const ColoredBox(
                    color: Colors.black12,
                    child: Center(child: Icon(Icons.movie)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                movie.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
