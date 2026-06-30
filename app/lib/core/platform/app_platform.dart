import 'package:flutter/foundation.dart';

/// Whether the app should render the iOS "crystal glass" visual variant.
/// `false` on Android, web and desktop — those keep the existing Material
/// look untouched. Centralizes the platform check so every adaptive widget
/// reads the same source of truth.
///
/// Under `flutter test`, Flutter forces `defaultTargetPlatform` to
/// [TargetPlatform.android] (via the `FLUTTER_TEST` env var), so this is
/// deterministically `false` in the whole test suite regardless of the host
/// OS — no mocking required to keep the Android branch under test.
bool get isIOSGlass => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
