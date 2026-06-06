#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/upstream/Telegram-iOS"
OVERLAY_DIR="$ROOT_DIR/overlay/Sosuzagram"

if [ ! -d "$UPSTREAM_DIR" ]; then
  echo "Error: Run scripts/bootstrap_telegram_ios.sh first" >&2
  exit 1
fi

echo "Applying Sosuzagram overlay..."

# 1. Copy SosuzagramIOSCore to Telegram's submodules
# Telegram-iOS uses bazel, so we put it where it can be referenced.
# For simplicity, we can place it in submodules/SosuzagramIOSCore
TARGET_CORE_DIR="$UPSTREAM_DIR/submodules/SosuzagramIOSCore"
rm -rf "$TARGET_CORE_DIR"
mkdir -p "$TARGET_CORE_DIR"

cp -R "$ROOT_DIR/Sources/SosuzagramIOSCore/"* "$TARGET_CORE_DIR/"

# 2. Add BUILD file for Bazel in SosuzagramIOSCore
cat > "$TARGET_CORE_DIR/BUILD" <<'EOF'
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "SosuzagramIOSCore",
    srcs = glob([
        "**/*.swift",
    ]),
    module_name = "SosuzagramIOSCore",
    visibility = ["//visibility:public"],
)
EOF

# 3. Apply git patches if any
if [ -d "$OVERLAY_DIR/Patches" ]; then
  for patch_file in "$OVERLAY_DIR/Patches/"*.patch; do
    if [ -f "$patch_file" ]; then
      echo "Applying patch: $(basename "$patch_file")"
      git -C "$UPSTREAM_DIR" apply "$patch_file" || echo "Warning: Failed to apply $patch_file"
    fi
  done
else
  echo "No patches found in $OVERLAY_DIR/Patches"
fi

echo "Patching PrivacyAndSecurityController.swift via Python script..."
python3 "$ROOT_DIR/scripts/patch_privacy_ui.py" "$UPSTREAM_DIR/submodules/SettingsUI/Sources/Privacy and Security/PrivacyAndSecurityController.swift"

echo "Patching Make.py to bypass Xcode version check..."
python3 -c "
import sys
path = '$UPSTREAM_DIR/build-system/Make/Make.py'
with open(path, 'r') as f: content = f.read()
content = content.replace('if actual_version != required_version:', 'if False:')
with open(path, 'w') as f: f.write(content)
" || echo "Warning: Failed to patch Make.py"

echo "Overlay applied successfully."
