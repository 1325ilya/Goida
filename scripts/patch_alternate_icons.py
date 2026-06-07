import os
import sys
import re

def main():
    if len(sys.argv) < 2:
        print("Usage: python patch_alternate_icons.py <upstream_dir>")
        sys.exit(1)
        
    upstream_dir = sys.argv[1]
    plist_path = os.path.join(upstream_dir, "Telegram", "Telegram-iOS", "AlternateIcons.plist")
    ipad_plist_path = os.path.join(upstream_dir, "Telegram", "Telegram-iOS", "AlternateIcons-iPad.plist")
    build_path = os.path.join(upstream_dir, "Telegram", "BUILD")
    
    print(f"Patching alternate icons for: {upstream_dir}")

    # 1. Update AlternateIcons.plist
    if os.path.exists(plist_path):
        with open(plist_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        new_keys = """
    <key>Red</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>RedIcon</string>
            <string>RedNotificationIcon</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <true/>
    </dict>
    <key>Green</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>GreenIcon</string>
            <string>GreenNotificationIcon</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <true/>
    </dict>
    <key>Orange</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>OrangeIcon</string>
            <string>OrangeNotificationIcon</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <true/>
    </dict>
    <key>Purple</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>PurpleIcon</string>
            <string>PurpleNotificationIcon</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <true/>
    </dict>"""
        
        if "<key>Red</key>" not in content:
            content = content.replace("<dict>", "<dict>" + new_keys, 1)
            
        with open(plist_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Updated AlternateIcons.plist")
    else:
        print(f"Warning: {plist_path} not found")

    # 2. Update AlternateIcons-iPad.plist
    if os.path.exists(ipad_plist_path):
        with open(ipad_plist_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        new_ipad_keys = """
    <key>Red</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>RedIconIpad</string>
            <string>RedIconLargeIpad</string>
            <string>RedNotificationIcon</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <true/>
    </dict>
    <key>Green</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>GreenIconIpad</string>
            <string>GreenIconLargeIpad</string>
            <string>GreenNotificationIcon</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <true/>
    </dict>
    <key>Orange</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>OrangeIconIpad</string>
            <string>OrangeIconLargeIpad</string>
            <string>OrangeNotificationIcon</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <true/>
    </dict>
    <key>Purple</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>PurpleIconIpad</string>
            <string>PurpleIconLargeIpad</string>
            <string>PurpleNotificationIcon</string>
        </array>
        <key>UIPrerenderedIcon</key>
        <true/>
    </dict>"""
        
        if "<key>Red</key>" not in content:
            content = content.replace("<dict>", "<dict>" + new_ipad_keys, 1)
            
        with open(ipad_plist_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Updated AlternateIcons-iPad.plist")
    else:
        print(f"Warning: {ipad_plist_path} not found")

    # 3. Update Telegram/BUILD
    if os.path.exists(build_path):
        with open(build_path, 'r', encoding='utf-8') as f:
            build_content = f.read()

        # Add alternate icon folders to alternate_icon_folders array
        if '"RedIcon"' not in build_content:
            build_content = re.sub(
                r'(alternate_icon_folders\s*=\s*\[)([^\]]*)',
                r'\1\2    "RedIcon",\n    "GreenIcon",\n    "OrangeIcon",\n    "PurpleIcon",\n',
                build_content
            )

        # Replace CFBundleDisplayName and CFBundleName in TelegramInfoPlist
        build_content = re.sub(
            r'<key>CFBundleDisplayName</key>\s*<string>Telegram</string>',
            r'<key>CFBundleDisplayName</key>\n    <string>Sosuzagram</string>',
            build_content
        )
        build_content = re.sub(
            r'<key>CFBundleName</key>\s*<string>Telegram</string>',
            r'<key>CFBundleName</key>\n    <string>Sosuzagram</string>',
            build_content
        )

        # Replace CFBundleDisplayName in AppNameInfoPlist
        build_content = build_content.replace(
            'name = "AppNameInfoPlist",\n    extension = "plist",\n    template =\n    """\n    <key>CFBundleDisplayName</key>\n    <string>Telegram</string>',
            'name = "AppNameInfoPlist",\n    extension = "plist",\n    template =\n    """\n    <key>CFBundleDisplayName</key>\n    <string>Sosuzagram</string>'
        )

        with open(build_path, 'w', encoding='utf-8') as f:
            f.write(build_content)
        print("Updated Telegram/BUILD with alternate icons and Sosuzagram display name")
    else:
        print(f"Warning: {build_path} not found")

if __name__ == "__main__":
    main()
