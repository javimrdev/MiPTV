import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/features/settings/application/locale_controller.dart';
import 'package:miptv/features/settings/application/theme_controller.dart';
import 'package:miptv/features/settings/presentation/settings_screen.dart';
import 'package:miptv/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mirrors the real app: rebuilds [MaterialApp] with whatever theme mode the
/// [themeControllerProvider] currently holds, so a selection in Settings
/// actually re-themes the UI within the test.
class _ThemeAwareApp extends ConsumerWidget {
  const _ThemeAwareApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SettingsScreen(),
    );
  }
}

void main() {
  testWidgets('selecting a theme mode updates the app theme and persists the choice',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        providerProvider.overrideWith((ref) => Future.value(null)),
      ],
      child: const _ThemeAwareApp(),
    ));
    await tester.pumpAndSettle();

    // Defaults to the system theme mode.
    final initialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(initialApp.themeMode, ThemeMode.system);
    expect(prefs.getString('app_theme_mode'), isNull);

    // Select "Light" (English test locale).
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    final lightApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(lightApp.themeMode, ThemeMode.light);
    expect(prefs.getString('app_theme_mode'), 'light');

    // Select "Dark".
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    final darkApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(darkApp.themeMode, ThemeMode.dark);
    expect(prefs.getString('app_theme_mode'), 'dark');
  });
}
