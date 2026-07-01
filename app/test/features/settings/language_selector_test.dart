import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/settings/application/locale_controller.dart';
import 'package:miptv/features/settings/presentation/settings_screen.dart';
import 'package:miptv/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mirrors the real app: rebuilds [MaterialApp] with whatever locale the
/// [localeControllerProvider] currently holds, so a selection in Settings
/// actually re-localizes the UI within the test.
class _LocaleAwareApp extends ConsumerWidget {
  const _LocaleAwareApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SettingsScreen(),
    );
  }
}

void main() {
  testWidgets('selecting a language re-localizes the UI and persists the choice',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        providerProvider.overrideWith((ref) => Future.value(null)),
        providersListProvider.overrideWith((ref) => Future.value(const [])),
      ],
      child: const _LocaleAwareApp(),
    ));
    await tester.pumpAndSettle();

    // Defaults to the system locale → settings title in the test's English.
    expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);

    // Open the language picker and choose French.
    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();

    // UI is now French and the choice is persisted.
    expect(find.widgetWithText(AppBar, 'Configuration'), findsOneWidget);
    expect(prefs.getString('app_locale'), 'fr');
  });
}
