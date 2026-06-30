import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/core/platform/app_platform.dart';
import 'package:miptv/core/widgets/glass/glass_surface.dart';
import 'package:miptv/l10n/app_localizations.dart';

/// Shell scaffold hosting the bottom [NavigationBar] for the main tabs.
/// The [navigationShell] keeps each branch's state alive (indexedStack).
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final navBar = NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        // Re-tapping the active tab returns to its initial route.
        initialLocation: index == navigationShell.currentIndex,
      ),
      backgroundColor: isIOSGlass ? Colors.transparent : null,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: l10n.navHome,
        ),
        NavigationDestination(
          icon: const Icon(Icons.movie_outlined),
          selectedIcon: const Icon(Icons.movie),
          label: l10n.navMovies,
        ),
        NavigationDestination(
          icon: const Icon(Icons.star_border),
          selectedIcon: const Icon(Icons.star),
          label: l10n.navFavorites,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: l10n.navSettings,
        ),
      ],
    );

    if (!isIOSGlass) {
      return Scaffold(body: navigationShell, bottomNavigationBar: navBar);
    }

    // iOS: the same NavigationBar floats as a frosted "pill" over the
    // content, which extends behind it (extendBody).
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: GlassSurface(
          borderRadius: BorderRadius.circular(28),
          child: navBar,
        ),
      ),
    );
  }
}
