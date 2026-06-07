import Foundation
import UIKit
import Display
import SwiftSignalKit
import Postbox
import TelegramCore
import TelegramPresentationData
import ItemListUI
import AccountContext
import PresentationDataUtils
import UniformTypeIdentifiers
import TelegramUIPreferences

private final class SosuzagramSettingsControllerArguments {
    let context: AccountContext
    let toggleSkipReadHistory: (Bool) -> Void
    let toggleHideStoryViews: (Bool) -> Void
    let toggleHideTyping: (Bool) -> Void
    let toggleKeepLocalHistory: (Bool) -> Void
    let toggleShowMarker: (Bool) -> Void
    let toggleHideStories: (Bool) -> Void
    let toggleConfirmCalls: (Bool) -> Void
    let toggleConfirmVoiceMessages: (Bool) -> Void
    let selectIcon: (String) -> Void
    let importPlugins: () -> Void
    let togglePlugin: (String, Bool) -> Void
    
    init(
        context: AccountContext,
        toggleSkipReadHistory: @escaping (Bool) -> Void,
        toggleHideStoryViews: @escaping (Bool) -> Void,
        toggleHideTyping: @escaping (Bool) -> Void,
        toggleKeepLocalHistory: @escaping (Bool) -> Void,
        toggleShowMarker: @escaping (Bool) -> Void,
        toggleHideStories: @escaping (Bool) -> Void,
        toggleConfirmCalls: @escaping (Bool) -> Void,
        toggleConfirmVoiceMessages: @escaping (Bool) -> Void,
        selectIcon: @escaping (String) -> Void,
        importPlugins: @escaping () -> Void,
        togglePlugin: @escaping (String, Bool) -> Void
    ) {
        self.context = context
        self.toggleSkipReadHistory = toggleSkipReadHistory
        self.toggleHideStoryViews = toggleHideStoryViews
        self.toggleHideTyping = toggleHideTyping
        self.toggleKeepLocalHistory = toggleKeepLocalHistory
        self.toggleShowMarker = toggleShowMarker
        self.toggleHideStories = toggleHideStories
        self.toggleConfirmCalls = toggleConfirmCalls
        self.toggleConfirmVoiceMessages = toggleConfirmVoiceMessages
        self.selectIcon = selectIcon
        self.importPlugins = importPlugins
        self.togglePlugin = togglePlugin
    }
}

private enum SosuzagramSettingsSection: Int32 {
    case ghost
    case antiDelete
    case ui
    case icons
    case plugins
}

private enum SosuzagramSettingsEntry: ItemListNodeEntry {
    case ghostHeader(PresentationTheme, String)
    case skipReadHistoryToggle(PresentationTheme, String, Bool)
    case hideStoryViewsToggle(PresentationTheme, String, Bool)
    case hideTypingToggle(PresentationTheme, String, Bool)
    case ghostInfo(PresentationTheme, String)

    case antiDeleteHeader(PresentationTheme, String)
    case keepLocalHistoryToggle(PresentationTheme, String, Bool)
    case showMarkerToggle(PresentationTheme, String, Bool)
    case antiDeleteInfo(PresentationTheme, String)

    case uiHeader(PresentationTheme, String)
    case hideStoriesToggle(PresentationTheme, String, Bool)
    case confirmCallsToggle(PresentationTheme, String, Bool)
    case confirmVoiceMessagesToggle(PresentationTheme, String, Bool)

    case iconsHeader(PresentationTheme, String)
    case iconItem(PresentationTheme, String, String, Bool, Int32) // theme, title, iconName, isSelected, index

    case pluginsHeader(PresentationTheme, String)
    case importPluginsAction(PresentationTheme, String)
    case pluginItem(PresentationTheme, String, String, String, Bool, Int32) // theme, id, name, desc, isEnabled, index
    case pluginsInfo(PresentationTheme, String)
    
    var section: ItemListSectionId {
        switch self {
        case .ghostHeader, .skipReadHistoryToggle, .hideStoryViewsToggle, .hideTypingToggle, .ghostInfo:
            return SosuzagramSettingsSection.ghost.rawValue
        case .antiDeleteHeader, .keepLocalHistoryToggle, .showMarkerToggle, .antiDeleteInfo:
            return SosuzagramSettingsSection.antiDelete.rawValue
        case .uiHeader, .hideStoriesToggle, .confirmCallsToggle, .confirmVoiceMessagesToggle:
            return SosuzagramSettingsSection.ui.rawValue
        case .iconsHeader, .iconItem:
            return SosuzagramSettingsSection.icons.rawValue
        case .pluginsHeader, .importPluginsAction, .pluginItem, .pluginsInfo:
            return SosuzagramSettingsSection.plugins.rawValue
        }
    }
    
    var stableId: UInt64 {
        switch self {
        case .ghostHeader: return 0
        case .skipReadHistoryToggle: return 1
        case .hideStoryViewsToggle: return 2
        case .hideTypingToggle: return 3
        case .ghostInfo: return 4
        case .antiDeleteHeader: return 5
        case .keepLocalHistoryToggle: return 6
        case .showMarkerToggle: return 7
        case .antiDeleteInfo: return 8
        case .uiHeader: return 9
        case .hideStoriesToggle: return 10
        case .confirmCallsToggle: return 11
        case .confirmVoiceMessagesToggle: return 12
        case .iconsHeader: return 13
        case let .iconItem(_, _, _, _, index): return 100 + UInt64(index)
        case .pluginsHeader: return 200
        case .importPluginsAction: return 201
        case let .pluginItem(_, _, _, _, _, index): return 1000 + UInt64(index)
        case .pluginsInfo: return 2000
        }
    }
    
    var sortId: Int32 {
        switch self {
        case .ghostHeader: return 0
        case .skipReadHistoryToggle: return 1
        case .hideStoryViewsToggle: return 2
        case .hideTypingToggle: return 3
        case .ghostInfo: return 4
        case .antiDeleteHeader: return 5
        case .keepLocalHistoryToggle: return 6
        case .showMarkerToggle: return 7
        case .antiDeleteInfo: return 8
        case .uiHeader: return 9
        case .hideStoriesToggle: return 10
        case .confirmCallsToggle: return 11
        case .confirmVoiceMessagesToggle: return 12
        case .iconsHeader: return 13
        case let .iconItem(_, _, _, _, index): return 100 + index
        case .pluginsHeader: return 200
        case .importPluginsAction: return 201
        case let .pluginItem(_, _, _, _, _, index): return 1000 + index
        case .pluginsInfo: return 2000
        }
    }
    
    static func ==(lhs: SosuzagramSettingsEntry, rhs: SosuzagramSettingsEntry) -> Bool {
        switch lhs {
        case let .ghostHeader(lhsTheme, lhsText):
            if case let .ghostHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .skipReadHistoryToggle(lhsTheme, lhsText, lhsValue):
            if case let .skipReadHistoryToggle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .hideStoryViewsToggle(lhsTheme, lhsText, lhsValue):
            if case let .hideStoryViewsToggle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .hideTypingToggle(lhsTheme, lhsText, lhsValue):
            if case let .hideTypingToggle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .ghostInfo(lhsTheme, lhsText):
            if case let .ghostInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .antiDeleteHeader(lhsTheme, lhsText):
            if case let .antiDeleteHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .keepLocalHistoryToggle(lhsTheme, lhsText, lhsValue):
            if case let .keepLocalHistoryToggle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .showMarkerToggle(lhsTheme, lhsText, lhsValue):
            if case let .showMarkerToggle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .antiDeleteInfo(lhsTheme, lhsText):
            if case let .antiDeleteInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .uiHeader(lhsTheme, lhsText):
            if case let .uiHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .hideStoriesToggle(lhsTheme, lhsText, lhsValue):
            if case let .hideStoriesToggle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .confirmCallsToggle(lhsTheme, lhsText, lhsValue):
            if case let .confirmCallsToggle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .confirmVoiceMessagesToggle(lhsTheme, lhsText, lhsValue):
            if case let .confirmVoiceMessagesToggle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .iconsHeader(lhsTheme, lhsText):
            if case let .iconsHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .iconItem(lhsTheme, lhsTitle, lhsIcon, lhsSelected, lhsIndex):
            if case let .iconItem(rhsTheme, rhsTitle, rhsIcon, rhsSelected, rhsIndex) = rhs, lhsTheme === rhsTheme, lhsTitle == rhsTitle, lhsIcon == rhsIcon, lhsSelected == rhsSelected, lhsIndex == rhsIndex { return true }
            return false
        case let .pluginsHeader(lhsTheme, lhsText):
            if case let .pluginsHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .importPluginsAction(lhsTheme, lhsText):
            if case let .importPluginsAction(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .pluginItem(lhsTheme, lhsId, lhsName, lhsDesc, lhsEnabled, lhsIndex):
            if case let .pluginItem(rhsTheme, rhsId, rhsName, rhsDesc, rhsEnabled, rhsIndex) = rhs, lhsTheme === rhsTheme, lhsId == rhsId, lhsName == rhsName, lhsDesc == rhsDesc, lhsEnabled == rhsEnabled, lhsIndex == rhsIndex { return true }
            return false
        case let .pluginsInfo(lhsTheme, lhsText):
            if case let .pluginsInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        }
    }
    
    static func <(lhs: SosuzagramSettingsEntry, rhs: SosuzagramSettingsEntry) -> Bool {
        return lhs.sortId < rhs.sortId
    }
    
    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        let args = arguments as! SosuzagramSettingsControllerArguments
        switch self {
        case let .ghostHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .skipReadHistoryToggle(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { val in
                args.toggleSkipReadHistory(val)
            })
        case let .hideStoryViewsToggle(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { val in
                args.toggleHideStoryViews(val)
            })
        case let .hideTypingToggle(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { val in
                args.toggleHideTyping(val)
            })
        case let .ghostInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
            
        case let .antiDeleteHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .keepLocalHistoryToggle(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { val in
                args.toggleKeepLocalHistory(val)
            })
        case let .showMarkerToggle(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { val in
                args.toggleShowMarker(val)
            })
        case let .antiDeleteInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
            
        case let .uiHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .hideStoriesToggle(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { val in
                args.toggleHideStories(val)
            })
        case let .confirmCallsToggle(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { val in
                args.toggleConfirmCalls(val)
            })
        case let .confirmVoiceMessagesToggle(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { val in
                args.toggleConfirmVoiceMessages(val)
            })
            
        case let .iconsHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .iconItem(_, title, iconName, isSelected, _):
            return ItemListDisclosureItem(presentationData: presentationData, title: title, label: isSelected ? "✓" : "", sectionId: self.section, style: .blocks, action: {
                args.selectIcon(iconName)
            })
            
        case let .pluginsHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .importPluginsAction(_, title):
            return ItemListDisclosureItem(presentationData: presentationData, title: title, label: "+", sectionId: self.section, style: .blocks, action: {
                args.importPlugins()
            })
        case let .pluginItem(_, id, name, desc, isEnabled, _):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: name, value: isEnabled, sectionId: self.section, style: .blocks, updated: { val in
                args.togglePlugin(id, val)
            })
        case let .pluginsInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}

private func getPluginsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let dir = paths[0].appendingPathComponent("SosuzagramPlugins")
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
    return dir
}

private func getImportedPlugins() -> [ImportedPlugin] {
    let dir = getPluginsDirectory()
    guard let urls = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) else { return [] }
    var result: [ImportedPlugin] = []
    for url in urls {
        if url.pathExtension == "plugin" || url.pathExtension == "sosuzagramplugin" {
            if let p = parsePlugin(at: url) {
                result.append(p)
            }
        }
    }
    return result
}

private func sosuzagramSettingsEntries(
    presentationData: PresentationData,
    skipReadHistory: Bool,
    hideStoryViews: Bool,
    hideTyping: Bool,
    keepLocalHistory: Bool,
    showMarker: Bool,
    hideStories: Bool,
    confirmCalls: Bool,
    confirmVoiceMessages: Bool,
    currentIcon: String,
    plugins: [ImportedPlugin]
) -> [SosuzagramSettingsEntry] {
    var entries: [SosuzagramSettingsEntry] = []
    
    // 1. Ghost Mode
    entries.append(.ghostHeader(presentationData.theme, "GHOST MODE"))
    entries.append(.skipReadHistoryToggle(presentationData.theme, "Skip Read History", skipReadHistory))
    entries.append(.hideStoryViewsToggle(presentationData.theme, "Hide Story Views", hideStoryViews))
    entries.append(.hideTypingToggle(presentationData.theme, "Hide Typing status", hideTyping))
    entries.append(.ghostInfo(presentationData.theme, "Ghost Mode lets you read messages, watch stories, and type without sending notifications to the other party."))
    
    // 2. Anti-Delete
    entries.append(.antiDeleteHeader(presentationData.theme, "ANTI-DELETE"))
    entries.append(.keepLocalHistoryToggle(presentationData.theme, "Save Deleted Messages", keepLocalHistory))
    entries.append(.showMarkerToggle(presentationData.theme, "Show Deletion Marker", showMarker))
    entries.append(.antiDeleteInfo(presentationData.theme, "Keep deleted and edited messages locally. A trash icon will mark deleted messages."))
    
    // 3. UI Customization
    entries.append(.uiHeader(presentationData.theme, "UI CUSTOMIZATION & CONFIRMATIONS"))
    entries.append(.hideStoriesToggle(presentationData.theme, "Hide Stories in Chat List", hideStories))
    entries.append(.confirmCallsToggle(presentationData.theme, "Confirm voice/video calls", confirmCalls))
    entries.append(.confirmVoiceMessagesToggle(presentationData.theme, "Confirm voice message sending", confirmVoiceMessages))
    
    // 4. Alternate App Icons
    entries.append(.iconsHeader(presentationData.theme, "CUSTOM APP ICONS"))
    let icons = [
        ("Default", "nil"),
        ("Red (Exteragram style)", "Red"),
        ("Green (Exteragram style)", "Green"),
        ("Orange (Exteragram style)", "Orange"),
        ("Purple (Exteragram style)", "Purple")
    ]
    var iconIndex: Int32 = 0
    for (title, val) in icons {
        let isSelected = (currentIcon == val)
        entries.append(.iconItem(presentationData.theme, title, val, isSelected, iconIndex))
        iconIndex += 1
    }
    
    // 5. Plugins
    entries.append(.pluginsHeader(presentationData.theme, "IMPORTED PLUGINS"))
    entries.append(.importPluginsAction(presentationData.theme, "Import plugin (.plugin / .sosuzagramplugin)"))
    
    var pluginIndex: Int32 = 0
    for plugin in plugins {
        let isEnabled = UserDefaults.standard.object(forKey: "sosuzagram_plugin_enabled_\(plugin.id)") as? Bool ?? true
        entries.append(.pluginItem(presentationData.theme, plugin.id, plugin.name, plugin.desc, isEnabled, pluginIndex))
        pluginIndex += 1
    }
    entries.append(.pluginsInfo(presentationData.theme, "Plugins extend Sosuzagram functionality natively. Place .plugin files in the import folder to configure them."))
    
    return entries
}

class DocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {
    let completion: (URL) -> Void
    init(completion: @escaping (URL) -> Void) {
        self.completion = completion
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            completion(url)
        }
    }
}

private var activePickerDelegate: DocumentPickerDelegate?

public func sosuzagramSettingsController(context: AccountContext) -> ViewController {
    deployEmbeddedPluginsIfNeeded()
    let presentationData = context.sharedContext.currentPresentationData.with { $0 }
    
    let statePromise = ValuePromise<Bool>(true, ignoreRepeated: false)
    
    var updateSettingsImpl: (() -> Void)?
    
    let arguments = SosuzagramSettingsControllerArguments(
        context: context,
        toggleSkipReadHistory: { val in
            let _ = updateExperimentalUISettingsInteractively(accountManager: context.sharedContext.accountManager, { settings in
                var settings = settings
                settings.skipReadHistory = val
                return settings
            }).start()
            UserDefaults.standard.set(val, forKey: "sosuzagram_skip_read_history")
            updateSettingsImpl?()
        },
        toggleHideStoryViews: { val in
            UserDefaults.standard.set(val, forKey: "sosuzagram_hide_story_views")
            updateSettingsImpl?()
        },
        toggleHideTyping: { val in
            UserDefaults.standard.set(val, forKey: "sosuzagram_hide_typing")
            updateSettingsImpl?()
        },
        toggleKeepLocalHistory: { val in
            UserDefaults.standard.set(val, forKey: "sosuzagram_local_history")
            updateSettingsImpl?()
        },
        toggleShowMarker: { val in
            UserDefaults.standard.set(val, forKey: "sosuzagram_show_marker")
            updateSettingsImpl?()
        },
        toggleHideStories: { val in
            UserDefaults.standard.set(val, forKey: "sosuzagram_hide_stories")
            updateSettingsImpl?()
        },
        toggleConfirmCalls: { val in
            UserDefaults.standard.set(val, forKey: "sosuzagram_confirm_calls")
            updateSettingsImpl?()
        },
        toggleConfirmVoiceMessages: { val in
            UserDefaults.standard.set(val, forKey: "sosuzagram_confirm_voice_messages")
            updateSettingsImpl?()
        },
        selectIcon: { iconName in
            let targetName = (iconName == "nil" ? nil : iconName)
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(targetName) { error in
                    if let error = error {
                        print("Error setting alternate icon: \(error.localizedDescription)")
                    }
                }
            }
            UserDefaults.standard.set(iconName, forKey: "sosuzagram_current_icon")
            updateSettingsImpl?()
        },
        importPlugins: {
            let types: [UTType]
            if #available(iOS 14.0, *) {
                types = [UTType.data, UTType.item]
            } else {
                types = []
            }
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
            let delegate = DocumentPickerDelegate { url in
                let targetURL = getPluginsDirectory().appendingPathComponent(url.lastPathComponent)
                try? FileManager.default.removeItem(at: targetURL)
                try? FileManager.default.copyItem(at: url, to: targetURL)
                
                // Set default plugin value to true
                if let p = parsePlugin(at: targetURL) {
                    UserDefaults.standard.set(true, forKey: "sosuzagram_plugin_enabled_\(p.id)")
                }
                
                updateSettingsImpl?()
            }
            activePickerDelegate = delegate
            picker.delegate = delegate
            UIApplication.shared.keyWindow?.rootViewController?.present(picker, animated: true)
        },
        togglePlugin: { id, val in
            UserDefaults.standard.set(val, forKey: "sosuzagram_plugin_enabled_\(id)")
            updateSettingsImpl?()
        }
    )
    
    let signal = combineLatest(
        context.sharedContext.presentationData,
        context.sharedContext.accountManager.sharedData(keys: [ApplicationSpecificSharedDataKeys.experimentalUISettings]),
        statePromise.get()
    )
    |> map { presentationData, sharedData, _ -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let experimentalSettings = sharedData.entries[ApplicationSpecificSharedDataKeys.experimentalUISettings]?.get(ExperimentalUISettings.self) ?? ExperimentalUISettings.defaultSettings
        let skipReadHistory = experimentalSettings.skipReadHistory
        
        let hideStoryViews = UserDefaults.standard.bool(forKey: "sosuzagram_hide_story_views")
        let hideTyping = UserDefaults.standard.bool(forKey: "sosuzagram_hide_typing")
        let keepLocalHistory = UserDefaults.standard.object(forKey: "sosuzagram_local_history") as? Bool ?? true
        let showMarker = UserDefaults.standard.object(forKey: "sosuzagram_show_marker") as? Bool ?? true
        let hideStories = UserDefaults.standard.bool(forKey: "sosuzagram_hide_stories")
        let confirmCalls = UserDefaults.standard.bool(forKey: "sosuzagram_confirm_calls")
        let confirmVoiceMessages = UserDefaults.standard.bool(forKey: "sosuzagram_confirm_voice_messages")
        let currentIcon = UserDefaults.standard.string(forKey: "sosuzagram_current_icon") ?? "nil"
        let plugins = getImportedPlugins()
        
        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("Sosuzagram Settings"),
            leftNavigationButton: nil,
            rightNavigationButton: nil,
            backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
        )
        
        let entries = sosuzagramSettingsEntries(
            presentationData: presentationData,
            skipReadHistory: skipReadHistory,
            hideStoryViews: hideStoryViews,
            hideTyping: hideTyping,
            keepLocalHistory: keepLocalHistory,
            showMarker: showMarker,
            hideStories: hideStories,
            confirmCalls: confirmCalls,
            confirmVoiceMessages: confirmVoiceMessages,
            currentIcon: currentIcon,
            plugins: plugins
        )
        
        let listState = ItemListNodeState(
            presentationData: ItemListPresentationData(presentationData),
            entries: entries,
            style: .blocks,
            animateChanges: false
        )
        
        return (controllerState, (listState, arguments))
    }
    
    let controller = ItemListController(context: context, state: signal)
    updateSettingsImpl = {
        statePromise.set(true)
    }
    
    return controller
}
