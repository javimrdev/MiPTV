import 'package:go_router/go_router.dart';
import 'package:miptv/app/scaffold_with_nav_bar.dart';
import 'package:miptv/features/categories/presentation/category_screen.dart';
import 'package:miptv/features/favorites/presentation/favorites_screen.dart';
import 'package:miptv/features/home/presentation/home_screen.dart';
import 'package:miptv/features/movies/presentation/movie_category_screen.dart';
import 'package:miptv/features/movies/presentation/movies_screen.dart';
import 'package:miptv/features/player/presentation/player_screen.dart';
import 'package:miptv/features/provider/presentation/add_provider_screen.dart';
import 'package:miptv/features/provider/presentation/splash_screen.dart';
import 'package:miptv/features/settings/presentation/settings_screen.dart';

/// Builds the app router. Exposed as a factory so tests can get a fresh,
/// isolated instance (the global [appRouter] retains navigation state).
GoRouter createAppRouter() => GoRouter(
  initialLocation: '/',
  routes: [
    // Full-screen routes (root navigator — no bottom bar).
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/add-provider', builder: (_, __) => const AddProviderScreen()),
    GoRoute(
      path: '/category/:id',
      builder: (_, state) => CategoryScreen(categoryId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/movies/category/:id',
      builder: (_, state) =>
          MovieCategoryScreen(categoryId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/player/:streamId',
      builder: (_, state) {
        final streamId = int.parse(state.pathParameters['streamId']!);
        final ext = state.uri.queryParameters['ext'] ?? 'ts';
        final type = state.uri.queryParameters['type'] ?? 'live';
        return PlayerScreen(streamId: streamId, extension: ext, type: type);
      },
    ),
    // Main tabs wrapped in the bottom NavigationBar shell.
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) =>
          ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/home', builder: (_, __) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/movies', builder: (_, __) => const MoviesScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
          ],
        ),
      ],
    ),
  ],
);

final appRouter = createAppRouter();
