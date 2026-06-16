#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/upstream/Telegram-iOS"
OVERLAY_DIR="$ROOT_DIR/overlay/Sosuzagram"

python_compatible_path() {
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -w "$1"
  else
    printf '%s' "$1"
  fi
}

if [ ! -d "$UPSTREAM_DIR" ]; then
  echo "Error: Run scripts/bootstrap_telegram_ios.sh first" >&2
  exit 1
fi

echo "Applying Sosuzagram overlay..."

# 0. Generate embedded plugins Swift file
python3 "$ROOT_DIR/scripts/generate_embedded_plugins.py"

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
    deps = [
        "//submodules/Display:Display",
        "//submodules/SSignalKit/SwiftSignalKit:SwiftSignalKit",
        "//submodules/Postbox:Postbox",
        "//submodules/TelegramCore:TelegramCore",
        "//submodules/TelegramPresentationData:TelegramPresentationData",
        "//submodules/ItemListUI:ItemListUI",
        "//submodules/AccountContext:AccountContext",
        "//submodules/PresentationDataUtils:PresentationDataUtils",
        "//submodules/TelegramUIPreferences:TelegramUIPreferences",
        "//submodules/LegacyMediaPickerUI:LegacyMediaPickerUI",
        "//submodules/AlertUI:AlertUI",
        "//submodules/SettingsUI:SettingsUI",
    ],
    visibility = ["//visibility:public"],
)
EOF

# 3. Apply git patches if any
if [ -d "$OVERLAY_DIR/Patches" ]; then
  for patch_file in "$OVERLAY_DIR/Patches/"*.patch; do
    if [ -f "$patch_file" ]; then
      echo "Applying patch: $(basename "$patch_file")"
      if git -C "$UPSTREAM_DIR" apply --whitespace=nowarn --check "$patch_file" >/dev/null 2>&1; then
        git -C "$UPSTREAM_DIR" apply --whitespace=nowarn "$patch_file" || { echo "Error: Failed to apply $patch_file" >&2; exit 1; }
      elif git -C "$UPSTREAM_DIR" apply --whitespace=nowarn --reverse --check "$patch_file" >/dev/null 2>&1; then
        echo "Patch already applied, skipping: $(basename "$patch_file")"
      else
        echo "Error: Failed to apply $patch_file" >&2
        exit 1
      fi
    fi
  done
else
  echo "No patches found in $OVERLAY_DIR/Patches"
fi

echo "Patching PrivacyAndSecurityController.swift via Python script..."
python3 "$ROOT_DIR/scripts/patch_privacy_ui.py" "$UPSTREAM_DIR/submodules/SettingsUI/Sources/Privacy and Security/PrivacyAndSecurityController.swift"

echo "Copying alternate icons..."
cp -R "$OVERLAY_DIR/Telegram-iOS/"*.alticon "$UPSTREAM_DIR/Telegram/Telegram-iOS/"
echo "Patching alternate icons and app display name..."
python3 "$ROOT_DIR/scripts/patch_alternate_icons.py" "$UPSTREAM_DIR"

echo "Patching settings navigation..."
python3 "$ROOT_DIR/scripts/patch_settings_navigation.py" "$UPSTREAM_DIR"

echo "Patching BuildEnvironment.py to bypass Xcode version check..."
BUILD_ENV_PY="$UPSTREAM_DIR/build-system/Make/BuildEnvironment.py"
if [ -f "$BUILD_ENV_PY" ]; then
    BUILD_ENV_PY_COMPAT="$(python_compatible_path "$BUILD_ENV_PY")"
    python3 - "$BUILD_ENV_PY_COMPAT" <<'PY' || echo "Warning: Failed to patch BuildEnvironment.py"
import sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    content = f.read()
content = content.replace("if actual_version != required_version:", "if False:")
with open(path, "w", encoding="utf-8") as f:
    f.write(content)
PY
else
    echo "Warning: BuildEnvironment.py not found at $BUILD_ENV_PY"
fi

# Bypass aps-environment check in BuildConfiguration.py
BUILD_CONFIG_PY="$UPSTREAM_DIR/build-system/Make/BuildConfiguration.py"
if [ -f "$BUILD_CONFIG_PY" ]; then
    BUILD_CONFIG_PY_COMPAT="$(python_compatible_path "$BUILD_CONFIG_PY")"
    python3 - "$BUILD_CONFIG_PY_COMPAT" <<'PY'
import sys
with open(sys.argv[1], 'r') as f:
    content = f.read()

# Replace resolve_aps_environment_from_directory body with return 'development'
import re
new_content = re.sub(
    r'def resolve_aps_environment_from_directory\(source_path, team_id, bundle_id\):[\s\S]*?(?=\ndef )',
    'def resolve_aps_environment_from_directory(source_path, team_id, bundle_id):\n    return \'production\'',
    content
)

with open(sys.argv[1], 'w') as f:
    f.write(new_content)
PY
    
    # Verify patch success
    if ! grep -q "return 'production'" "$BUILD_CONFIG_PY"; then
        echo "Error: Failed to patch BuildConfiguration.py"
        exit 1
    fi
    echo "Successfully patched BuildConfiguration.py to bypass aps-environment check."
else
    echo "Warning: BuildConfiguration.py not found at $BUILD_CONFIG_PY"
fi

# Fix delete-keychain bug in ImportCertificates.py
IMPORT_CERTS_PY="$UPSTREAM_DIR/build-system/Make/ImportCertificates.py"
if [ -f "$IMPORT_CERTS_PY" ]; then
    IMPORT_CERTS_PY_COMPAT="$(python_compatible_path "$IMPORT_CERTS_PY")"
    python3 - "$IMPORT_CERTS_PY_COMPAT" <<'PY' || echo "Warning: Failed to patch ImportCertificates.py"
import sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    content = f.read()
content = content.replace("arguments=['delete-keychain']", "arguments=['delete-keychain', keychain_name]")
with open(path, "w", encoding="utf-8") as f:
    f.write(content)
PY
    echo "Patched ImportCertificates.py keychain deletion bug."
else
    echo "Warning: ImportCertificates.py not found at $IMPORT_CERTS_PY"
fi

echo "Configuring Bazel repository cache..."
cat >> "$UPSTREAM_DIR/.bazelrc" <<'EOF'

# Sosuzagram custom cache options
build --repository_cache=/Users/runner/telegram-bazel-cache/repository_cache
query --repository_cache=/Users/runner/telegram-bazel-cache/repository_cache
EOF

echo "Overlay and patches applied successfully!"
