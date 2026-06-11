#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/upstream/Telegram-iOS"
REPO_URL="https://github.com/TelegramMessenger/Telegram-iOS.git"

mkdir -p "$ROOT_DIR/upstream"

PINNED_COMMIT="ffd82647ee97c68e4da4802fe9717ccccd8105c9"

if [ ! -d "$UPSTREAM_DIR/.git" ]; then
  git clone --depth 1 "$REPO_URL" "$UPSTREAM_DIR"
fi

git -C "$UPSTREAM_DIR" fetch --depth 1 origin "$PINNED_COMMIT"
git -C "$UPSTREAM_DIR" checkout FETCH_HEAD
git -C "$UPSTREAM_DIR" submodule update --init --recursive --depth 1

printf '\nSosuzagram upstream workspace is ready:\n%s\n' "$UPSTREAM_DIR"
printf '\nNext files to inspect:\n'
find "$UPSTREAM_DIR" -maxdepth 2 \( -name 'Package.swift' -o -name 'README.md' -o -name 'versions.json' \) -print | sed "s|$ROOT_DIR/||"
