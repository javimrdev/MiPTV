import 'package:flutter/material.dart';

/// Android theme: untouched defaults. Must stay byte-identical to what
/// `main.dart` passed before the iOS crystal-glass redesign — no
/// `copyWith`/custom sub-themes here.
ThemeData androidLightTheme() => ThemeData.light(useMaterial3: true);

ThemeData androidDarkTheme() => ThemeData.dark(useMaterial3: true);

/// iOS theme: same Material 3 [ColorScheme] base, but with the chrome
/// (app bar, bottom nav, chips) made transparent/flat so the per-widget
/// `GlassSurface` can show through. No blur lives in the theme — only the
/// widgets that pair a transparent background with a `GlassSurface` behind
/// it (`AppScaffold`, `ScaffoldWithNavBar`, `FilterPill`) actually render
/// glass.
ThemeData iosLightTheme() => _iosTheme(ThemeData.light(useMaterial3: true));

ThemeData iosDarkTheme() => _iosTheme(ThemeData.dark(useMaterial3: true));

ThemeData _iosTheme(ThemeData base) {
  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: base.navigationBarTheme.copyWith(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    chipTheme: base.chipTheme.copyWith(backgroundColor: Colors.transparent),
  );
}
