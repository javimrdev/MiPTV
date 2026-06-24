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
- Rust toolchain (stable)
- Xcode Command Line Tools para desarrollo iOS
- Android Studio / Android SDK para desarrollo Android

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

# iOS
pnpm ios
```

## Desarrollo del core en Rust

```bash
cd rust
cargo test
cargo build
```

Para generar el framework de iOS para el módulo nativo:

```bash
make ios-framework
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
