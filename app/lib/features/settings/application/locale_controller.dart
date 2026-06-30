import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences key storing the user's language choice (a language code
/// such as `en`/`es`). Absent / empty means "follow the system locale".
const _kLocaleKey = 'app_locale';

/// Holds the [SharedPreferences] instance. Overridden in `main()` with the
/// already-loaded instance so the controller can read it synchronously on
/// startup (avoids a one-frame flash of the wrong language).
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

/// The user-selected app locale. `null` means follow the device locale (with
/// English as the ultimate fallback, per [AppLocalizations.supportedLocales]).
class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = ref.read(sharedPreferencesProvider).getString(_kLocaleKey);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  /// Sets (or clears, when [locale] is `null`) the preferred locale and
  /// persists the choice so it survives restarts.
  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove(_kLocaleKey);
    } else {
      await prefs.setString(_kLocaleKey, locale.languageCode);
    }
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);
