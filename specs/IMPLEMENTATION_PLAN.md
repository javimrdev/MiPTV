# MiPTV MVP v0.1 — Plan de implementación

> **Doc durable** — fuente de verdad para retomar entre sesiones de agente.

---

## ✅ MVP COMPLETO — Estado: DONE

- **23/23 tests verdes** · 0 errores de análisis · M0–M6 completados
- Flutter 3.44.4 / Dart 3.12.2 en `/Users/jmolina/flutter/bin`
- iOS toolchain OK · Android SDK NO instalado (iOS primero)
- `isar_community 3.3.2` (fallback activado: `isar` original incompatible con `source_gen ^4`)

---

## Comandos de build rápido (Makefile en raíz del repo)

```bash
make setup       # flutter pub get + pod install
make gen         # build_runner (Isar/Freezed/JSON)
make gen-watch   # build_runner watch
make run         # flutter run (iOS simulator)
make analyze     # flutter analyze
make test        # flutter test
make test-it     # integration_test (real Xtream, opcional)
make build-ios   # flutter build ios --no-codesign
make clean       # flutter clean
```

---

## Stack de dependencias resuelto

| Paquete | Versión | Nota |
|---|---|---|
| `flutter_riverpod` | ^2.6.1 | Estado |
| `go_router` | ^17.3.0 | Navegación |
| `dio` | ^5.9.2 | HTTP |
| `isar_community` + `isar_community_flutter_libs` | ^3.3.2 | DB (fork community — compatible Dart 3.12) |
| `isar_community_generator` | ^3.3.2 | Codegen DB |
| `flutter_secure_storage` | ^10.3.1 | Password |
| `cached_network_image` | ^3.4.1 | Logos canales |
| `media_kit` + `media_kit_video` + `media_kit_libs_ios_video` | ^1.2.6 | Player |
| `freezed_annotation` + `freezed` | ^3.1.0 / ^3.2.5 | Modelos inmutables |
| `json_annotation` + `json_serializable` | ^4.12.0 / ^6.14.0 | JSON API Xtream |
| `logger` | ^2.7.0 | Logging |
| `http_mock_adapter` + `mocktail` | ^0.6.1 / ^1.0.5 | Tests |

---

## Arquitectura Feature-First + Clean Architecture

```
lib/
  app/               # router (GoRouter), providers (Riverpod), MiPTVApp
  core/
    db/              # IsarService (singleton init en main)
    network/         # DioClient (timeouts configurados)
    storage/         # SecureStorageService (interface + FlutterImpl)
    logging/         # app_logger (Logger global)
    errors/          # AppError sealed class + userMessage (mensajes en español)
    url_builder.dart # buildStreamUrl() — ÚNICA fuente de URLs de stream
  features/
    provider/
      data/          # ProviderModel (Isar, sin password), XtreamApi (Dio),
                     # XtreamModels (Freezed+JSON), XtreamProviderRepository
      domain/        # ProviderEntity, IPTVProviderRepository (interface)
      presentation/  # SplashScreen, AddProviderScreen
    home/
      presentation/  # HomeScreen (carrusel favoritos + lista categorías)
    categories/
      data/          # CategoryModel, CategorySyncModel, CategoryRepositoryImpl
      domain/        # CategoryEntity, CategoryRepository
      presentation/  # CategoryScreen (lista virtualizada, error amigable + Reintentar)
    streams/
      data/          # StreamModel (sin URL), StreamRepositoryImpl (lazy sync + Isolate.run + offline fallback)
      domain/        # StreamEntity, StreamRepository
    favorites/
      data/          # FavoriteModel (colección independiente), FavoriteRepositoryImpl
      domain/        # FavoriteEntity, FavoriteRepository
    player/
      presentation/  # PlayerScreen (MediaKit, estados loading/playing/error, retry)
```

---

## Flujo de navegación

```
SplashScreen (/) → comprueba sesión en Isar
  ├─ Provider existe → /home
  └─ Sin provider   → /add-provider

AddProviderScreen → auth Xtream → syncCategories → /home

HomeScreen → carrusel favoritos + lista categorías (ListView.builder)
  └─ tap categoría → /category/:id

CategoryScreen → lazy sync canales (solo 1ª vez) → lista virtualizada
  └─ tap canal → /player/:streamId?ext=ts

PlayerScreen → URL dinámica (SecureStorage) → MediaKit → Play/Pause/Fullscreen
```

---

## Reglas críticas de la spec → tests que las verifican

| Regla de la spec | Test | Estado |
|---|---|---|
| Password NUNCA en Isar | `test/features/provider/provider_schema_test.dart` | ✅ DONE |
| URL construida dinámicamente (formato exacto) | `test/core/url_builder_test.dart` | ✅ DONE |
| Sin URL completa en StreamModel/StreamEntity | `test/features/provider/provider_schema_test.dart` | ✅ DONE |
| Sync Xtream: OK / timeout / noconn / badcreds | `test/features/provider/xtream_auth_test.dart` | ✅ DONE |
| Favoritos sobreviven re-sync (colección independiente) | `test/features/favorites/favorites_survive_resync_test.dart` | ✅ DONE |
| Sync lazy de canales solo primera vez | `test/features/categories/lazy_sync_test.dart` | ✅ DONE |
| Offline: serve caché cuando no hay red | `test/features/streams/offline_fallback_test.dart` | ✅ DONE |

**Total: 23/23 tests verdes**

---

## Milestones

### ✅ M0 — Toolchain + dependencias + esqueleto — DONE

- Todas las dependencias resueltas (isar → isar_community por incompatibilidad con source_gen ^4)
- Estructura Feature-First + Clean Architecture creada en `lib/`
- Makefile operativo en raíz del repo
- `make analyze` 0 errores · `make test` verde

### ✅ M1 — Añadir proveedor Xtream (login end-to-end) — DONE

- `core/url_builder.dart` — `buildStreamUrl()` única fuente de URLs
- `core/storage/secure_storage.dart` — password solo en FlutterSecureStorage
- `core/errors/app_error.dart` — AppError sealed + `userMessage` en español
- `core/logging/app_logger.dart` — Logger global con PrettyPrinter
- `features/provider/data/` — ProviderModel (sin password), XtreamApi (3 endpoints), XtreamModels (Freezed+JSON), XtreamProviderRepository (addProvider, syncCategories con Isolate.run + offline fallback)
- `features/provider/domain/` — ProviderEntity, IPTVProviderRepository (interfaz)
- `features/provider/presentation/` — SplashScreen (chequea sesión), AddProviderScreen (form + errores amigables)
- Tests: `url_builder_test`, `provider_schema_test`, `xtream_auth_test` (mock Dio)

### ✅ M2 — Home — DONE

- `features/home/presentation/HomeScreen` — carrusel horizontal favoritos (ListView.builder) + lista categorías (SliverList.builder) + eliminar proveedor
- `features/categories/data/CategoryRepositoryImpl` — consulta Isar, log incluido
- Error amigable + botón Reintentar en caso de fallo de categorías

### ✅ M3 — Categoría + sync lazy + lista virtualizada — DONE

- `features/streams/data/StreamModel` — sin campo URL (cumple spec)
- `features/categories/data/CategorySyncModel` — tracking estado sync por categoría
- `StreamRepositoryImpl` — sync lazy con `Isolate.run()` (parseo JSON fuera del hilo principal) + offline fallback (si API falla y hay caché → sirve caché; si no hay caché → relanza)
- `CategoryScreen` — ListView.builder + `itemExtent: 72` + CachedNetworkImage + placeholder + error amigable + Reintentar
- Tests: `lazy_sync_test`, `stream_schema` (en provider_schema_test)

### ✅ M4 — Favoritos — DONE

- `FavoriteModel` — colección independiente en Isar (sobrevive re-sync)
- `FavoriteRepositoryImpl` — add/remove/isFavorite + logs
- Toggle ⭐ en CategoryScreen; carrusel de favoritos en HomeScreen
- Tests: `favorites_survive_resync_test`

### ✅ M5 — Player (MediaKit) — DONE

- `PlayerScreen` — URL construida dinámicamente (lee password de SecureStorage en el momento de reproducir), sin almacenar credenciales
- Estados: loading → playing → error (con retry)
- Controles: Play/Pause/Fullscreen vía `media_kit_video`
- `MediaKit.ensureInitialized()` en `main.dart` antes de `runApp`
- Pods nativos iOS: `media_kit_libs_ios_video` en pubspec

### ✅ M6 — Offline, mensajes amigables y logging — DONE

- **Offline fallback en `StreamRepositoryImpl`**: captura `AppError` en `_syncCategory()` → si hay datos en Isar los sirve silenciosamente; si no hay caché relanza para que la UI muestre el error
- **Offline fallback en `XtreamProviderRepository.syncCategories()`**: mismo patrón
- **Mensajes amigables en `CategoryScreen`**: `AppError.userMessage` + icono wifi_off + botón Reintentar
- **Mensajes amigables en `HomeScreen`**: igual para error de categorías + Reintentar
- **Logging completo**: `CategoryRepositoryImpl`, `FavoriteRepositoryImpl`, paths de error en `StreamRepositoryImpl`
- Tests: `offline_fallback_test` (4 casos: caché disponible, sin caché relanza, userMessage NoConnectionError, userMessage NetworkTimeoutError)

---

## Verificación end-to-end (recorrido manual pendiente)

1. `make setup && make gen` — sin errores
2. `make analyze` — 0 errores
3. `make test` — 23/23 verdes ✅
4. `make run` — simulador iOS (manual):
   - Añadir proveedor → categorías cargan → entrar en categoría (sync lazy) → reproducir canal → marcar favorito → ver en Home → **modo avión** → navegar con datos en caché → mensaje "Sin conexión" si no hay caché
5. `make build-ios` — build limpio (requiere `make setup` previo para pods)

---

## Out of scope (NO implementar — spec MVP)

Películas/VOD, Series, EPG, Descargas/offline media, Chromecast, AirPlay, PiP, multiusuario, múltiples proveedores.
