import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/app/router.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/favorites/domain/favorite_repository.dart';
import 'package:miptv/features/provider/domain/iptv_provider_repository.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';
import 'package:miptv/features/streams/domain/stream_repository.dart';

class MockProviderRepository extends Mock implements IPTVProviderRepository {}

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

class MockStreamRepository extends Mock implements StreamRepository {}

void main() {
  late MockProviderRepository providerRepo;
  late MockFavoriteRepository favoriteRepo;
  late MockStreamRepository streamRepo;

  setUp(() {
    providerRepo = MockProviderRepository();
    favoriteRepo = MockFavoriteRepository();
    streamRepo = MockStreamRepository();

    when(() => providerRepo.getProvider()).thenAnswer(
      (_) async => const ProviderEntity(id: 1, server: 'http://x.tv', username: 'u'),
    );
    when(() => favoriteRepo.getFavorites()).thenAnswer((_) async => []);
    when(() => favoriteRepo.isFavorite(any())).thenAnswer((_) async => false);
    when(() => favoriteRepo.getFavoriteCategories())
        .thenAnswer((_) async => []);
    when(() => favoriteRepo.isFavoriteCategory(any()))
        .thenAnswer((_) async => false);
    when(() => streamRepo.getStreamsByIds(any())).thenAnswer((_) async => []);
    when(() => streamRepo.getStreamsForCategory('1')).thenAnswer(
      (_) async => const [
        StreamEntity(id: 9, name: 'Canal 1', logo: '', categoryId: '1', extension: 'ts'),
      ],
    );
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        providerRepositoryProvider.overrideWithValue(providerRepo),
        favoriteRepositoryProvider.overrideWithValue(favoriteRepo),
        streamRepositoryProvider.overrideWithValue(streamRepo),
        categoriesProvider.overrideWith(
          (ref) => Future.value(const [CategoryEntity(id: '1', name: 'Deportes')]),
        ),
      ],
      child: MaterialApp.router(routerConfig: createAppRouter()),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('shell renders bottom bar and switches between tabs',
      (tester) async {
    await pumpApp(tester);

    // Splash → Home, with the bottom NavigationBar.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Deportes'), findsOneWidget);

    // Favoritos tab.
    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();
    expect(find.text('No tienes favoritos'), findsOneWidget);

    // Ajustes tab.
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    expect(find.text('Configuración'), findsOneWidget);
  });

  testWidgets('drilling into a category hides the bottom bar', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Deportes'));
    await tester.pumpAndSettle();

    expect(find.text('Canales'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
