import 'package:go_router/go_router.dart';
import 'package:miptv/features/categories/presentation/category_screen.dart';
import 'package:miptv/features/home/presentation/home_screen.dart';
import 'package:miptv/features/player/presentation/player_screen.dart';
import 'package:miptv/features/provider/presentation/add_provider_screen.dart';
import 'package:miptv/features/provider/presentation/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/add-provider', builder: (_, __) => const AddProviderScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/category/:id',
      builder: (_, state) => CategoryScreen(categoryId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/player/:streamId',
      builder: (_, state) {
        final streamId = int.parse(state.pathParameters['streamId']!);
        final ext = state.uri.queryParameters['ext'] ?? 'ts';
        return PlayerScreen(streamId: streamId, extension: ext);
      },
    ),
  ],
);
