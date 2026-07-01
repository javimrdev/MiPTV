import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/widgets/glass/glass_surface.dart';
import 'package:miptv/features/movies/presentation/movie_category_screen.dart';
import 'package:miptv/features/movies/presentation/movie_grid_tile.dart';
import 'package:miptv/features/movies/presentation/movie_tile.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';

import '../../support/l10n_test_app.dart';
import '../../support/responsive_test_helpers.dart';

void main() {
  const movies = [
    StreamEntity(
      id: 1,
      name: 'Movie One',
      logo: '',
      categoryId: 'cat',
      extension: 'mp4',
    ),
    StreamEntity(
      id: 2,
      name: 'Movie Two',
      logo: '',
      categoryId: 'cat',
      extension: 'mp4',
    ),
  ];

  Widget wrap() => ProviderScope(
    overrides: [
      vodCategoryMoviesProvider(
        'cat',
      ).overrideWith((ref) => Future.value(movies)),
    ],
    child: testApp(home: const MovieCategoryScreen(categoryId: 'cat')),
  );

  testWidgets('shows a ListView of MovieTile at phone width', (tester) async {
    setPhoneViewport(tester);
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(GridView), findsNothing);
    expect(find.byType(MovieTile), findsNWidgets(2));
  });

  testWidgets('shows a GridView of MovieGridTile at tablet width', (
    tester,
  ) async {
    setTabletViewport(tester);
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(MovieGridTile), findsNWidgets(2));
  });

  testWidgets(
    'composes tablet grid with iOS glass chrome (GlassGridTileBackground '
    'renders its frosted Container, not a plain pass-through)',
    (tester) async {
      setTabletViewport(tester);
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await tester.pumpWidget(wrap());
        await tester.pumpAndSettle();

        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(GlassGridTileBackground), findsNWidgets(2));
        // Only the iOS-glass branch of GlassGridTileBackground wraps its
        // child in a Container; the Android branch returns it untouched.
        final glassContainer = find.descendant(
          of: find.byType(GlassGridTileBackground).first,
          matching: find.byType(Container),
        );
        expect(glassContainer, findsOneWidget);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );
}
