#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/upstream/Telegram-iOS"
CHECK_DIR="$ROOT_DIR/upstream/Telegram-iOS-android-check"
SOURCE_CORE_DIR="$ROOT_DIR/Sources/SosuzagramIOSCore"
TARGET_CORE_DIR="$CHECK_DIR/submodules/SosuzagramIOSCore"
PATCH1="$ROOT_DIR/overlay/Sosuzagram/Patches/0001-sosuzagram-all-changes.patch"
PATCH2="$ROOT_DIR/overlay/Sosuzagram/Patches/0002-sosuzagram-android-design.patch"

assert_contains() {
  local file="$1"
  local pattern="$2"
  if ! grep -Fq "$pattern" "$file"; then
    echo "Expected pattern not found in $file: $pattern" >&2
    exit 1
  fi
}

if [ ! -d "$UPSTREAM_DIR" ]; then
  echo "Missing upstream repository: $UPSTREAM_DIR" >&2
  exit 1
fi

if [ ! -d "$SOURCE_CORE_DIR" ]; then
  echo "Missing source core directory: $SOURCE_CORE_DIR" >&2
  exit 1
fi

if [ ! -f "$PATCH1" ] || [ ! -f "$PATCH2" ]; then
  echo "Missing Android Design overlay patches." >&2
  exit 1
fi

if [ ! -d "$CHECK_DIR/.git" ] && [ ! -f "$CHECK_DIR/.git" ]; then
  git -C "$UPSTREAM_DIR" worktree add --force "$CHECK_DIR" HEAD >/dev/null
fi

git -C "$CHECK_DIR" reset --hard HEAD >/dev/null
git -C "$CHECK_DIR" clean -fd >/dev/null

rm -rf "$TARGET_CORE_DIR"
mkdir -p "$TARGET_CORE_DIR"
cp -R "$SOURCE_CORE_DIR/"* "$TARGET_CORE_DIR/"

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
    ],
    visibility = ["//visibility:public"],
)
EOF

git -C "$CHECK_DIR" apply --whitespace=nowarn --check "$PATCH1"
git -C "$CHECK_DIR" apply --whitespace=nowarn "$PATCH1"
git -C "$CHECK_DIR" apply --whitespace=nowarn --check "$PATCH2"
git -C "$CHECK_DIR" apply --whitespace=nowarn "$PATCH2"

assert_contains "$CHECK_DIR/submodules/ChatListUI/Sources/Node/ChatListItem.swift" "conversation cards"
assert_contains "$CHECK_DIR/submodules/TelegramUI/Components/Chat/ReplyAccessoryPanelNode/BUILD" "//submodules/SosuzagramIOSCore:SosuzagramIOSCore"
assert_contains "$CHECK_DIR/submodules/TelegramUI/Components/Chat/ReplyAccessoryPanelNode/Sources/ReplyAccessoryPanelNode.swift" "reply accessory panel"
assert_contains "$CHECK_DIR/submodules/TelegramUI/Components/ChatList/ChatListFilterTabContainerNode/Sources/ChatListFilterTabContainerNode.swift" "filter chips"
assert_contains "$CHECK_DIR/submodules/TelegramUI/Components/ChatListHeaderComponent/Sources/ChatListNavigationBar.swift" "sosuzagramMaterialDesignLevelForCurrentMode()"
assert_contains "$CHECK_DIR/submodules/TelegramPresentationData/Sources/SosuzagramMaterial3Manager.swift" "public func sosuzagramMaterialDesignLevelForCurrentMode() -> Int"
assert_contains "$CHECK_DIR/submodules/SosuzagramIOSCore/SosuzagramSettingsController.swift" "sosuzagramApplyAndroidDesignPreset(value)"

echo "ANDROID_DESIGN_OVERLAY_OK"
