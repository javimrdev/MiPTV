import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/home/domain/apply_home_filters.dart';
import 'package:miptv/features/home/domain/custom_filter_repository.dart';
import 'package:miptv/features/home/domain/home_filters.dart';
import 'package:miptv/features/home/presentation/home_screen.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';

/// In-memory [CustomFilterRepository] so tests don't touch Isar.
class _FakeCustomFilterRepository implements CustomFilterRepository {
  _FakeCustomFilterRepository([Map<HomeFilterType, List<String>>? seed])
      : _store = {
          for (final t in HomeFilterType.values) t: [...?seed?[t]],
        };

  final Map<HomeFilterType, List<String>> _store;

  @override
  Future<List<String>> getValues(HomeFilterType type) async => _store[type]!;

  @override
  Future<void> add(HomeFilterType type, String value) async =>
      _store[type]!.add(value.trim());

  @override
  Future<void> remove(HomeFilterType type, String value) async =>
      _store[type]!.remove(value);
}

void main() {
  Widget wrap(List<Override> overrides) => ProviderScope(
        overrides: overrides,
        child: const MaterialApp(home: HomeScreen()),
      );

  List<Override> baseOverrides({CustomFilterRepository? repo}) => [
        providerProvider.overrideWith(
          (ref) => Future.value(
            const ProviderEntity(id: 1, server: 'http://x.tv', username: 'u'),
          ),
        ),
        categoriesProvider.overrideWith(
          (ref) => Future.value(const [CategoryEntity(id: '1', name: 'Deportes')]),
        ),
        customFilterRepositoryProvider
            .overrideWithValue(repo ?? _FakeCustomFilterRepository()),
      ];

  testWidgets('selecting a Quality value labels the pill and shows reset',
      (tester) async {
    await tester.pumpWidget(wrap(baseOverrides()));
    await tester.pumpAndSettle();

    // No filter selected → no reset pill.
    expect(find.text('Quality'), findsOneWidget);
    expect(find.text('Borrar'), findsNothing);

    await tester.tap(find.text('Quality'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HD'));
    await tester.pumpAndSettle();

    expect(find.text('Quality: HD'), findsOneWidget);
    expect(find.text('Borrar'), findsOneWidget);

    // Reset clears every dimension.
    await tester.tap(find.text('Borrar'));
    await tester.pumpAndSettle();

    expect(find.text('Quality: HD'), findsNothing);
    expect(find.text('Quality'), findsOneWidget);
    expect(find.text('Borrar'), findsNothing);
  });

  testWidgets('custom persisted values appear as pill options', (tester) async {
    final repo = _FakeCustomFilterRepository({
      HomeFilterType.quality: ['8K'],
    });
    await tester.pumpWidget(wrap(baseOverrides(repo: repo)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quality'));
    await tester.pumpAndSettle();

    // Predefined + custom both offered.
    expect(find.text('UHD'), findsOneWidget);
    expect(find.text('8K'), findsOneWidget);
  });

  group('applyHomeFilters country matching', () {
    const cats = [
      CategoryEntity(id: '1', name: 'ES| Deportes'),
      CategoryEntity(id: '2', name: 'ES | Cine'),
      CategoryEntity(id: '3', name: 'PT| Desporto'),
      CategoryEntity(id: '4', name: 'Sin prefijo'),
    ];

    test('null country filter leaves the list untouched', () {
      expect(applyHomeFilters(cats, const HomeFilters()), cats);
    });

    test('keeps only categories prefixed with the selected country code', () {
      final result = applyHomeFilters(
        cats,
        const HomeFilters(country: 'Spain'),
      );
      expect(result.map((c) => c.id), ['1', '2']);
    });

    test('trims spaces around the "{iso}|" prefix', () {
      // "ES | Cine" must still match Spain.
      final result = applyHomeFilters(
        cats,
        const HomeFilters(country: 'Spain'),
      );
      expect(result.any((c) => c.id == '2'), isTrue);
    });

    test('excludes categories without a "|" prefix when filtering', () {
      final result = applyHomeFilters(
        cats,
        const HomeFilters(country: 'Spain'),
      );
      expect(result.any((c) => c.name == 'Sin prefijo'), isFalse);
    });

    test('custom (non-predefined) country value is matched as a raw code', () {
      const custom = [CategoryEntity(id: '9', name: 'XX| Custom')];
      final result = applyHomeFilters(
        custom,
        const HomeFilters(country: 'xx'),
      );
      expect(result.map((c) => c.id), ['9']);
    });
  });
}
