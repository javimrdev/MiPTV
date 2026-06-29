import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/home/domain/custom_filter_repository.dart';
import 'package:miptv/features/home/domain/home_filters.dart';
import 'package:miptv/features/settings/presentation/filters_settings_screen.dart';

/// In-memory [CustomFilterRepository] standing in for the Isar-backed one.
class _FakeCustomFilterRepository implements CustomFilterRepository {
  final Map<HomeFilterType, List<String>> _store = {
    for (final t in HomeFilterType.values) t: <String>[],
  };

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
  testWidgets('adding then removing a custom Quality filter persists via repo',
      (tester) async {
    final repo = _FakeCustomFilterRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [customFilterRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: FiltersSettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Quality is the first section.
    await tester.enterText(find.byType(TextField).first, '8K');
    await tester.tap(find.text('Añadir').first);
    await tester.pumpAndSettle();

    expect(repo.getValues(HomeFilterType.quality), completion(contains('8K')));
    expect(find.text('8K'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();

    expect(find.text('8K'), findsNothing);
  });
}
