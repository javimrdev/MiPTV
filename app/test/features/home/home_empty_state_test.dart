import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/home/presentation/home_screen.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';

import '../../support/l10n_test_app.dart';

void main() {
  Widget wrap(List<Override> overrides) => ProviderScope(
        overrides: overrides,
        child: testApp(home: const HomeScreen()),
      );

  testWidgets('shows "Add provider" when no provider configured',
      (tester) async {
    await tester.pumpWidget(wrap([
      providerProvider.overrideWith((ref) => Future.value(null)),
      providersListProvider.overrideWith((ref) => Future.value(const [])),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Add provider'), findsOneWidget);
  });

  testWidgets('shows category list when a provider is configured',
      (tester) async {
    const provider =
        ProviderEntity(id: 1, name: 'Main', server: 'http://x.tv', username: 'u');
    await tester.pumpWidget(wrap([
      providerProvider.overrideWith((ref) => Future.value(provider)),
      providersListProvider.overrideWith((ref) => Future.value(const [provider])),
      categoriesProvider.overrideWith(
        (ref) => Future.value(const [CategoryEntity(id: '1', name: 'Deportes')]),
      ),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Add provider'), findsNothing);
    expect(find.text('Deportes'), findsOneWidget);
  });
}
