# MiPTV — Especificaciones Técnicas y Funcionales

## 1. Visión General

**MiPTV** es una aplicación multiplataforma para consumo y gestión de servicios IPTV. Permite reproducir canales en vivo, gestionar listas M3U/XSPF, organizar favoritos, acceder a guías de programación EPG y administrar múltiples proveedores desde un único punto de acceso.

**Plataformas objetivo:**

| Plataforma | Versión mínima |
|---|---|
| iOS / iPadOS | iOS 16+ |
| Android | Android 8.0 (API 26)+ |
| tvOS (Apple TV) | tvOS 16+ |
| Android TV / Google TV | Android TV 8.0+ |
| Samsung Tizen | Tizen 6.0+ |
| LG webOS | webOS 6.0+ |

---

## 2. Filosofía del Stack

**React Native** gestiona toda la capa de UI y experiencia de usuario de forma compartida entre plataformas. **Rust** gestiona toda la lógica de negocio, red, parseo y persistencia con máximo rendimiento y seguridad de memoria.

```
┌──────────────────────────────────────────────────────────────┐
│                     UI Layer — TypeScript                    │
│  React Native 0.76+ (iOS · Android · tvOS · Android TV)     │
│  React Native Web (Tizen · webOS, empaquetado)              │
└──────────────────────┬───────────────────────────────────────┘
                       │ Turbo Native Modules (JSI — sin bridge)
┌──────────────────────▼───────────────────────────────────────┐
│           Glue Layer — Swift (iOS/tvOS) · Kotlin (Android)   │
│       Wrappers delgados generados por UniFFI + codegen RN    │
└──────────────────────┬───────────────────────────────────────┘
                       │ FFI / UniFFI
┌──────────────────────▼───────────────────────────────────────┐
│                  Rust Core (100% compartido)                 │
│  Dominio · Parsers M3U/XMLTV · HTTP · SQLite · ViewModels   │
└──────────────────────────────────────────────────────────────┘
```

---

## 3. Stack Tecnológico

### 3.1 UI — React Native

| Capa | Tecnología | Notas |
|---|---|---|
| Framework | **React Native 0.76+** (Nueva Arquitectura) | Fabric + Turbo Modules activos por defecto |
| Lenguaje UI | **TypeScript 5** | Tipos estrictos en todo el frontend |
| Navegación | **React Navigation v7** | Stack, Tab, Drawer |
| Estado global | **Zustand** | Ligero, sin boilerplate |
| Datos async | **TanStack Query v5** | Caché, sincronización, re-fetch |
| Estilos | **StyleSheet nativo + Tamagui** | Tokens de diseño unificados multiplataforma |
| Internacionalización | **i18next + react-i18next** | ES, EN, FR, DE, PT |
| Animaciones | **React Native Reanimated v3** | Animaciones en el UI thread |
| Gestos | **React Native Gesture Handler v2** | Swipe, pinch, long-press |
| TV | **react-native-tvos** (fork oficial) | tvOS + Android TV, D-pad navigation |
| Web (TV inteligente) | **React Native Web** | Reutiliza componentes RN en Tizen/webOS |
| Tests UI | **Jest + React Native Testing Library** | |
| E2E | **Maestro** | Scripts YAML multiplataforma |

### 3.2 Reproducción de Video

| Capa | Tecnología | Notas |
|---|---|---|
| Player RN | **react-native-video v6+** | HLS, DASH; usa AVPlayer en iOS y ExoPlayer/Media3 en Android |
| Player TV web | **HLS.js + dash.js** | Dentro de WebView en Tizen/webOS |
| Player extendido (codecs) | **VLCKit (iOS)** / **libVLC (Android)** vía módulo nativo | Opcional, para streams complejos (RTSP, UDP, TS) |
| DRM | **react-native-video** con Widevine (Android) / FairPlay (iOS) | Proveedores que requieran DRM |
| PiP | API nativa de iOS/Android expuesta a RN | |
| Chromecast | **react-native-google-cast** | |
| AirPlay | Nativo iOS vía `react-native-airplay-btn` | |

### 3.3 Core — Rust

| Responsabilidad | Crate |
|---|---|
| Runtime async | `tokio` |
| HTTP client | `reqwest` (sobre `hyper`) |
| WebSocket | `tokio-tungstenite` |
| Serialización JSON | `serde` + `serde_json` |
| Serialización XML (EPG/XMLTV) | `quick-xml` + `serde` |
| Parser M3U / M3U8 | `m3u8-rs` + `nom` para parsing personalizado |
| Base de datos local | `sqlx` (SQLite, async, compile-time checks) |
| Migraciones | `sqlx migrate` |
| Errores | `thiserror` + `anyhow` |
| Logging | `tracing` + `tracing-subscriber` |
| UUIDs | `uuid` |
| Fechas | `time` |
| URLs | `url` |
| Almacenamiento seguro | `keyring` (Keychain/Keystore) |
| Caché en memoria | `moka` (async, TTL/LRU) |
| Regex | `regex` |
| Bindings FFI → Swift/Kotlin | `uniffi` (Mozilla UniFFI 0.28+) |

### 3.4 Puente Rust ↔ React Native

La nueva arquitectura de React Native (0.76+) permite llamadas síncronas y asíncronas directas entre JavaScript y código nativo sin el antiguo bridge asíncrono.

```
TypeScript (RN)
      │
      │  import { MiPTVCore } from './specs/NativeMiPTVCore'
      ▼
Turbo Native Module (C++ JSI spec)
      │
      │  Swift (iOS)         Kotlin (Android)
      │  MiPTVCore.swift     MiPTVCore.kt
      │     └── generated por UniFFI + codegen RN
      ▼
Rust .xcframework (iOS) / .so (Android)
      │
      └── core-domain + core-data + core-viewmodel
```

**Flujo de generación de código:**

```bash
# 1. Compilar Rust para targets nativos
cargo build --target aarch64-apple-ios --release
cargo build --target aarch64-linux-android --release

# 2. Generar bindings Swift/Kotlin con UniFFI
uniffi-bindgen generate src/miptv.udl --language swift
uniffi-bindgen generate src/miptv.udl --language kotlin

# 3. Empaquetar como Turbo Native Module
# El módulo RN envuelve los bindings generados
```

### 3.5 Backend / Sincronización (opcional, self-hosted)

| Componente | Tecnología |
|---|---|
| API REST | **Axum** (Rust) |
| Auth | JWT (`jsonwebtoken`) + OAuth2 (`oauth2`) |
| Base de datos | **PostgreSQL** vía `sqlx` |
| Caché EPG | **Redis** vía `fred` |
| Sync tiempo real | **WebSocket** con `tokio-tungstenite` |
| Despliegue | **Docker Compose** (imagen musl estática ~10 MB) |

---

## 4. Arquitectura

### 4.1 Patrón general

- **UI**: React Native con patrón **Container / Presenter** y estado en Zustand
- **Core Rust**: Clean Architecture + **patrón Repository**
- **Comunicación JS ↔ Rust**: Turbo Native Modules síncronos y async vía Promises
- **Reactividad**: El core Rust emite eventos vía callbacks registrados desde RN (event emitters)

```
┌─────────────────────────────────────────────────────────┐
│                  Screens / Components (TSX)             │
│          useQuery · useStore (Zustand) · hooks          │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│            Turbo Native Module — NativeMiPTVCore        │
│   getChannels() · syncEpg() · addProvider() · …         │
└──────────────────────┬──────────────────────────────────┘
                       │ JSI → FFI
┌──────────────────────▼──────────────────────────────────┐
│                   Rust Core                             │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Use Cases   │  │  Repositories│  │  ViewModels  │  │
│  │  (domain)    │  │  (data)      │  │  (state)     │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────────┘  │
│         │                 │                             │
│  ┌──────▼─────────────────▼───────────────────────┐    │
│  │  reqwest · sqlx · m3u8-rs · quick-xml · moka   │    │
│  └────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

### 4.2 Estructura del repositorio

```
MiPTV/
├── spec/                          # Especificaciones y mockups
│
├── app/                           # React Native puro (npx react-native init)
│   ├── src/
│   │   ├── screens/               # Home, Channels, EPG, Player, Settings…
│   │   ├── components/            # UI components reutilizables
│   │   ├── navigation/            # React Navigation config
│   │   ├── store/                 # Zustand stores
│   │   ├── hooks/                 # Custom hooks (useChannels, useEPG…)
│   │   ├── specs/                 # Turbo Module specs (TypeScript)
│   │   │   └── NativeMiPTVCore.ts
│   │   └── i18n/                  # Traducciones
│   ├── android/                   # Android project (incluye .so de Rust)
│   ├── ios/                       # Xcode project (incluye .xcframework Rust)
│   └── package.json
│
├── rust/                          # Cargo workspace
│   ├── Cargo.toml
│   ├── crates/
│   │   ├── core-domain/           # Entidades, traits, errores
│   │   ├── core-data/             # HTTP, SQLite, caché, parsers
│   │   ├── core-viewmodel/        # AppState, lógica de negocio
│   │   ├── parser-m3u/            # Parser M3U/M3U8
│   │   ├── parser-xmltv/          # Parser EPG XMLTV
│   │   └── ffi-uniffi/            # Bindings Swift + Kotlin
│   └── rust-toolchain.toml
│
├── backend/                       # Axum server (opcional)
│   └── Cargo.toml
│
└── docs/
    └── adr/                       # Architecture Decision Records
```

### 4.3 Turbo Native Module — spec TypeScript

```typescript
// app/src/specs/NativeMiPTVCore.ts
import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Provider {
  id: string;
  name: string;
  providerType: 'm3u' | 'xtream' | 'mag';
  url: string;
  epgUrl?: string;
  isActive: boolean;
}

export interface Channel {
  id: string;
  providerId: string;
  name: string;
  streamUrl: string;
  logoUrl?: string;
  group: string;
  tvgId?: string;
  catchupSupport: boolean;
}

export interface EpgEntry {
  channelId: string;
  title: string;
  description?: string;
  start: number;   // Unix timestamp ms
  end: number;
  category?: string;
}

export interface Spec extends TurboModule {
  // Proveedores
  addProvider(provider: Omit<Provider, 'id'>): Promise<Provider>;
  getProviders(): Promise<Provider[]>;
  removeProvider(id: string): Promise<void>;
  syncProvider(id: string): Promise<void>;

  // Canales
  getChannels(providerId?: string): Promise<Channel[]>;
  searchChannels(query: string): Promise<Channel[]>;

  // Favoritos y listas
  addFavorite(channelId: string): Promise<void>;
  removeFavorite(channelId: string): Promise<void>;
  getFavorites(): Promise<Channel[]>;
  getRecentChannels(): Promise<Channel[]>;

  // EPG
  getEpgForChannel(channelId: string, date: number): Promise<EpgEntry[]>;
  getCurrentProgram(channelId: string): Promise<EpgEntry | null>;
  syncEpg(providerId: string): Promise<void>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('MiPTVCore');
```

---

## 5. Modelos de Datos — Rust

```rust
// crates/core-domain/src/models.rs

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize, uniffi::Record)]
pub struct Provider {
    pub id: String,
    pub name: String,
    pub provider_type: ProviderType,
    pub url: String,
    pub credentials: Option<Credentials>,
    pub epg_url: Option<String>,
    pub last_sync: i64,
    pub is_active: bool,
}

#[derive(Debug, Clone, uniffi::Enum)]
pub enum ProviderType { M3u, XtreamCodes, Mag }

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize, uniffi::Record)]
pub struct Channel {
    pub id: String,
    pub provider_id: String,
    pub name: String,
    pub stream_url: String,
    pub logo_url: Option<String>,
    pub group: String,
    pub country: Option<String>,
    pub languages: Vec<String>,
    pub tvg_id: Option<String>,
    pub catchup_support: bool,
}

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize, uniffi::Record)]
pub struct EpgEntry {
    pub channel_id: String,
    pub title: String,
    pub description: Option<String>,
    pub start: i64,
    pub end: i64,
    pub category: Option<String>,
    pub poster_url: Option<String>,
}

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize, uniffi::Record)]
pub struct Playlist {
    pub id: String,
    pub name: String,
    pub channel_ids: Vec<String>,
    pub created_at: i64,
    pub is_favorites: bool,
}
```

---

## 6. Funcionalidades

### 6.1 Gestión de Proveedores y Listas

| ID | Funcionalidad |
|---|---|
| F-01 | Añadir proveedor IPTV por URL M3U / M3U8 |
| F-02 | Añadir proveedor por Xtream Codes API (host, usuario, contraseña) |
| F-03 | Añadir proveedor por MAG portal URL |
| F-04 | Importar lista desde archivo local (.m3u, .m3u8, .xspf) |
| F-05 | Múltiples proveedores simultáneos |
| F-06 | Actualización automática de listas (intervalo configurable) |
| F-07 | Validación y estado de salud del proveedor |
| F-08 | Exportar lista combinada como M3U |

### 6.2 Exploración y Reproducción de Canales

| ID | Funcionalidad |
|---|---|
| F-10 | Listado de canales con logo, nombre y grupo |
| F-11 | Búsqueda en tiempo real por nombre, grupo o país |
| F-12 | Filtrado por categoría/grupo |
| F-13 | Filtrado por país / idioma |
| F-14 | Reproducción en pantalla completa con controles adaptativos |
| F-15 | Soporte de protocolos: HLS, DASH, RTSP, UDP Multicast, TS |
| F-16 | Selección de calidad de stream |
| F-17 | Zapping rápido (swipe en móvil, D-pad en TV) |
| F-18 | PiP (Picture-in-Picture) en móvil |
| F-19 | Rotación automática retrato/paisaje |
| F-20 | Controles en lock screen (Now Playing) |
| F-21 | Subtítulos embebidos (CEA-608, WebVTT, SRT) |
| F-22 | Selector de pistas de audio |
| F-23 | Control de brillo y volumen por gesto (móvil) |

### 6.3 Favoritos y Listas Personalizadas

| ID | Funcionalidad |
|---|---|
| F-30 | Marcar/desmarcar canal como favorito |
| F-31 | Crear listas de reproducción personalizadas |
| F-32 | Añadir/quitar canales de listas |
| F-33 | Reordenar canales (drag & drop) |
| F-34 | Renombrar y eliminar listas |
| F-35 | Importar/exportar listas como M3U |
| F-36 | Lista "Vistos recientemente" |
| F-37 | Lista "Más vistos" |

### 6.4 Guía de Programación (EPG)

| ID | Funcionalidad |
|---|---|
| F-40 | Descarga y parseo de EPG en formato XMLTV |
| F-41 | URL de EPG configurable por proveedor |
| F-42 | Vista de guía en cuadrícula (timeline horizontal) |
| F-43 | Vista de guía por canal (programación del día) |
| F-44 | Detalle de programa: título, descripción, categoría, duración |
| F-45 | Indicador de programa en curso en el listado |
| F-46 | Barra de progreso del programa en el reproductor |
| F-47 | Recordatorio de programa (notificación local) |
| F-48 | Búsqueda en EPG por título |
| F-49 | Caché de EPG con actualización periódica |

### 6.5 Catch-up / Time-shift

| ID | Funcionalidad |
|---|---|
| F-50 | Reproducción diferida (catch-up) desde la guía EPG |
| F-51 | Pausa y retroceso en streams con time-shift |
| F-52 | Indicador de disponibilidad de catch-up por programa |

### 6.6 Grabación (opcional)

| ID | Funcionalidad |
|---|---|
| F-60 | Programar grabación de un canal |
| F-61 | Grabación manual del stream en curso |
| F-62 | Gestión de grabaciones (listar, reproducir, eliminar) |
| F-63 | Almacenamiento local o en red (NAS/SMB) |

### 6.7 Experiencia TV / Smart TV

| ID | Funcionalidad |
|---|---|
| F-70 | Navegación completa por D-pad / mando a distancia |
| F-71 | Diseño 10-foot UI: texto grande, contraste alto |
| F-72 | Pantalla de inicio con favoritos y programas en curso |
| F-73 | Panel lateral con categorías y búsqueda |
| F-74 | Miniguía EPG superpuesta durante reproducción |
| F-75 | Integración con Android TV Channels API |
| F-76 | Soporte de Chromecast / AirPlay |
| F-77 | App móvil como mando a distancia (companion) |

### 6.8 Configuración y Preferencias

| ID | Funcionalidad |
|---|---|
| F-80 | Tema claro / oscuro / sistema |
| F-81 | Idioma de la interfaz (ES, EN, FR, DE, PT) |
| F-82 | Tamaño de fuente |
| F-83 | Reproductor preferido (interno / externo) |
| F-84 | Límite de caché de EPG y media |
| F-85 | Control parental con PIN por grupo |
| F-86 | Proxy configurable para streams restringidos |
| F-87 | Preferencia de calidad por tipo de red |
| F-88 | Inicio automático en último canal |

### 6.9 Sincronización y Backup

| ID | Funcionalidad |
|---|---|
| F-90 | Backup en iCloud / Google Drive |
| F-91 | Sincronización entre dispositivos |
| F-92 | Exportar/importar configuración completa |
| F-93 | Perfiles de usuario múltiples |

---

## 7. Pantallas Principales

### Móvil (iOS / Android)

```
├── Home
│   ├── Favoritos (carrusel)
│   ├── En curso ahora (EPG)
│   └── Por categoría
├── Canales (lista + búsqueda + filtros)
├── Guía EPG (cuadrícula / por canal)
├── Mis Listas
│   ├── Favoritos
│   ├── Listas personalizadas
│   └── Recientes / Más vistos
├── Reproductor
│   ├── Controles de reproducción
│   ├── Mini-guía EPG
│   ├── Selector de pistas / calidad
│   └── PiP
└── Ajustes
    ├── Proveedores
    ├── Preferencias
    ├── Control parental
    └── Backup / Sync
```

### Smart TV (tvOS / Android TV / Tizen / webOS)

```
├── Home (10-foot UI)
│   ├── Hero: canal en reproducción
│   ├── Fila: Favoritos
│   ├── Fila: En curso
│   └── Fila: Por categoría
├── Todos los canales (grid)
├── Guía EPG (timeline)
├── Mis Listas
└── Ajustes
```

---

## 8. Requisitos No Funcionales

| Requisito | Objetivo |
|---|---|
| Arranque en frío | < 2 s hasta primer frame |
| Inicio de reproducción | < 3 s (HLS) |
| Tamaño de app | < 40 MB instalada |
| Seguridad de memoria | Rust garantiza ausencia de data races y buffer overflows en el core |
| Offline | UI funcional con datos SQLite en caché |
| Accesibilidad | VoiceOver / TalkBack; Dynamic Type; foco D-pad accesible |
| Privacidad | Sin telemetría sin consentimiento; GDPR |
| Seguridad | Credenciales en `keyring`; `cargo audit` en CI; sin logs de secretos |

---

## 9. Toolchain

### Rust

```toml
# rust/rust-toolchain.toml
[toolchain]
channel = "stable"
targets = [
  "aarch64-apple-ios",
  "aarch64-apple-ios-sim",
  "x86_64-apple-ios",
  "aarch64-linux-android",
  "armv7-linux-androideabi",
  "x86_64-linux-android",
  "i686-linux-android",
]
components = ["clippy", "rustfmt"]
```

| Herramienta | Uso |
|---|---|
| `cargo clippy` | Linting |
| `cargo fmt` | Formateo |
| `cargo nextest` | Tests (más rápido que `cargo test`) |
| `cargo audit` | Auditoría CVEs |
| `cargo deny` | Control de licencias |
| `uniffi-bindgen` | Generación de bindings Swift/Kotlin |
| `cross` | Cross-compilación Android |
| `cargo-make` | Scripts de build multiplataforma |

### React Native / JavaScript

| Herramienta | Uso |
|---|---|
| **Bun** | Package manager y runtime JS |
| **TypeScript 5** | Tipado estricto |
| **ESLint + Prettier** | Linting y formateo |
| **Jest + RNTL** | Tests de componentes |
| **Maestro** | Tests E2E |
| **Fastlane** | Automatización de builds, firma y publicación en App Store / Play Store |
| **GitHub Actions** | CI/CD: tests, build Rust, build RN, distribución |
| **CodePush** (Microsoft) | OTA updates de la capa JS sin pasar por review de stores |

---

## 10. Dependencias Clave

### Rust (`rust/Cargo.toml`)

```toml
[workspace.dependencies]
tokio          = { version = "1",    features = ["full"] }
reqwest        = { version = "0.12", features = ["json", "stream"] }
tokio-tungstenite = "0.24"
serde          = { version = "1",    features = ["derive"] }
serde_json     = "1"
quick-xml      = { version = "0.37", features = ["serialize"] }
m3u8-rs        = "6"
nom            = "7"
sqlx           = { version = "0.8",  features = ["sqlite", "runtime-tokio", "migrate", "time"] }
time           = { version = "0.3",  features = ["serde"] }
uuid           = { version = "1",    features = ["v4"] }
thiserror      = "2"
anyhow         = "1"
tracing        = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter"] }
moka           = { version = "0.12", features = ["future"] }
keyring        = "3"
url            = "2"
uniffi         = "0.28"
# Backend (opcional)
axum           = "0.7"
jsonwebtoken   = "9"
fred           = "9"
```

### React Native (`app/package.json`)

```json
{
  "dependencies": {
    "react-native": "0.76.x",
    "@react-navigation/native": "^7.0.0",
    "@react-navigation/stack": "^7.0.0",
    "@react-navigation/bottom-tabs": "^7.0.0",
    "react-native-video": "^6.0.0",
    "react-native-reanimated": "^3.0.0",
    "react-native-gesture-handler": "^2.0.0",
    "zustand": "^5.0.0",
    "@tanstack/react-query": "^5.0.0",
    "tamagui": "^1.0.0",
    "i18next": "^23.0.0",
    "react-i18next": "^14.0.0",
    "react-native-google-cast": "^5.0.0",
    "@react-native-async-storage/async-storage": "^2.0.0",
    "react-native-code-push": "^8.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/react": "^18.0.0",
    "jest": "^29.0.0",
    "@testing-library/react-native": "^12.0.0",
    "eslint": "^9.0.0",
    "prettier": "^3.0.0"
  }
}
```

---

## 11. Roadmap de Versiones

| Versión | Alcance |
|---|---|
| v0.1 — MVP | Core Rust: parseo M3U, SQLite. Turbo Module básico. UI RN: lista de canales + player HLS |
| v0.2 | Favoritos, historial, búsqueda. Pipeline CI/CD con Fastlane + GitHub Actions |
| v0.3 | EPG XMLTV (parser Rust), guía en cuadrícula, mini-guía en reproductor |
| v0.4 | Xtream Codes, múltiples proveedores, listas personalizadas |
| v0.5 | TV: react-native-tvos → tvOS + Android TV con D-pad navigation |
| v0.6 | Smart TV web: React Native Web → Tizen + webOS |
| v0.7 | Catch-up, recordatorios, notificaciones locales |
| v0.8 | Chromecast / AirPlay, companion móvil↔TV |
| v1.0 | Backend Axum (sync en nube), perfiles, control parental, App Store / Play Store |
| v1.x | Grabación de streams, NAS/SMB, OTA updates vía CodePush |
