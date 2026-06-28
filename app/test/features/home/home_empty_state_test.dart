import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/home/presentation/home_screen.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';

void main() {
  Widget wrap(List<Override> overrides) => ProviderScope(
        overrides: overrides,
        child: const MaterialApp(home: HomeScreen()),
      );

  testWidgets('shows "Añadir proveedor" when no provider configured',
      (tester) async {
    await tester.pumpWidget(wrap([
      providerProvider.overrideWith((ref) => Future.value(null)),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Añadir proveedor'), findsOneWidget);
  });

  testWidgets('shows category list when a provider is configured',
      (tester) async {
    await tester.pumpWidget(wrap([
      providerProvider.overrideWith(
        (ref) => Future.value(
          const ProviderEntity(id: 1, server: 'http://x.tv', username: 'u'),
        ),
      ),
      categoriesProvider.overrideWith(
        (ref) => Future.value(const [CategoryEntity(id: '1', name: 'Deportes')]),
      ),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Añadir proveedor'), findsNothing);
    expect(find.text('Deportes'), findsOneWidget);
  });
}
