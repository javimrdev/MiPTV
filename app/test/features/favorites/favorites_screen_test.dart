import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/favorites/domain/favorite_category_entity.dart';
import 'package:miptv/features/favorites/domain/favorite_entity.dart';
import 'package:miptv/features/favorites/domain/favorite_repository.dart';
import 'package:miptv/features/favorites/presentation/favorites_screen.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';
import 'package:miptv/features/streams/domain/stream_repository.dart';

import '../../support/l10n_test_app.dart';
import '../../support/responsive_test_helpers.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

class MockStreamRepository extends Mock implements StreamRepository {}

void main() {
  testWidgets('hydrates favorites with stream name via getStreamsByIds', (
    tester,
  ) async {
    final favoriteRepo = MockFavoriteRepository();
    final streamRepo = MockStreamRepository();

    when(
      () => favoriteRepo.getFavoriteCategories(),
    ).thenAnswer((_) async => []);
    when(() => favoriteRepo.getFavorites()).thenAnswer(
      (_) async => [FavoriteEntity(streamId: 101, createdAt: DateTime(2024))],
    );
    when(() => streamRepo.getStreamsByIds([101])).thenAnswer(
      (_) async => const [
        StreamEntity(
          id: 101,
          name: 'Canal Deportes',
          logo: '',
          categoryId: '1',
          extension: 'ts',
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoriteRepositoryProvider.overrideWithValue(favoriteRepo),
          streamRepositoryProvider.overrideWithValue(streamRepo),
        ],
        child: testApp(home: const FavoritesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Canal Deportes'), findsOneWidget);
    verify(() => streamRepo.getStreamsByIds([101])).called(1);
  });

  testWidgets('shows favorite categories under the "Categories" section', (
    tester,
  ) async {
    final favoriteRepo = MockFavoriteRepository();
    final streamRepo = MockStreamRepository();

    when(() => favoriteRepo.getFavoriteCategories()).thenAnswer(
      (_) async => [
        FavoriteCategoryEntity(
          categoryId: '7',
          name: 'Deportes',
          createdAt: DateTime(2024),
        ),
      ],
    );
    when(() => favoriteRepo.getFavorites()).thenAnswer((_) async => []);
    when(() => streamRepo.getStreamsByIds([])).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoriteRepositoryProvider.overrideWithValue(favoriteRepo),
          streamRepositoryProvider.overrideWithValue(streamRepo),
        ],
        child: testApp(home: const FavoritesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Deportes'), findsOneWidget);
  });

  testWidgets('shows empty message when there are no favorites', (
    tester,
  ) async {
    final favoriteRepo = MockFavoriteRepository();
    final streamRepo = MockStreamRepository();

    when(
      () => favoriteRepo.getFavoriteCategories(),
    ).thenAnswer((_) async => []);
    when(() => favoriteRepo.getFavorites()).thenAnswer((_) async => []);
    when(() => streamRepo.getStreamsByIds([])).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoriteRepositoryProvider.overrideWithValue(favoriteRepo),
          streamRepositoryProvider.overrideWithValue(streamRepo),
        ],
        child: testApp(home: const FavoritesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('You have no favorites'), findsOneWidget);
  });

  testWidgets(
    'caps content width on tablet but stays a CustomScrollView (no grid)',
    (tester) async {
      setTabletViewport(tester);
      final favoriteRepo = MockFavoriteRepository();
      final streamRepo = MockStreamRepository();

      when(() => favoriteRepo.getFavoriteCategories()).thenAnswer(
        (_) async => [
          FavoriteCategoryEntity(
            categoryId: '7',
            name: 'Deportes',
            createdAt: DateTime(2024),
          ),
        ],
      );
      when(() => favoriteRepo.getFavorites()).thenAnswer((_) async => []);
      when(() => streamRepo.getStreamsByIds([])).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            favoriteRepositoryProvider.overrideWithValue(favoriteRepo),
            streamRepositoryProvider.overrideWithValue(streamRepo),
          ],
          child: testApp(home: const FavoritesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
      final width = tester.getSize(find.byType(CustomScrollView)).width;
      expect(width, lessThanOrEqualTo(960));
    },
  );
}
