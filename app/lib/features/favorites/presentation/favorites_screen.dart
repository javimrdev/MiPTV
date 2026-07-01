import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/responsive/content_width_cap.dart';
import 'package:miptv/core/widgets/adaptive_scaffold.dart';
import 'package:miptv/core/widgets/glass/glass_surface.dart';
import 'package:miptv/features/favorites/domain/favorite_category_entity.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';
import 'package:miptv/l10n/app_localizations.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final viewAsync = ref.watch(favoritesViewProvider);

    return AppScaffold(
      title: Text(l10n.favorites),
      extendBehindNavBar: true,
      body: viewAsync.when(
        data: (data) {
          final (categories, favorites, byId) = data;
          if (categories.isEmpty && favorites.isEmpty) {
            return Center(child: Text(l10n.favoritesEmpty));
          }
          return ContentWidthCap(
            maxWidth: 960,
            child: CustomScrollView(
              slivers: [
                if (categories.isNotEmpty) ...[
                  _SectionHeader(l10n.categories),
                  SliverFixedExtentList.builder(
                    itemExtent: 72,
                    itemCount: categories.length,
                    itemBuilder: (_, i) =>
                        _FavoriteCategoryTile(category: categories[i]),
                  ),
                ],
                if (favorites.isNotEmpty) ...[
                  _SectionHeader(l10n.channels),
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
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.favoritesLoadError)),
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
        child: Text(title, style: Theme.of(context).textTheme.titleSmall),
      ),
    );
  }
}

class _FavoriteCategoryTile extends ConsumerWidget {
  const _FavoriteCategoryTile({required this.category});

  final FavoriteCategoryEntity category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassTileBackground(
      child: ListTile(
        leading: const Icon(Icons.category),
        title: Text(
          category.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.star),
          tooltip: AppLocalizations.of(context).removeFromFavorites,
          onPressed: () async {
            await ref
                .read(favoriteRepositoryProvider)
                .removeFavoriteCategory(category.categoryId);
            ref.invalidate(favoritesViewProvider);
          },
        ),
        onTap: () => context.push('/category/${category.categoryId}'),
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
    return GlassTileBackground(
      child: ListTile(
        leading: s == null
            ? const SizedBox.square(dimension: 48, child: Icon(Icons.live_tv))
            : CachedNetworkImage(
                imageUrl: s.logo,
                width: 48,
                height: 48,
                fit: BoxFit.contain,
                placeholder: (_, __) => const SizedBox.square(
                  dimension: 48,
                  child: Icon(Icons.live_tv),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.live_tv),
              ),
        title: Text(
          s?.name ?? AppLocalizations.of(context).channelFallbackName(streamId),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.star),
          tooltip: AppLocalizations.of(context).removeFromFavorites,
          onPressed: () async {
            await ref.read(favoriteRepositoryProvider).removeFavorite(streamId);
            ref.invalidate(favoritesViewProvider);
          },
        ),
        onTap: s == null
            ? null
            : () => context.push('/player/${s.id}?ext=${s.extension}'),
      ),
    );
  }
}
