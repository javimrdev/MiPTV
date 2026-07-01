import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/home/presentation/home_screen.dart';
import 'package:miptv/features/provider/domain/iptv_provider_repository.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';
import 'package:miptv/features/settings/application/locale_controller.dart';
import 'package:miptv/features/settings/presentation/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/l10n_test_app.dart';

/// In-memory [IPTVProviderRepository] that mimics [XtreamProviderRepository]'s
/// active-provider semantics (without touching Isar), so tests can drive the
/// real add/switch/remove flow instead of stubbing each method independently.
class FakeProviderRepository implements IPTVProviderRepository {
  final List<ProviderEntity> providers = [];
  int? activeId;
  int syncCallCount = 0;

  /// The active provider id at the moment each [syncCategories] call
  /// happened — lets tests assert *which* source got (re-)synced.
  final List<int?> syncedForActiveId = [];

  @override
  Future<ProviderEntity> addProvider({
    required String name,
    required String server,
    required String username,
    required String password,
  }) async {
    final entity = ProviderEntity(
      id: providers.length + 1,
      name: name,
      server: server,
      username: username,
    );
    providers.add(entity);
    activeId = entity.id;
    return entity;
  }

  @override
  Future<List<ProviderEntity>> getProviders() async => providers;

  @override
  Future<ProviderEntity?> getProvider() async {
    for (final p in providers) {
      if (p.id == activeId) return p;
    }
    return null;
  }

  @override
  Future<void> switchProvider(int id) async {
    if (providers.any((p) => p.id == id)) activeId = id;
  }

  @override
  Future<void> removeProvider(int id) async {
    providers.removeWhere((p) => p.id == id);
    if (activeId != id) return;
    activeId = providers.isEmpty ? null : providers.first.id;
  }

  @override
  Future<List<CategoryEntity>> syncCategories() async {
    syncCallCount++;
    syncedForActiveId.add(activeId);
    return [];
  }
}

void main() {
  late FakeProviderRepository repo;

  setUp(() {
    repo = FakeProviderRepository()
      ..providers.addAll(const [
        ProviderEntity(id: 1, name: 'Source A', server: 'http://a.tv', username: 'a'),
        ProviderEntity(id: 2, name: 'Source B', server: 'http://b.tv', username: 'b'),
      ])
      ..activeId = 1;
  });

  Future<SharedPreferences> mockPrefs() async {
    SharedPreferences.setMockInitialValues({});
    return SharedPreferences.getInstance();
  }

  testWidgets(
      'switching to a different source in the Home drawer calls switchProvider and re-syncs',
      (tester) async {
    final prefs = await mockPrefs();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        providerRepositoryProvider.overrideWithValue(repo),
        categoriesProvider.overrideWith((ref) => Future.value(const [])),
      ],
      child: testApp(home: const HomeScreen()),
    ));
    await tester.pumpAndSettle();

    // Open the burger drawer and switch to the non-active source.
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Source B'), findsOneWidget);

    await tester.tap(find.text('Source B'));
    await tester.pumpAndSettle();

    expect(repo.activeId, 2);
    expect(repo.syncCallCount, 1);
    expect(repo.syncedForActiveId.single, 2);
  });

  testWidgets(
      'removing the active source in Settings re-syncs the newly active one',
      (tester) async {
    final prefs = await mockPrefs();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        providerRepositoryProvider.overrideWithValue(repo),
      ],
      child: testApp(home: const SettingsScreen()),
    ));
    await tester.pumpAndSettle();

    // Remove the currently-active source ("Source A"): the repository falls
    // back to "Source B" as active, and the fix must re-sync it right away
    // instead of leaving Home on an empty, stale category list.
    final removeButtons = find.widgetWithText(TextButton, 'Remove');
    await tester.tap(removeButtons.first);
    await tester.pumpAndSettle();

    expect(repo.activeId, 2);
    expect(repo.syncCallCount, 1);
    expect(repo.syncedForActiveId.single, 2);
  });

  testWidgets('removing a non-active source does not trigger a re-sync',
      (tester) async {
    final prefs = await mockPrefs();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        providerRepositoryProvider.overrideWithValue(repo),
      ],
      child: testApp(home: const SettingsScreen()),
    ));
    await tester.pumpAndSettle();

    final removeButtons = find.widgetWithText(TextButton, 'Remove');
    await tester.tap(removeButtons.last); // "Source B", not active.
    await tester.pumpAndSettle();

    expect(repo.activeId, 1);
    expect(repo.syncCallCount, 0);
  });
}
