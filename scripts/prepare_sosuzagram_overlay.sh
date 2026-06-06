#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/upstream/Telegram-iOS"
OVERLAY_DIR="$ROOT_DIR/overlay/Sosuzagram"

if [ ! -d "$UPSTREAM_DIR" ]; then
  echo "Run scripts/bootstrap_telegram_ios.sh first" >&2
  exit 1
fi

mkdir -p "$OVERLAY_DIR/Sources"
cp -R "$ROOT_DIR/Sources/SosuzagramIOSCore" "$OVERLAY_DIR/Sources/"
cat > "$OVERLAY_DIR/README.md" <<'TEXT'
# Sosuzagram overlay

This overlay contains the local-history core module that must be wired into Telegram-iOS update handling and UI.

Integration targets:
- record incoming message snapshots when cloud-chat messages arrive
- mark stored snapshots when normal cloud-chat remove events arrive
- skip private encrypted / TTL flows
- expose Extra Settings -> Privacy Mods -> Local History
TEXT

printf 'Overlay prepared at %s\n' "$OVERLAY_DIR"
