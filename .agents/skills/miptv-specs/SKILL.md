---
name: miptv-specs
description: Read and enforce the technical specifications and architectural guidelines for the MiPTV IPTV Flutter application. Trigger this skill when modifying code, creating features, writing tests, or reviewing architecture.
---

# MiPTV Specifications and Architectural Guidelines

This skill ensures that all code contributions, feature implementations, and refactoring efforts align with the official **MiPTV MVP v0.1 Specifications** defined in the project.

## Specification Source of Truth
The primary specification file is located at:
- [SPECS.md](file:///Users/jmolina/Documents/github/MiPTV/specs/SPECS.md) (or `../specs/SPECS.md` relative to the Flutter app root directory).

Whenever executing tasks or answering questions about the codebase structure, models, or patterns, refer to this specification.

---

## 🛠️ Technology Stack & Dependencies

Ensure all code uses these specific technologies. Do not introduce alternative libraries without authorization:

| Layer / Concern | Approved Technology |
| :--- | :--- |
| **UI Framework** | Flutter (Single codebase for Android & iOS) |
| **State Management** | Riverpod |
| **Navigation** | GoRouter |
| **Networking** | Dio |
| **Database** | Isar (local database) |
| **Credentials** | Flutter Secure Storage |
| **Media Player** | MediaKit |
| **Image Caching** | CachedNetworkImage |
| **Model Generation** | Freezed + JsonSerializable |

---

## 🏗️ Architecture: Feature First + Clean Architecture

The codebase layout follows a **Feature First** combined with **Clean Architecture** approach. Structure the `lib/` directory accordingly:

```text
lib/
├── app/               # App-wide configurations, themes, router
├── core/              # Shared components, utilities, network clients, database service
└── features/          # Feature folders (domain-driven design)
    ├── provider/      # Xtream provider login/setup
    ├── home/          # Home screen with favorites & categories
    ├── categories/    # Category browsing
    ├── streams/       # Channel lists
    ├── favorites/     # Favoriting functionality
    └── player/        # Media playback screen & controls
```

Each feature under `features/` must be partitioned into three layers:
1. `data/`: Data sources, repositories implementations, Isar schemas, API models.
2. `domain/`: Domain entities, repository interfaces, use cases.
3. `presentation/`: Riverpod providers, UI widgets, screens/views.

---

## 🔄 Core Application Flow

All navigation and user flows must follow this sequence:
1. **Splash Screen**: Check session / credentials.
2. **Add Provider Screen**: Input server URL and username (password is securely entered).
3. **Synchronize Categories**: Fetch and cache Live TV categories upon adding the provider.
4. **Home Screen**: Show horizontal favorites carrousel, category list, and provider management.
5. **Select Category**: Navigate to the category page.
6. **Lazy Sync Channels**: Sincronize channels of the selected category on the first visit only.
7. **Channel List**: Display list of channels.
8. **Player Screen**: Play the selected stream dynamically.

---

## 💾 Domain Models & Schema Rules

Ensure the Isar models are defined with exactly these properties:

### 1. Provider
- Fields: `id`, `server`, `username`
- ⚠️ **CRITICAL SECURITY RULE**: The password **MUST NOT** be stored in Isar. It must be stored only in **Flutter Secure Storage**.

### 2. Category
- Fields: `id`, `name`

### 3. Stream (Channel)
- Fields: `id`, `name`, `logo`, `categoryId`, `extension`
- ⚠️ **CRITICAL RULE**: Do not store the full stream URL in the database. Construct it dynamically (see below).

### 4. Favorite
- Fields: `streamId`, `createdAt`
- ⚠️ **CRITICAL RULE**: Store favorites in an independent collection to survive synchronization runs.

### 5. CategorySync
- Fields: `categoryId`, `lastSync`, `isSyncing`, `streamCount`

---

## ⚡ Performance Guidelines

Performance is a key goal (smooth scrolling at 60/120 FPS, startup < 2s). Adhere strictly to these rules:

1. **Heavy Operations**: Any JSON parsing, massive DB writes, or model mapping must run in a separate isolate using `Isolate.run()` to prevent UI freezes.
2. **Virtualization**: Use `ListView.builder` for all lists. Avoid `SingleChildScrollView`, `Column` (for long lists), or `ListView(children: ...)` that render all items upfront.
3. **Optimized Lists**: Set `itemExtent` on ListViews, use `const` widgets aggressively, and minimize global rebuilds.
4. **Isar Queries**: Do not load all streams/channels into Riverpod state memory. Stream/query them dynamically from Isar as needed.
5. **URL Construction**: Always build the playback URL dynamically:
   `server_url` + `/live/` + `username` + `/` + `password` + `/` + `streamId` + `extension`
   This avoids credential leakage and migration issues.

---

## 🪵 Logging & Error Handling

- **Logging**: Log all major events (Login, Sincronización, Descarga, Player Errors, API failures).
- **Error Handling**: Gracefully catch and display user-friendly messages for:
  - Network timeouts
  - Offline status (use cached data offline)
  - Bad credentials
  - Invalid stream files / format
  - Player loading failures

---

## 🚫 MVP Out-of-Scope Features

Do **NOT** implement the following features in this version:
- VOD Movies or TV Series (Live TV only)
- Electronic Program Guide (EPG)
- Downloads / Offline Playback
- Chromecast / AirPlay
- Picture-in-Picture (PiP)
- Multi-user / Multi-provider management
