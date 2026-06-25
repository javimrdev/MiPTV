#!/usr/bin/env bash
# Tizen .wgt packaging script for MiPTV
# Prerequisites: Tizen Studio CLI (tizen command) must be in PATH
# Usage: ./tizen/package.sh [--sign]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
APP_DIR="$ROOT_DIR/app"
BUILD_DIR="$APP_DIR/web-dist"
PACKAGE_DIR="$SCRIPT_DIR/package"
WGT_NAME="MiPTV.wgt"

echo "==> Building React Native Web bundle..."
cd "$APP_DIR"
pnpm run web:build

echo "==> Preparing Tizen package directory..."
rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR"

# Copy web bundle
cp -r "$BUILD_DIR"/* "$PACKAGE_DIR/"

# Copy Tizen config
cp "$SCRIPT_DIR/config.xml" "$PACKAGE_DIR/"

# Copy icon (placeholder if missing)
if [ -f "$SCRIPT_DIR/icon.png" ]; then
  cp "$SCRIPT_DIR/icon.png" "$PACKAGE_DIR/"
else
  echo "WARN: icon.png not found in tizen/ — add a 512x512 PNG named icon.png"
fi

echo "==> Packaging .wgt..."
cd "$PACKAGE_DIR"
zip -r "../$WGT_NAME" .

echo "==> Done: $SCRIPT_DIR/$WGT_NAME"
echo ""
echo "To install on a connected TV:"
echo "  tizen install -n $SCRIPT_DIR/$WGT_NAME"
