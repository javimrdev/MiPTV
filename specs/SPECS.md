# IPTV Flutter - MVP v0.1

## Objetivo

Desarrollar una aplicación IPTV para Android e iOS utilizando Flutter con una única base de código.

El MVP permitirá:

- Añadir un proveedor Xtream.
- Sincronizar categorías Live TV.
- Sincronizar canales bajo demanda.
- Navegar por categorías.
- Reproducir canales.
- Marcar canales como favoritos.
- Mostrar favoritos en una pestaña dedicada.
- Reproducir VOD (Películas): navegar por categorías VOD y buscar en todo el catálogo.
- Funcionar offline utilizando la última sincronización.

---

# Stack

| Área           | Tecnología                 |
| -------------- | -------------------------- |
| UI             | Flutter                    |
| Estado         | Riverpod                   |
| Navegación     | GoRouter                   |
| Networking     | Dio                        |
| Base de datos  | Isar                       |
| Credenciales   | Flutter Secure Storage     |
| Player         | MediaKit                   |
| Cache imágenes | CachedNetworkImage         |
| Modelos        | Freezed + JsonSerializable |

---

# Arquitectura

Feature First + Clean Architecture.

```
lib/

app/

core/

features/

provider/

home/

categories/

streams/

favorites/

player/
```

Cada feature contendrá:

```
data/

domain/

presentation/
```

---

# Flujo

```
Splash

↓

Home (pestaña Inicio)

↓

¿Hay proveedor?

├─ No → Botón "Añadir proveedor" → Formulario Xtream → Sincronizar categorías → Home
│
└─ Sí → Lista de categorías

↓

Seleccionar categoría

↓

Sincronizar canales (solo primera vez)

↓

Lista de canales

↓

Player
```

La navegación principal se organiza con una **barra inferior (NavigationBar)** de tres
pestañas: **Inicio**, **Favoritos** y **Ajustes** (`StatefulShellRoute.indexedStack`).
Las pantallas `add-provider`, `category` y `player` se abren a pantalla completa sobre el
navegador raíz (sin barra inferior).

---

# Pantallas

## Home (Inicio)

- Si no hay proveedor: botón "Añadir proveedor".
- Si hay proveedor: lista de categorías.

## Favoritos

- Lista virtualizada de canales favoritos (logo + nombre).
- Quitar de favoritos.
- Reproducir.

## Configuración (Ajustes)

- Gestión del proveedor: añadir / sincronizar categorías / eliminar.
- Selector de tema y de idioma (placeholders, aún sin efecto).
- Información de la app.

## Categoría

- Lista virtualizada de canales.
- Logo.
- Nombre.
- Favorito.

## Player

- Reproducción automática.
- Play/Pause.
- Avanzar / retroceder (barra de progreso) — controles integrados de MediaKit (`AdaptiveVideoControls`).
- Botón volver/cerrar.
- Pantalla completa.
- Manejo de errores.
- URL construida dinámicamente: `live` para canales, `movie` para VOD.

---

## VOD (Películas)

- Pestaña dedicada en la barra inferior.
- Sincronización única del catálogo completo (`get_vod_categories` + `get_vod_streams` sin `category_id`), mapeada en un isolate.
- Navegación por categorías VOD y reproducción de películas.
- Búsqueda global por nombre sobre el catálogo cacheado (consulta Isar local con `name` indexado).
- Colecciones Isar independientes de Live TV para evitar colisión de `stream_id`/`category_id`.

---

# Modelo de dominio

## Provider

```
id
server
username
```

La contraseña **no se almacena** en la base de datos.

---

## Category

```
id
name
```

---

## Stream

```
id
name
logo
categoryId
extension
```

No se almacena la URL completa.

---

## Favorite

```
streamId
createdAt
```

---

## CategorySync

```
categoryId
lastSync
isSyncing
streamCount
```

---

# Seguridad

## Isar

Almacena:

- categorías
- canales
- favoritos
- configuración

## Secure Storage

Almacena:

- contraseña Xtream
- futuras credenciales sensibles

Nunca se guardarán contraseñas dentro de Isar.

---

# Providers

Toda la aplicación trabaja contra una abstracción.

```
IPTVProvider

↓

XtreamProvider
```

En el futuro podrán añadirse:

- M3U
- Stalker
- Jellyfin
- Emby

sin modificar la UI.

---

# Sincronización

## Categorías

Se descargan al añadir el proveedor.

## Canales

No se descargan todos.

Cada categoría se sincroniza únicamente cuando el usuario entra por primera vez.

```
Usuario

↓

Categoría Deportes

↓

No sincronizada

↓

Descargar canales

↓

Guardar

↓

Mostrar
```

Esto reduce:

- tiempo de carga
- memoria
- tráfico

---

# Rendimiento

Toda sincronización pesada deberá ejecutarse mediante:

```
Isolate.run()
```

Se ejecutarán fuera del hilo principal:

- parseo JSON
- transformación de modelos
- inserciones masivas

La UI nunca deberá bloquearse.

---

# Virtualización

Las listas utilizarán obligatoriamente:

```
ListView.builder
```

Nunca:

- Column
- SingleChildScrollView
- ListView(children: ...)

Solo se renderizarán los elementos visibles.

---

# Consultas

Los canales no permanecerán todos en memoria.

Siempre se consultarán desde Isar.

```
UI

↓

Riverpod

↓

Repository

↓

Isar Query
```

Riverpod solo almacenará el estado necesario.

---

# Player

MediaKit.

Inicialización:

```dart
WidgetsFlutterBinding.ensureInitialized();

MediaKit.ensureInitialized();
```

Controles:

- Play
- Pause
- Fullscreen

Estados:

- Idle
- Loading
- Buffering
- Playing
- Error

---

# Construcción de URL

No se almacenará la URL completa.

Se generará dinámicamente.

```
server

+

username

+

password

+

streamId

+

extension
```

Esto evita:

- duplicar datos
- almacenar credenciales
- migraciones al cambiar contraseña

---

# Favoritos

Colección independiente.

Nunca se almacenarán dentro del Stream.

Ventajas:

- sobreviven a sincronizaciones
- preparados para múltiples proveedores

---

# UI

Obligatorio:

- CachedNetworkImage
- placeholders
- itemExtent
- const widgets
- evitar rebuilds globales

Objetivo:

Scroll fluido a 60/120 FPS.

---

# Logging

Toda operación importante deberá registrarse.

Ejemplos:

- Login
- Sincronización
- Descarga
- Error Player
- Error API

---

# Errores

Gestionar:

- Timeout
- Sin conexión
- Credenciales incorrectas
- Stream inválido
- Error del reproductor

Siempre mostrar mensajes amigables.

---

# MVP

Incluye:

- Xtream
- Categorías
- Streams
- Favoritos
- Player
- VOD (Películas): categorías + búsqueda global
- Offline
- Sincronización lazy

No incluye:

- Series
- EPG
- Descargas
- Chromecast
- AirPlay
- PiP
- Multiusuario
- Múltiples proveedores

---

# Objetivos de rendimiento

- Inicio < 2 segundos.
- Cambio de pantalla instantáneo.
- Sin congelamientos durante sincronización.
- Scroll completamente fluido.
- Carga diferida de canales.
- Consumo de memoria constante independientemente del número de canales.
