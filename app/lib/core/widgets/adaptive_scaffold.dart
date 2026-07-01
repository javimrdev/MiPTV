import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miptv/core/platform/app_platform.dart';
import 'package:miptv/core/widgets/glass/glass_surface.dart';

/// Drop-in replacement for `Scaffold(appBar: AppBar(title: ...), body: ...)`.
///
/// On Android, renders a plain `Scaffold`/`AppBar` — textually identical to
/// what every screen built before the iOS crystal-glass redesign. On iOS,
/// the app bar becomes a frosted-glass overlay (transparent background +
/// `GlassSurface` behind it) and the body extends behind it, wrapped in a
/// [SafeArea] so content isn't drawn under the translucent bar.
///
/// Pass `title: null` to render without an app bar at all (just the body in
/// a [SafeArea]) — used by screens that want a clean, chrome-free top.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.extendBehindNavBar = false,
  });

  final Widget? title;
  final Widget body;

  /// Set to `true` for screens hosted inside [ScaffoldWithNavBar]'s
  /// [StatefulShellRoute] branches: that shell already floats a
  /// self-contained bottom nav bar over the content (with its own safe-area
  /// handling), so reserving `SafeArea`'s bottom inset here would double
  /// count the home-indicator inset and leave a stray gap above the bar.
  final bool extendBehindNavBar;

  @override
  Widget build(BuildContext context) {
    if (title == null) {
      return Scaffold(
        body: SafeArea(bottom: !extendBehindNavBar, child: body),
      );
    }

    if (!isIOSGlass) {
      return Scaffold(appBar: AppBar(title: title), body: body);
    }

    final brightness = Theme.of(context).brightness;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: title,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        flexibleSpace: const GlassSurface(
          borderRadius: BorderRadius.zero,
          child: SizedBox.expand(),
        ),
      ),
      body: SafeArea(bottom: !extendBehindNavBar, child: body),
    );
  }
}
