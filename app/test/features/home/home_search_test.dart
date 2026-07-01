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

  List<Override> overridesWith(List<CategoryEntity> categories) {
    const provider =
        ProviderEntity(id: 1, name: 'Main', server: 'http://x.tv', username: 'u');
    return [
      providerProvider.overrideWith((ref) => Future.value(provider)),
      providersListProvider.overrideWith((ref) => Future.value(const [provider])),
      categoriesProvider.overrideWith((ref) => Future.value(categories)),
    ];
  }

  const categories = [
    CategoryEntity(id: '1', name: 'Deportes'),
    CategoryEntity(id: '2', name: 'Noticias'),
    CategoryEntity(id: '3', name: 'Cine'),
  ];

  testWidgets('filters categories by name as the user types', (tester) async {
    await tester.pumpWidget(wrap(overridesWith(categories)));
    await tester.pumpAndSettle();

    expect(find.text('Deportes'), findsOneWidget);
    expect(find.text('Noticias'), findsOneWidget);
    expect(find.text('Cine'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'noti');
    await tester.pumpAndSettle();

    expect(find.text('Noticias'), findsOneWidget);
    expect(find.text('Deportes'), findsNothing);
    expect(find.text('Cine'), findsNothing);
  });

  testWidgets('clearing the query restores the full list', (tester) async {
    await tester.pumpWidget(wrap(overridesWith(categories)));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'cine');
    await tester.pumpAndSettle();
    expect(find.text('Deportes'), findsNothing);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    expect(find.text('Deportes'), findsOneWidget);
    expect(find.text('Noticias'), findsOneWidget);
    expect(find.text('Cine'), findsOneWidget);
  });

  testWidgets('shows "No results." when nothing matches', (tester) async {
    await tester.pumpWidget(wrap(overridesWith(categories)));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();

    expect(find.text('No results.'), findsOneWidget);
    expect(find.text('Deportes'), findsNothing);
  });
}
