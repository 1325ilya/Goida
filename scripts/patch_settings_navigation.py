import os
import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: python patch_settings_navigation.py <upstream_dir>")
        sys.exit(1)
        
    upstream_dir = sys.argv[1]
    
    screen_path = os.path.join(upstream_dir, "submodules", "TelegramUI", "Components", "PeerInfo", "PeerInfoScreen", "Sources", "PeerInfoScreen.swift")
    items_path = os.path.join(upstream_dir, "submodules", "TelegramUI", "Components", "PeerInfo", "PeerInfoScreen", "Sources", "PeerInfoSettingsItems.swift")
    actions_path = os.path.join(upstream_dir, "submodules", "TelegramUI", "Components", "PeerInfo", "PeerInfoScreen", "Sources", "PeerInfoScreenSettingsActions.swift")
    build_path = os.path.join(upstream_dir, "submodules", "TelegramUI", "Components", "PeerInfo", "PeerInfoScreen", "BUILD")
    
    print("Patching settings navigation...")
    
    # 1. Patch PeerInfoScreen.swift
    if os.path.exists(screen_path):
        with open(screen_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Add import
        if "import SosuzagramIOSCore" not in content:
            content = "import SosuzagramIOSCore\n" + content
            
        # Add enum case
        if "case sosuzagramSettings" not in content:
            content = content.replace(
                "enum PeerInfoSettingsSection {",
                "enum PeerInfoSettingsSection {\n    case sosuzagramSettings"
            )
            
        with open(screen_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Patched PeerInfoScreen.swift")
    else:
        print(f"Error: {screen_path} not found")

    # 2. Patch PeerInfoSettingsItems.swift
    if os.path.exists(items_path):
        with open(items_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Add import
        if "import SosuzagramIOSCore" not in content:
            content = "import SosuzagramIOSCore\n" + content
            
        # Add menu item in advanced settings
        target_item = 'interaction.openSettings(.privacyAndSecurity)\n    }))'
        replacement = 'interaction.openSettings(.privacyAndSecurity)\n    }))\n    items[.advanced]!.append(PeerInfoScreenDisclosureItem(id: 100, text: "Настройки BurmalGram", icon: PresentationResourcesSettings.security, action: {\n        interaction.openSettings(.sosuzagramSettings)\n    }))'
        
        if 'interaction.openSettings(.sosuzagramSettings)' not in content:
            content = content.replace(target_item, replacement)
            
        with open(items_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Patched PeerInfoSettingsItems.swift")
    else:
        print(f"Error: {items_path} not found")

    # 3. Patch PeerInfoScreenSettingsActions.swift
    if os.path.exists(actions_path):
        with open(actions_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Add import
        if "import SosuzagramIOSCore" not in content:
            content = "import SosuzagramIOSCore\n" + content
            
        # Add case in switch
        target_case = 'case .chatFolders:'
        replacement = 'case .sosuzagramSettings:\n            push(sosuzagramSettingsController(context: self.context))\n        case .chatFolders:'
        
        if 'case .sosuzagramSettings:' not in content:
            content = content.replace(target_case, replacement)
            
        with open(actions_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Patched PeerInfoScreenSettingsActions.swift")
    else:
        print(f"Error: {actions_path} not found")

    # 4. Patch PeerInfoScreen BUILD deps
    if os.path.exists(build_path):
        with open(build_path, 'r', encoding='utf-8') as f:
            content = f.read()

        dep = '        "//submodules/SosuzagramIOSCore:SosuzagramIOSCore",\n'
        if dep not in content:
            marker = '        "//submodules/TelegramUI/Components/PeerInfo/AccountPeerContextItem",\n'
            if marker in content:
                content = content.replace(marker, marker + dep)
            else:
                deps_start = '    deps = [\n'
                if deps_start in content:
                    content = content.replace(deps_start, deps_start + dep, 1)

        with open(build_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Patched PeerInfoScreen BUILD")
    else:
        print(f"Error: {build_path} not found")

if __name__ == "__main__":
    main()
