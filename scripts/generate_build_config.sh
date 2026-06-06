#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/upstream/Telegram-iOS"
CONFIG_FILE="$UPSTREAM_DIR/build-system/template_minimal_development_configuration.json"

if [ ! -d "$UPSTREAM_DIR/build-system" ]; then
  echo "Error: Telegram-iOS build-system directory not found in $UPSTREAM_DIR" >&2
  exit 1
fi

API_ID="${TELEGRAM_API_ID:-}"
API_HASH="${TELEGRAM_API_HASH:-}"
TEAM_ID="${TEAM_ID:-0000000000}"
BUNDLE_ID="${BUNDLE_ID:-org.sosuzagram.ios}"
APP_TITLE="${APP_TITLE:-Sosuzagram}"

if [ -z "$API_ID" ] || [ -z "$API_HASH" ]; then
  echo "Error: TELEGRAM_API_ID and TELEGRAM_API_HASH environment variables are required." >&2
  exit 1
fi

echo "Generating minimal development configuration for Telegram-iOS..."

cat > "$CONFIG_FILE" <<EOF
{
    "apiId": "$API_ID",
    "apiHash": "$API_HASH",
    "teamId": "$TEAM_ID",
    "bundleId": "$BUNDLE_ID",
    "apiEnvironment": "production",
    "backupInfo": null,
    "buildNumber": "1000",
    "appStoreId": "0",
    "appSpecificUrlScheme": "tg",
    "presentationEnvironment": "production",
    "isInternalBuild": true,
    "isAppStoreBuild": false,
    "developmentTeam": "$TEAM_ID",
    "developmentCodeSigningIdentity": "Apple Development",
    "developmentProvisioningProfile": "match Development $BUNDLE_ID"
}
EOF

echo "Build configuration generated."
