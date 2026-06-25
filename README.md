# MiPTV

MiPTV es una aplicación multiplataforma para gestionar y reproducir contenido IPTV desde una sola experiencia unificada. El proyecto combina una interfaz de usuario desarrollada en React Native con una capa de negocio y procesamiento de datos en Rust, conectadas mediante bindings nativos para iOS y Android.

## Visión general

MiPTV está pensado para cubrir el flujo completo de uso de IPTV:

- añadir y gestionar proveedores de canales
- importar listas M3U/XSPF
- explorar canales y buscar contenido rápidamente
- gestionar favoritos y historial de reproducción
- consultar guías de programación EPG
- mantener la lógica crítica en un core compartido entre plataformas

El proyecto está en una etapa inicial de desarrollo, con foco en una arquitectura limpia y una base técnica preparada para escalar a TV, tablets y móviles.

## Stack tecnológico

### Frontend
- React Native 0.76+
- TypeScript 5
- React Navigation
- Zustand para estado global
- TanStack Query para datos asíncronos
- i18next para internacionalización

### Core y lógica de negocio
- Rust con un workspace Cargo
- Crates separadas para dominio, datos, viewmodels y parsers
- Parsing de listas M3U/M3U8 y EPG XMLTV
- Persistencia local y sincronización de datos

### Puente nativo
- Swift para iOS
- Kotlin para Android
- UniFFI para bindings entre Rust y la capa nativa
- Turbo Native Modules para integración con React Native

## Estructura del repositorio

- app/: aplicación React Native principal
  - src/screens/: pantallas de la app
  - src/components/: componentes reutilizables
  - src/hooks/: hooks personalizados
  - src/navigation/: configuración de navegación
  - src/specs/: definiciones del módulo nativo
- rust/: workspace Cargo con los crates del core compartido
- ios/: wrapper nativo iOS y empaquetado del framework de Rust
- android/: proyecto nativo Android
- spec/: especificaciones, arquitectura y documentación técnica

## Requisitos previos

- Node.js 20+
- pnpm
- Rust toolchain (stable) con los targets `aarch64-apple-ios` y `aarch64-apple-ios-sim`
- Xcode + Command Line Tools para desarrollo iOS
- **Ruby 3.3** para CocoaPods (ver nota abajo) — `brew install ruby@3.3 && /opt/homebrew/opt/ruby@3.3/bin/gem install cocoapods`
- Android Studio / Android SDK para desarrollo Android

> **Nota sobre Ruby/CocoaPods:** CocoaPods 1.16 solo funciona con Ruby 3.3. El Ruby del sistema (2.6) y los más nuevos (3.4 elimina `kconv`, 4.0 tiene un bug de *null byte*) fallan al instalar pods. Los targets `make run-ios-*` ya anteponen Ruby 3.3 al `PATH` automáticamente, así que normalmente no tendrás que pensar en esto.

## Inicio rápido

### 1. Instalar dependencias de la app

```bash
cd app
pnpm install
```

### 2. Iniciar Metro

```bash
pnpm start
```

### 3. Ejecutar en plataformas soportadas

```bash
# Android
pnpm android

# iOS (compila el core de Rust, instala pods y lanza en el simulador)
make run-ios-sim
```

Para iOS se usa `make run-ios-sim` en vez de `pnpm ios` porque además del bundle
JS hay que regenerar el xcframework de Rust e instalar pods con Ruby 3.3 — el
target lo hace todo en orden. Ver la sección [Desarrollo iOS](#desarrollo-ios).

## Desarrollo iOS

El core de Rust se expone a iOS mediante un xcframework (`ios/MiPTVCore.xcframework`)
y bindings Swift generados por UniFFI (`ios/generated/ffi_uniffi.swift`). Hay
targets de `make` que encadenan todo el pipeline (regenerar bindings → `pod install`
→ compilar) para que no tengas que recordar el orden ni la versión de Ruby:

```bash
# Compilar y lanzar en el simulador (arranca antes Metro en otra terminal: make metro)
make run-ios-sim

# Preparar build para iPhone físico (regenera xcframework device+sim y pods),
# luego compila desde Xcode con tu Team de signing configurado
make run-ios-device
```

Puedes cambiar el simulador con `make run-ios-sim SIMULATOR="iPhone 15 Pro"`.

### Cuándo regenerar el framework de Rust

Tras **cualquier cambio en `rust/crates/ffi-uniffi`** hay que regenerar los bindings
y el xcframework, o la compilación de Swift fallará (`MiPtvCore has no member …`):

```bash
make ios-framework-sim   # solo simulador (rápido)
make ios-framework       # device + simulador (necesario para iPhone físico)
```

> **Importante:** si cambia el conjunto de *slices* del xcframework (p. ej. añadir
> la de device), **reejecuta `make pods`** después. CocoaPods registra las slices
> en el momento del `pod install`; si no, el build de device falla con
> `cannot find type 'RustBuffer' in scope`. Los targets `make run-ios-*` ya lo hacen
> por ti.

## Desarrollo del core en Rust

```bash
cd rust
cargo test
cargo build
```

## Scripts útiles

Desde la carpeta app:

```bash
pnpm typecheck
pnpm lint
pnpm test
```

## Arquitectura general

La app sigue una separación clara de responsabilidades:

- la capa de UI vive en React Native y TypeScript
- la lógica de negocio y el procesamiento pesado se resuelven en Rust
- la comunicación entre JS y nativo se realiza a través de módulos nativos y bindings generados

Este diseño permite mantener la experiencia de usuario multiplataforma sin duplicar lógica crítica.

## Estado del proyecto

MiPTV se encuentra en desarrollo activo y su objetivo es convertirse en un cliente IPTV moderno, rápido y extensible, con soporte para múltiples plataformas y una base técnica compartida.

## Licencia

Este proyecto se distribuye bajo la licencia MIT.
