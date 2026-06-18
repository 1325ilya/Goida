#!/usr/bin/env bash
set -euo pipefail

APP_NAME="BurmalGram"
BUNDLE_ID="com.vonexl.sosuzagram"
BUILD_DIR="build/ios"
PAYLOAD_DIR="$BUILD_DIR/Payload"
APP_DIR="$PAYLOAD_DIR/$APP_NAME.app"
SDK_PATH="$(xcrun --sdk iphoneos --show-sdk-path)"

rm -rf "$BUILD_DIR"
mkdir -p "$APP_DIR"

xcrun swiftc \
  -parse-as-library \
  -target arm64-apple-ios17.0 \
  -sdk "$SDK_PATH" \
  -O \
  App/SosuzagramApp.swift \
  -o "$APP_DIR/$APP_NAME"

cat > "$APP_DIR/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleDisplayName</key>
    <string>BurmalGram</string>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>BurmalGram</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>0.1.0</string>
    <key>CFBundleVersion</key>
    <string>2</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>MinimumOSVersion</key>
    <string>17.0</string>
    <key>UILaunchScreen</key>
    <dict/>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
</dict>
</plist>
PLIST

codesign --force --sign - "$APP_DIR/$APP_NAME" >/dev/null 2>&1 || true
codesign --force --sign - "$APP_DIR" >/dev/null 2>&1 || true

mkdir -p "$BUILD_DIR/artifacts"
(
  cd "$BUILD_DIR"
  zip -qry "artifacts/BurmalGram-ios26-unsigned.ipa" Payload
)

ls -lah "$BUILD_DIR/artifacts"
