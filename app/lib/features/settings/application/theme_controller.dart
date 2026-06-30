import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miptv/features/settings/application/locale_controller.dart';

/// SharedPreferences key storing the user's theme choice
/// (`'system'`/`'light'`/`'dark'`). Absent means "follow the system theme".
const _kThemeModeKey = 'app_theme_mode';

/// The user-selected [ThemeMode]. Defaults to [ThemeMode.system].
class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final name = ref.read(sharedPreferencesProvider).getString(_kThemeModeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  /// Sets the preferred theme mode and persists the choice so it survives
  /// restarts.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_kThemeModeKey, mode.name);
  }
}

final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);
