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

echo "Patching Make.py for GBOX-friendly build flags..."
MAKE_PY="$UPSTREAM_DIR/build-system/Make/Make.py"
if [ -f "$MAKE_PY" ]; then
    MAKE_PY_COMPAT="$(python_compatible_path "$MAKE_PY")"
    python3 - "$MAKE_PY_COMPAT" <<'PY'
import sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

if "self.disable_extensions = False" not in content:
    content = content.replace(
        "        self.disable_provisioning_profiles = False\n        self.profile_swift = False\n",
        "        self.disable_provisioning_profiles = False\n        self.disable_extensions = False\n        self.profile_swift = False\n"
    )

if "def set_disable_extensions(self):" not in content:
    content = content.replace(
        "    def set_disable_provisioning_profiles(self):\n        self.disable_provisioning_profiles = True\n\n    def set_profile_swift(self, value):\n",
        "    def set_disable_provisioning_profiles(self):\n        self.disable_provisioning_profiles = True\n\n    def set_disable_extensions(self):\n        self.disable_extensions = True\n\n    def set_profile_swift(self, value):\n"
    )

if "combined_arguments += ['--//Telegram:disableExtensions']" not in content:
    content = content.replace(
        "        if self.disable_provisioning_profiles:\n            combined_arguments += ['--//Telegram:disableProvisioningProfiles']\n\n        combined_arguments += self.common_args\n",
        "        if self.disable_provisioning_profiles:\n            combined_arguments += ['--//Telegram:disableProvisioningProfiles']\n        if self.disable_extensions:\n            combined_arguments += ['--//Telegram:disableExtensions']\n\n        combined_arguments += self.common_args\n",
        1
    )
    content = content.replace(
        "        if self.disable_provisioning_profiles:\n            combined_arguments += ['--//Telegram:disableProvisioningProfiles']\n\n        combined_arguments += self.common_args\n",
        "        if self.disable_provisioning_profiles:\n            combined_arguments += ['--//Telegram:disableProvisioningProfiles']\n        if self.disable_extensions:\n            combined_arguments += ['--//Telegram:disableExtensions']\n\n        combined_arguments += self.common_args\n",
        1
    )

if "if disable_extensions:\n        bazel_command_line.set_disable_extensions()" not in content:
    content = content.replace(
        "    if arguments.target is not None:\n        target_name = arguments.target\n    \n    call_executable(['killall', 'Xcode'], check_result=False)\n",
        "    if arguments.target is not None:\n        target_name = arguments.target\n    if disable_extensions:\n        bazel_command_line.set_disable_extensions()\n    if disable_provisioning_profiles:\n        bazel_command_line.set_disable_provisioning_profiles()\n    \n    call_executable(['killall', 'Xcode'], check_result=False)\n"
    )

if "if getattr(arguments, 'disableExtensions', False):\n        bazel_command_line.set_disable_extensions()" not in content:
    content = content.replace(
        "    bazel_command_line.set_profile_swift(arguments.profileSwift)\n\n    bazel_command_line.set_split_swiftmodules(arguments.enableParallelSwiftmoduleGeneration)\n\n    bazel_command_line.invoke_build()\n",
        "    bazel_command_line.set_profile_swift(arguments.profileSwift)\n\n    bazel_command_line.set_split_swiftmodules(arguments.enableParallelSwiftmoduleGeneration)\n    if getattr(arguments, 'disableExtensions', False):\n        bazel_command_line.set_disable_extensions()\n    if getattr(arguments, 'disableProvisioningProfiles', False):\n        bazel_command_line.set_disable_provisioning_profiles()\n\n    bazel_command_line.invoke_build()\n"
    )
    content = content.replace(
        "    bazel_command_line.set_enable_sandbox(False)\n    bazel_command_line.set_split_swiftmodules(False)\n\n    bazel_command_line.invoke_spm_build()\n",
        "    bazel_command_line.set_enable_sandbox(False)\n    bazel_command_line.set_split_swiftmodules(False)\n    if getattr(arguments, 'disableExtensions', False):\n        bazel_command_line.set_disable_extensions()\n    if getattr(arguments, 'disableProvisioningProfiles', False):\n        bazel_command_line.set_disable_provisioning_profiles()\n\n    bazel_command_line.invoke_spm_build()\n"
    )

if "--disableExtensions" not in content:
    content = content.replace(
        "    buildParser.add_argument(\n        '--lock',\n        action='store_true',\n        default=False,\n        help='Respect MODULE.bazel.lock.'\n    )\n",
        "    buildParser.add_argument(\n        '--disableExtensions',\n        action='store_true',\n        default=False,\n        help='''\n            Build the main app without app extensions.\n            Useful for sideload signing with a single provisioning profile.\n            '''\n    )\n    buildParser.add_argument(\n        '--disableProvisioningProfiles',\n        action='store_true',\n        default=False,\n        help='''\n            Build without embedding provisioning profiles in Bazel targets.\n            Useful when preparing an IPA for external resigning.\n            '''\n    )\n    buildParser.add_argument(\n        '--lock',\n        action='store_true',\n        default=False,\n        help='Respect MODULE.bazel.lock.'\n    )\n"
    )

with open(path, "w", encoding="utf-8") as f:
    f.write(content)
PY
else
    echo "Warning: Make.py not found at $MAKE_PY"
fi

echo "Patching provisioning profile copy script for no-extension builds..."
COPY_PROFILES_SH="$UPSTREAM_DIR/build-system/copy-provisioning-profiles-Telegram.sh"
if [ -f "$COPY_PROFILES_SH" ]; then
    COPY_PROFILES_SH_COMPAT="$(python_compatible_path "$COPY_PROFILES_SH")"
    python3 - "$COPY_PROFILES_SH_COMPAT" <<'PY'
import sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

old_block = """\tPROFILES_TYPE=\"$1\"\n\tcase \"$PROFILES_TYPE\" in\n\t\tdevelopment)\n\t\t\tEXPECTED_VARIABLES=(\\\n\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_APP \\\n\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_SHARE \\\n\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_WIDGET \\\n\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONSERVICE \\\n\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONCONTENT \\\n\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_INTENTS \\\n\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_WATCH_APP \\\n\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_WATCH_EXTENSION \\\n\t\t\t)\n\t\t\t;;\n\t\tdistribution)\n\t\t\tEXPECTED_VARIABLES=(\\\n\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_APP \\\n\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_SHARE \\\n\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_WIDGET \\\n\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONSERVICE \\\n\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONCONTENT \\\n\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_INTENTS \\\n\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_WATCH_APP \\\n\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_WATCH_EXTENSION \\\n\t\t\t)\n\t\t    ;;\n\t\t*)\n\t\t    echo \"Unknown build provisioning type: $PROFILES_TYPE\"\n\t\t    exit 1\n\t\t    ;;\n\tesac\n\n\tEXPECTED_VARIABLE_NAMES=(\\\n\t\tTelegram \\\n\t\tShare \\\n\t\tWidget \\\n\t\tNotificationService \\\n\t\tNotificationContent \\\n\t\tIntents \\\n\t\tWatchApp \\\n\t\tWatchExtension \\\n\t)\n"""

new_block = """\tPROFILES_TYPE=\"$1\"\n\tcase \"$PROFILES_TYPE\" in\n\t\tdevelopment)\n\t\t\t;;\n\t\tdistribution)\n\t\t    ;;\n\t\t*)\n\t\t    echo \"Unknown build provisioning type: $PROFILES_TYPE\"\n\t\t    exit 1\n\t\t    ;;\n\tesac\n\n\tif [ \"$TELEGRAM_DISABLE_EXTENSIONS\" = \"1\" ]; then\n\t\tcase \"$PROFILES_TYPE\" in\n\t\t\tdevelopment)\n\t\t\t\tEXPECTED_VARIABLES=(DEVELOPMENT_PROVISIONING_PROFILE_APP)\n\t\t\t\t;;\n\t\t\tdistribution)\n\t\t\t\tEXPECTED_VARIABLES=(DISTRIBUTION_PROVISIONING_PROFILE_APP)\n\t\t\t\t;;\n\t\tesac\n\n\t\tEXPECTED_VARIABLE_NAMES=(Telegram)\n\telse\n\t\tcase \"$PROFILES_TYPE\" in\n\t\t\tdevelopment)\n\t\t\t\tEXPECTED_VARIABLES=(\\\n\t\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_APP \\\n\t\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_SHARE \\\n\t\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_WIDGET \\\n\t\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONSERVICE \\\n\t\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONCONTENT \\\n\t\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_INTENTS \\\n\t\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_WATCH_APP \\\n\t\t\t\t\tDEVELOPMENT_PROVISIONING_PROFILE_WATCH_EXTENSION \\\n\t\t\t\t)\n\t\t\t\t;;\n\t\t\tdistribution)\n\t\t\t\tEXPECTED_VARIABLES=(\\\n\t\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_APP \\\n\t\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_SHARE \\\n\t\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_WIDGET \\\n\t\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONSERVICE \\\n\t\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONCONTENT \\\n\t\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_INTENTS \\\n\t\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_WATCH_APP \\\n\t\t\t\t\tDISTRIBUTION_PROVISIONING_PROFILE_WATCH_EXTENSION \\\n\t\t\t\t)\n\t\t\t\t;;\n\t\tesac\n\n\t\tEXPECTED_VARIABLE_NAMES=(\\\n\t\t\tTelegram \\\n\t\t\tShare \\\n\t\t\tWidget \\\n\t\t\tNotificationService \\\n\t\t\tNotificationContent \\\n\t\t\tIntents \\\n\t\t\tWatchApp \\\n\t\t\tWatchExtension \\\n\t\t)\n\tfi\n"""

if "TELEGRAM_DISABLE_EXTENSIONS" not in content and old_block in content:
    content = content.replace(old_block, new_block)

with open(path, "w", encoding="utf-8") as f:
    f.write(content)
PY
else
    echo "Warning: copy-provisioning-profiles-Telegram.sh not found at $COPY_PROFILES_SH"
fi

echo "Patching Telegram BUILD entitlements for no-app-group mode..."
TELEGRAM_BUILD="$UPSTREAM_DIR/Telegram/BUILD"
if [ -f "$TELEGRAM_BUILD" ]; then
    TELEGRAM_BUILD_COMPAT="$(python_compatible_path "$TELEGRAM_BUILD")"
    python3 - "$TELEGRAM_BUILD_COMPAT" <<'PY'
import sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

old_fragment = """plist_fragment(\n    name = \"TelegramEntitlements\",\n    extension = \"entitlements\",\n    template = \"\".join([\n        aps_fragment,\n        app_groups_fragment,\n        siri_fragment,\n        associated_domains_fragment,\n        icloud_fragment,\n        apple_pay_merchants_fragment,\n        unrestricted_voip_fragment,\n        carplay_fragment,\n        communication_notifications_fragment,\n        notification_filtering_fragment,\n        signin_fragment,\n        background_gpu_fragment,\n    ])\n)\n"""

new_fragment = old_fragment + """\nplist_fragment(\n    name = \"TelegramEntitlementsNoAppGroups\",\n    extension = \"entitlements\",\n    template = \"\".join([\n        aps_fragment,\n        siri_fragment,\n        associated_domains_fragment,\n        icloud_fragment,\n        apple_pay_merchants_fragment,\n        unrestricted_voip_fragment,\n        carplay_fragment,\n        communication_notifications_fragment,\n        notification_filtering_fragment,\n        signin_fragment,\n        background_gpu_fragment,\n    ])\n)\n"""

if "TelegramEntitlementsNoAppGroups" not in content and old_fragment in content:
    content = content.replace(old_fragment, new_fragment)

content = content.replace(
    '    entitlements = ":TelegramEntitlements.entitlements",\n',
    '    entitlements = select({\n        ":disableExtensionsSetting": ":TelegramEntitlementsNoAppGroups.entitlements",\n        "//conditions:default": ":TelegramEntitlements.entitlements",\n    }),\n',
    4
)

with open(path, "w", encoding="utf-8") as f:
    f.write(content)
PY
else
    echo "Warning: Telegram BUILD not found at $TELEGRAM_BUILD"
fi

echo "Patching AppDelegate for missing app-group fallback..."
APP_DELEGATE_SWIFT="$UPSTREAM_DIR/submodules/TelegramUI/Sources/AppDelegate.swift"
if [ -f "$APP_DELEGATE_SWIFT" ]; then
    APP_DELEGATE_SWIFT_COMPAT="$(python_compatible_path "$APP_DELEGATE_SWIFT")"
    python3 - "$APP_DELEGATE_SWIFT_COMPAT" <<'PY'
import sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

if "import SosuzagramIOSCore" not in content:
    content = content.replace(
        "import ContextControllerImpl\n",
        "import ContextControllerImpl\nimport SosuzagramIOSCore\n"
    )

if "private func sosuzagramResolveContainerUrl(for bundleId: String)" not in content:
    content = content.replace(
        "private func isKeyboardViewContainer(view: NSObject) -> Bool {\n    let typeName = NSStringFromClass(type(of: view))\n    if typeName.hasPrefix(\"UI\") && typeName.hasSuffix(\"InputSetContainerView\") {\n        return true\n    }\n    return false\n}\n",
        "private func isKeyboardViewContainer(view: NSObject) -> Bool {\n    let typeName = NSStringFromClass(type(of: view))\n    if typeName.hasPrefix(\"UI\") && typeName.hasSuffix(\"InputSetContainerView\") {\n        return true\n    }\n    return false\n}\n\nprivate func sosuzagramAppGroupName(for bundleId: String) -> String {\n    return \"group.\\(bundleId)\"\n}\n\nprivate func sosuzagramFallbackContainerUrl(for bundleId: String) -> URL {\n    let fileManager = FileManager.default\n    let baseUrl = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first\n        ?? fileManager.urls(for: .documentDirectory, in: .userDomainMask).first\n        ?? URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)\n    let containerUrl = baseUrl\n        .appendingPathComponent(\"SosuzagramContainer\", isDirectory: true)\n        .appendingPathComponent(bundleId, isDirectory: true)\n    try? fileManager.createDirectory(at: containerUrl, withIntermediateDirectories: true)\n    return containerUrl\n}\n\nprivate func sosuzagramResolveContainerUrl(for bundleId: String) -> (url: URL, usesAppGroup: Bool) {\n    let appGroupName = sosuzagramAppGroupName(for: bundleId)\n    if let appGroupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName) {\n        return (appGroupUrl, true)\n    } else {\n        Logger.shared.log(\"AppDelegate\", \"App Group \\(appGroupName) is unavailable for \\(bundleId). Falling back to Application Support container.\")\n        return (sosuzagramFallbackContainerUrl(for: bundleId), false)\n    }\n}\n"
    )

old_url_session = """        let baseAppBundleId = Bundle.main.bundleIdentifier!\n        let appGroupName = \"group.\\(baseAppBundleId)\"\n\n        let configuration = URLSessionConfiguration.background(withIdentifier: identifier)\n        configuration.sharedContainerIdentifier = appGroupName\n"""
new_url_session = """        let baseAppBundleId = Bundle.main.bundleIdentifier!\n        let resolvedContainer = sosuzagramResolveContainerUrl(for: baseAppBundleId)\n\n        let configuration = URLSessionConfiguration.background(withIdentifier: identifier)\n        if resolvedContainer.usesAppGroup {\n            configuration.sharedContainerIdentifier = sosuzagramAppGroupName(for: baseAppBundleId)\n        }\n"""
if old_url_session in content:
    content = content.replace(old_url_session, new_url_session)

old_startup = """        let baseAppBundleId = Bundle.main.bundleIdentifier!\n        let appGroupName = \"group.\\(baseAppBundleId)\"\n        let maybeAppGroupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)\n        \n        let buildConfig = BuildConfig(baseAppBundleId: baseAppBundleId)\n"""
new_startup = """        let baseAppBundleId = Bundle.main.bundleIdentifier!\n        let resolvedContainer = sosuzagramResolveContainerUrl(for: baseAppBundleId)\n        let appGroupUrl = resolvedContainer.url\n        \n        let buildConfig = BuildConfig(baseAppBundleId: baseAppBundleId)\n"""
if old_startup in content:
    content = content.replace(old_startup, new_startup)

old_guard = """        guard let appGroupUrl = maybeAppGroupUrl else {\n            self.mainWindow?.presentNative(UIAlertController(title: nil, message: \"Error 2\", preferredStyle: .alert))\n            return true\n        }\n        \n"""
if old_guard in content:
    content = content.replace(old_guard, "")

with open(path, "w", encoding="utf-8") as f:
    f.write(content)
PY
else
    echo "Warning: AppDelegate.swift not found at $APP_DELEGATE_SWIFT"
fi

echo "Configuring Bazel repository cache..."
cat >> "$UPSTREAM_DIR/.bazelrc" <<'EOF'

# Sosuzagram custom cache options
build --repository_cache=/Users/runner/telegram-bazel-cache/repository_cache
query --repository_cache=/Users/runner/telegram-bazel-cache/repository_cache
EOF

echo "Overlay and patches applied successfully!"
