import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';
import 'package:miptv/features/movies/presentation/movies_screen.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';

import '../../support/l10n_test_app.dart';

void main() {
  Widget wrap(List<Override> overrides) => ProviderScope(
        overrides: overrides,
        child: testApp(home: const MoviesScreen()),
      );

  testWidgets('shows "Add provider" when no provider configured',
      (tester) async {
    await tester.pumpWidget(wrap([
      providerProvider.overrideWith((ref) => Future.value(null)),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Add provider'), findsOneWidget);
  });

  testWidgets('shows search field and VOD categories when provider configured',
      (tester) async {
    await tester.pumpWidget(wrap([
      providerProvider.overrideWith(
        (ref) => Future.value(
          const ProviderEntity(id: 1, server: 'http://x.tv', username: 'u'),
        ),
      ),
      vodCategoriesProvider.overrideWith(
        (ref) => Future.value(const [CategoryEntity(id: '10', name: 'Acción')]),
      ),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Search movies…'), findsOneWidget);
    expect(find.text('Acción'), findsOneWidget);
  });
}
