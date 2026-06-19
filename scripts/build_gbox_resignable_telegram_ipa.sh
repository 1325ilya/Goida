#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/upstream/Telegram-iOS"
CONFIG_PATH="$UPSTREAM_DIR/build-system/template_minimal_development_configuration.json"
ARTIFACTS_DIR="$ROOT_DIR/build/artifacts/gbox"
BUILD_NUMBER="${BUILD_NUMBER:-65}"
BUILD_CONFIGURATION="${BUILD_CONFIGURATION:-release_arm64}"
DISABLE_EXTENSIONS="${DISABLE_EXTENSIONS:-0}"

if [ ! -d "$UPSTREAM_DIR/build-system" ]; then
  echo "Telegram-iOS build-system not found: $UPSTREAM_DIR" >&2
  exit 1
fi

if [ ! -f "$CONFIG_PATH" ]; then
  echo "Build configuration not found: $CONFIG_PATH" >&2
  exit 1
fi

if [ ! -d "$UPSTREAM_DIR/build-system/fake-codesigning" ]; then
  echo "fake-codesigning directory not found" >&2
  exit 1
fi

cd "$UPSTREAM_DIR"

python3 build-system/Make/ImportCertificates.py --path build-system/fake-codesigning/certs

rm -rf "$ARTIFACTS_DIR"
mkdir -p "$ARTIFACTS_DIR"

BUILD_ARGS=(
  --cacheDir="${TELEGRAM_BAZEL_CACHE_DIR:-$HOME/telegram-bazel-cache}"
  --overrideXcodeVersion
  --overrideBazelVersion
  build
  --configurationPath="$CONFIG_PATH"
  --configuration="$BUILD_CONFIGURATION"
  --buildNumber="$BUILD_NUMBER"
  --codesigningInformationPath=build-system/fake-codesigning
  --outputBuildArtifactsPath="$ARTIFACTS_DIR"
)
if [ "$DISABLE_EXTENSIONS" = "1" ]; then
  BUILD_ARGS+=(--disableExtensions)
fi
python3 build-system/Make/Make.py "${BUILD_ARGS[@]}"

if [ ! -f "$ARTIFACTS_DIR/Telegram.ipa" ]; then
  echo "Expected IPA not found at $ARTIFACTS_DIR/Telegram.ipa" >&2
  exit 1
fi

cp "$ARTIFACTS_DIR/Telegram.ipa" "$ARTIFACTS_DIR/Sosuzagram-Telegram-iOS-gbox-resignable.ipa"

echo "GBOX-friendly IPA ready:"
echo "  $ARTIFACTS_DIR/Sosuzagram-Telegram-iOS-gbox-resignable.ipa"
