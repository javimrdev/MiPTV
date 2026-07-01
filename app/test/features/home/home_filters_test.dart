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

import '../../support/l10n_test_app.dart';

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
        child: testApp(home: const HomeScreen()),
      );

  List<Override> baseOverrides({CustomFilterRepository? repo}) {
    const provider =
        ProviderEntity(id: 1, name: 'Main', server: 'http://x.tv', username: 'u');
    return [
      providerProvider.overrideWith((ref) => Future.value(provider)),
      providersListProvider.overrideWith((ref) => Future.value(const [provider])),
      categoriesProvider.overrideWith(
        (ref) => Future.value(const [CategoryEntity(id: '1', name: 'Deportes')]),
      ),
      customFilterRepositoryProvider
          .overrideWithValue(repo ?? _FakeCustomFilterRepository()),
    ];
  }

  testWidgets('selecting a Quality value labels the pill and shows reset',
      (tester) async {
    await tester.pumpWidget(wrap(baseOverrides()));
    await tester.pumpAndSettle();

    // No filter selected → no reset pill.
    expect(find.text('Quality'), findsOneWidget);
    expect(find.text('Clear'), findsNothing);

    await tester.tap(find.text('Quality'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HD'));
    await tester.pumpAndSettle();

    expect(find.text('Quality: HD'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);

    // Reset clears every dimension.
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(find.text('Quality: HD'), findsNothing);
    expect(find.text('Quality'), findsOneWidget);
    expect(find.text('Clear'), findsNothing);
  });

  testWidgets('custom persisted values appear as pill options', (tester) async {
    final repo = _FakeCustomFilterRepository({
      HomeFilterType.quality: ['Dolby Vision'],
    });
    await tester.pumpWidget(wrap(baseOverrides(repo: repo)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quality'));
    await tester.pumpAndSettle();

    // Predefined + custom both offered.
    expect(find.text('SD'), findsOneWidget);
    expect(find.text('Dolby Vision'), findsOneWidget);
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

  group('applyHomeFilters quality/codec matching', () {
    const cats = [
      CategoryEntity(id: '1', name: 'Movies HD'),
      CategoryEntity(id: '2', name: 'Movies FHD'),
      CategoryEntity(id: '3', name: 'Movies UHD'),
      CategoryEntity(id: '4', name: 'Movies HEVC'),
      CategoryEntity(id: '5', name: 'Movies AV1'),
      CategoryEntity(id: '6', name: 'Sports'),
    ];

    test('null quality/codec filters leave the list untouched', () {
      expect(applyHomeFilters(cats, const HomeFilters()), cats);
    });

    test('"HD" matches only the exact HD tag, not FHD/UHD', () {
      final result = applyHomeFilters(cats, const HomeFilters(quality: 'HD'));
      expect(result.map((c) => c.id), ['1']);
    });

    test('"4K" matches the UHD alias', () {
      final result = applyHomeFilters(cats, const HomeFilters(quality: '4K'));
      expect(result.map((c) => c.id), ['3']);
    });

    test('"Full HD" matches the FHD alias', () {
      final result =
          applyHomeFilters(cats, const HomeFilters(quality: 'Full HD'));
      expect(result.map((c) => c.id), ['2']);
    });

    test('quality filter with no matches returns an empty list', () {
      final result = applyHomeFilters(cats, const HomeFilters(quality: '8K'));
      expect(result, isEmpty);
    });

    test('"HEVC" codec filter matches the HEVC tag', () {
      final result = applyHomeFilters(cats, const HomeFilters(codec: 'HEVC'));
      expect(result.map((c) => c.id), ['4']);
    });

    test('"AV1" codec filter matches the AV1 tag', () {
      final result = applyHomeFilters(cats, const HomeFilters(codec: 'AV1'));
      expect(result.map((c) => c.id), ['5']);
    });

    test('custom (non-predefined) quality value matches as a whole word', () {
      const custom = [CategoryEntity(id: '9', name: 'Movies Dolby Vision')];
      final result = applyHomeFilters(
        custom,
        const HomeFilters(quality: 'Dolby Vision'),
      );
      expect(result.map((c) => c.id), ['9']);
    });
  });
}
