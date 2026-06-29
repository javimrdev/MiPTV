import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/categories/presentation/category_screen.dart';
import 'package:miptv/features/epg/domain/epg_entity.dart';
import 'package:miptv/features/epg/domain/epg_repository.dart';
import 'package:miptv/features/favorites/domain/favorite_repository.dart';
import 'package:miptv/features/streams/domain/stream_entity.dart';
import 'package:miptv/features/streams/domain/stream_repository.dart';

class MockStreamRepository extends Mock implements StreamRepository {}

class MockEpgRepository extends Mock implements EpgRepository {}

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late MockStreamRepository streamRepo;
  late MockEpgRepository epgRepo;
  late MockFavoriteRepository favRepo;

  const stream = StreamEntity(
    id: 1,
    name: 'Canal Uno',
    logo: '',
    categoryId: 'cat',
    extension: 'ts',
  );

  setUp(() {
    streamRepo = MockStreamRepository();
    epgRepo = MockEpgRepository();
    favRepo = MockFavoriteRepository();

    when(() => streamRepo.getStreamsForCategory(any()))
        .thenAnswer((_) async => [stream]);
    when(() => favRepo.isFavorite(any())).thenAnswer((_) async => false);

    final now = DateTime.now();
    when(() => epgRepo.getNowNext(any())).thenAnswer(
      (_) async => ChannelEpg(
        now: EpgProgram(
          title: 'Telediario',
          start: now.subtract(const Duration(minutes: 10)),
          end: now.add(const Duration(minutes: 20)),
        ),
        next: EpgProgram(
          title: 'El Tiempo',
          start: now.add(const Duration(minutes: 20)),
          end: now.add(const Duration(minutes: 30)),
        ),
      ),
    );
  });

  Widget wrap() => ProviderScope(
        overrides: [
          streamRepositoryProvider.overrideWithValue(streamRepo),
          epgRepositoryProvider.overrideWithValue(epgRepo),
          favoriteRepositoryProvider.overrideWithValue(favRepo),
        ],
        child: const MaterialApp(home: CategoryScreen(categoryId: 'cat')),
      );

  testWidgets('defaults to Lista view; EPG lines are not shown', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Canal Uno'), findsOneWidget);
    expect(find.textContaining('Telediario'), findsNothing);
    verifyNever(() => epgRepo.getNowNext(any()));
  });

  testWidgets('switching to Guía shows now/next program lines', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guía'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Ahora'), findsOneWidget);
    expect(find.textContaining('Telediario'), findsOneWidget);
    expect(find.textContaining('Después'), findsOneWidget);
    expect(find.textContaining('El Tiempo'), findsOneWidget);
  });
}
