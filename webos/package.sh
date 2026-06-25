#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WEBOS_DIR="$REPO_ROOT/webos"
STAGING_DIR="$WEBOS_DIR/staging"
OUT_DIR="$WEBOS_DIR/out"
APP_DIR="$REPO_ROOT/app"

# Build the React Native Web bundle
echo "Building React Native Web bundle..."
(cd "$APP_DIR" && pnpm run web:build)

# Prepare staging directory
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

# Copy web build output
cp -r "$APP_DIR/web-dist/." "$STAGING_DIR/"

# Copy webOS app metadata and icons
cp "$WEBOS_DIR/appinfo.json" "$STAGING_DIR/"
cp "$WEBOS_DIR/icon.png" "$STAGING_DIR/"
cp "$WEBOS_DIR/largeIcon.png" "$STAGING_DIR/"

# Package with ares-package
mkdir -p "$OUT_DIR"
echo "Packaging with ares-package..."
ares-package "$STAGING_DIR" -o "$OUT_DIR"

echo "Done. IPK written to $OUT_DIR/"
ls "$OUT_DIR/"*.ipk 2>/dev/null || echo "Warning: no .ipk found in $OUT_DIR"
