#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/upstream/Telegram-iOS"
CONFIG_FILE="$UPSTREAM_DIR/build-system/template_minimal_development_configuration.json"

if [ ! -d "$UPSTREAM_DIR/build-system" ]; then
  echo "Error: Telegram-iOS build-system directory not found in $UPSTREAM_DIR" >&2
  exit 1
fi

# Configuration (overridden to match fake-codesigning profiles for Bazel)
API_ID="${TELEGRAM_API_ID:-25759243}"
API_HASH="${TELEGRAM_API_HASH:-0621d95b074463ca881894b6e008d838}"
BUNDLE_ID="ph.telegra.Telegraph"
TEAM_ID="C67CF9S4VU"
APP_TITLE="${APP_TITLE:-Sosuzagram}"

if [ -z "$API_ID" ] || [ -z "$API_HASH" ]; then
  echo "Error: TELEGRAM_API_ID and TELEGRAM_API_HASH environment variables are required." >&2
  exit 1
fi

echo "Generating minimal development configuration for Telegram-iOS..."

cat > "$CONFIG_FILE" <<EOF
{
    "api_id": "$API_ID",
    "api_hash": "$API_HASH",
    "team_id": "$TEAM_ID",
    "bundle_id": "$BUNDLE_ID",
    "apiEnvironment": "production",
    "backupInfo": null,
    "buildNumber": "1000",
    "appstore_id": "0",
    "app_specific_url_scheme": "tg",
    "presentationEnvironment": "production",
    "is_internal_build": "true",
    "is_appstore_build": "false",
    "app_center_id": "0",
    "premium_iap_product_id": "org.telegram.premium",
    "enable_siri": "false",
    "enable_icloud": "false",
    "developmentTeam": "$TEAM_ID",
    "developmentCodeSigningIdentity": "Apple Development",
    "developmentProvisioningProfile": "match Development $BUNDLE_ID"
}
EOF

echo "Build configuration generated."
