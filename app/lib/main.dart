import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:miptv/app/router.dart';
import 'package:miptv/core/db/isar_service.dart';
import 'package:miptv/core/logging/app_logger.dart';

Future<void> main() async {
  // Captura global de errores: todo lo no controlado se vuelca a consola con el
  // logger de la app, en vez de perderse o mostrar solo el banner rojo.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Errores de framework de Flutter (build, layout, gestures…).
      FlutterError.onError = (details) {
        log.e(
          '[FlutterError] ${details.exceptionAsString()}',
          error: details.exception,
          stackTrace: details.stack,
        );
        FlutterError.presentError(details);
      };

      // Errores que llegan al motor/plataforma fuera del árbol de widgets.
      PlatformDispatcher.instance.onError = (error, stack) {
        log.e('[PlatformError] $error', error: error, stackTrace: stack);
        return true;
      };

      MediaKit.ensureInitialized();
      await IsarService.init();

      runApp(
        const ProviderScope(
          child: MiPTVApp(),
        ),
      );
    },
    // Errores asíncronos no capturados (Futures, Streams sin onError…).
    (error, stack) {
      log.e('[Uncaught] $error', error: error, stackTrace: stack);
    },
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
