import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:miptv/app/router.dart';
import 'package:miptv/core/db/isar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await IsarService.init();

  runApp(
    const ProviderScope(
      child: MiPTVApp(),
    ),
  );
}

class MiPTVApp extends StatelessWidget {
  const MiPTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MiPTV',
      theme: ThemeData.dark(useMaterial3: true),
      routerConfig: appRouter,
    );
  }
}
