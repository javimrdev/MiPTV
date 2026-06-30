import 'package:flutter/material.dart';
import 'package:miptv/l10n/app_localizations.dart';

/// Wraps [home] in a [MaterialApp] configured with the app's localization
/// delegates and a fixed English locale, so widget-test assertions on
/// user-facing text are deterministic regardless of the host machine locale.
MaterialApp testApp({required Widget home}) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );

/// Router variant of [testApp] for tests that drive the real [GoRouter].
MaterialApp testRouterApp(RouterConfig<Object> routerConfig) =>
    MaterialApp.router(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: routerConfig,
    );
