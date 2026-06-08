import Foundation
import UIKit
import UniformTypeIdentifiers
import Display
import SwiftSignalKit
import Postbox
import TelegramCore
import TelegramPresentationData
import ItemListUI
import AccountContext
import PresentationDataUtils
import TelegramUIPreferences
import LegacyMediaPickerUI
import AlertUI

private struct SosuzagramSettingsControllerArguments {
    let context: AccountContext
    let toggleSkipReadHistory: (Bool) -> Void
    let toggleHideStoryViews: (Bool) -> Void
    let toggleHideTyping: (Bool) -> Void
    let toggleKeepLocalHistory: (Bool) -> Void
    let toggleShowMarker: (Bool) -> Void
    let toggleHideStories: (Bool) -> Void
    let toggleConfirmCalls: (Bool) -> Void
    let toggleConfirmVoiceMessages: (Bool) -> Void
    let toggleHideShareButton: (Bool) -> Void
    let togglePollResultsBeforeVoting: (Bool) -> Void
    let toggleHideKeyboardOnScroll: (Bool) -> Void
    let toggleHideSendAsButton: (Bool) -> Void
    let toggleReplaceEditedWithIcon: (Bool) -> Void
    let toggleHideFloatingButton: (Bool) -> Void
    let toggleHideAllChatsTab: (Bool) -> Void
    let toggleHideGreetingSticker: (Bool) -> Void
    let toggleHideStickerTimestamp: (Bool) -> Void
    let selectIcon: (String) -> Void
    let openPlugin: (String) -> Void
    let importPlugin: () -> Void
}

private enum SosuzagramSettingsSection: Int32 {
    case ghost
    case antiDelete
    case ui
    case icons
    case plugins
}

private struct SosuzagramSettingsEntry: ItemListNodeEntry {
    let section: ItemListSectionId
    let stableId: UInt64
    let sortId: Int32
    let signature: String
    let buildItem: (ItemListPresentationData, SosuzagramSettingsControllerArguments) -> ListViewItem

    static func == (lhs: SosuzagramSettingsEntry, rhs: SosuzagramSettingsEntry) -> Bool {
        return lhs.section == rhs.section
            && lhs.stableId == rhs.stableId
            && lhs.sortId == rhs.sortId
            && lhs.signature == rhs.signature
    }

    static func < (lhs: SosuzagramSettingsEntry, rhs: SosuzagramSettingsEntry) -> Bool {
        return lhs.sortId < rhs.sortId
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        return self.buildItem(presentationData, arguments as! SosuzagramSettingsControllerArguments)
    }
}

private func sosuzagramPluginImportDirectory() throws -> URL {
    let fileManager = FileManager.default
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        throw NSError(domain: "SosuzagramPluginImport", code: 1, userInfo: [NSLocalizedDescriptionKey: "Documents directory is unavailable."])
    }
    let pluginDirectory = documentsDirectory.appendingPathComponent("SosuzagramPlugins", isDirectory: true)
    try fileManager.createDirectory(at: pluginDirectory, withIntermediateDirectories: true, attributes: nil)
    return pluginDirectory
}

private func sosuzagramSanitizedPluginComponent(_ value: String) -> String {
    let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_-"))
    let sanitized = value.unicodeScalars.map { allowed.contains($0) ? String($0) : "_" }.joined()
    let trimmed = sanitized.trimmingCharacters(in: CharacterSet(charactersIn: "_"))
    return trimmed.isEmpty ? "plugin" : trimmed
}

private func sosuzagramImportPluginFile(from sourceURL: URL) throws -> ImportedPlugin {
    let fileManager = FileManager.default
    let plugin = try parsePlugin(at: sourceURL)
    let directory = try sosuzagramPluginImportDirectory()
    let fileName = "\(sosuzagramSanitizedPluginComponent(plugin.id))_\(sosuzagramSanitizedPluginComponent(plugin.version)).sosuzagramplugin"
    let targetURL = directory.appendingPathComponent(fileName, isDirectory: false)
    if fileManager.fileExists(atPath: targetURL.path) {
        try fileManager.removeItem(at: targetURL)
    }
    try fileManager.copyItem(at: sourceURL, to: targetURL)
    return plugin
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
    hideShareButton: Bool,
    pollResultsBeforeVoting: Bool,
    hideKeyboardOnScroll: Bool,
    hideSendAsButton: Bool,
    replaceEditedWithIcon: Bool,
    hideFloatingButton: Bool,
    hideAllChatsTab: Bool,
    hideGreetingSticker: Bool,
    hideStickerTimestamp: Bool,
    currentIcon: String,
    plugins: [SosuzagramPluginDescriptor]
) -> [SosuzagramSettingsEntry] {
    let theme = presentationData.theme
    var entries: [SosuzagramSettingsEntry] = []

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 0,
        sortId: 0,
        signature: "ghost-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "Режим призрака", sectionId: SosuzagramSettingsSection.ghost.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 1,
        sortId: 1,
        signature: "skip:\(skipReadHistory)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Не отмечать историю как прочитанную", value: skipReadHistory, sectionId: SosuzagramSettingsSection.ghost.rawValue, style: .blocks, updated: { value in
                arguments.toggleSkipReadHistory(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 2,
        sortId: 2,
        signature: "storyviews:\(hideStoryViews)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрывать просмотры историй", value: hideStoryViews, sectionId: SosuzagramSettingsSection.ghost.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideStoryViews(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 3,
        sortId: 3,
        signature: "typing:\(hideTyping)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрывать статус набора текста", value: hideTyping, sectionId: SosuzagramSettingsSection.ghost.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideTyping(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 4,
        sortId: 4,
        signature: "ghost-info",
        buildItem: { presentationData, _ in
            ItemListTextItem(presentationData: presentationData, text: .plain("Позволяет читать сообщения, смотреть истории и писать без лишних уведомлений для собеседника."), sectionId: SosuzagramSettingsSection.ghost.rawValue)
        }
    ))

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.antiDelete.rawValue,
        stableId: 5,
        sortId: 5,
        signature: "anti-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "Антиудаление", sectionId: SosuzagramSettingsSection.antiDelete.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.antiDelete.rawValue,
        stableId: 6,
        sortId: 6,
        signature: "history:\(keepLocalHistory)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Сохранять удалённые сообщения", value: keepLocalHistory, sectionId: SosuzagramSettingsSection.antiDelete.rawValue, style: .blocks, updated: { value in
                arguments.toggleKeepLocalHistory(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.antiDelete.rawValue,
        stableId: 7,
        sortId: 7,
        signature: "marker:\(showMarker)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Показывать метку удаления", value: showMarker, sectionId: SosuzagramSettingsSection.antiDelete.rawValue, style: .blocks, updated: { value in
                arguments.toggleShowMarker(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.antiDelete.rawValue,
        stableId: 8,
        sortId: 8,
        signature: "anti-info",
        buildItem: { presentationData, _ in
            ItemListTextItem(presentationData: presentationData, text: .plain("Локально сохраняет удалённые и отредактированные сообщения. Удалённые сообщения можно помечать отдельной меткой."), sectionId: SosuzagramSettingsSection.antiDelete.rawValue)
        }
    ))

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 9,
        sortId: 9,
        signature: "ui-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "Интерфейс и подтверждения", sectionId: SosuzagramSettingsSection.ui.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 10,
        sortId: 10,
        signature: "stories:\(hideStories)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрывать истории в списке чатов", value: hideStories, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideStories(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 11,
        sortId: 11,
        signature: "confirmcalls:\(confirmCalls)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Подтверждать голосовые и видеозвонки", value: confirmCalls, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleConfirmCalls(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 12,
        sortId: 12,
        signature: "confirmvoice:\(confirmVoiceMessages)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Подтверждать отправку голосовых", value: confirmVoiceMessages, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleConfirmVoiceMessages(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 13,
        sortId: 13,
        signature: "hideshare:\(hideShareButton)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрывать боковую кнопку «Поделиться»", value: hideShareButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideShareButton(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 14,
        sortId: 14,
        signature: "pollpreview:\(pollResultsBeforeVoting)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Показывать итоги опросов до голосования", value: pollResultsBeforeVoting, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.togglePollResultsBeforeVoting(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 15,
        sortId: 15,
        signature: "hidekeyboard:\(hideKeyboardOnScroll)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрывать клавиатуру при прокрутке", value: hideKeyboardOnScroll, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideKeyboardOnScroll(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 16,
        sortId: 16,
        signature: "hidesendas:\(hideSendAsButton)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрыть кнопку «Отправить как...»", value: hideSendAsButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideSendAsButton(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 17,
        sortId: 17,
        signature: "editedicon:\(replaceEditedWithIcon)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Заменять «изменено» иконкой", value: replaceEditedWithIcon, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleReplaceEditedWithIcon(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 18,
        sortId: 18,
        signature: "hidefloating:\(hideFloatingButton)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрыть плавающую кнопку", value: hideFloatingButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideFloatingButton(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 19,
        sortId: 19,
        signature: "hideallchatstab:\(hideAllChatsTab)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрыть вкладку «Все чаты»", value: hideAllChatsTab, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideAllChatsTab(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 20,
        sortId: 20,
        signature: "hidegreetingsticker:\(hideGreetingSticker)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрыть приветственный стикер", value: hideGreetingSticker, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideGreetingSticker(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 21,
        sortId: 21,
        signature: "hidestickertimestamp:\(hideStickerTimestamp)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрыть время на стикерах", value: hideStickerTimestamp, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideStickerTimestamp(value)
            })
        }
    ))

    let icons = [
        ("Стандартная", "nil"),
        ("Красная (Extera style)", "Red"),
        ("Зелёная (Extera style)", "Green"),
        ("Оранжевая (Extera style)", "Orange"),
        ("Фиолетовая (Extera style)", "Purple")
    ]
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 13,
        sortId: 13,
        signature: "icons-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "Иконки приложения", sectionId: SosuzagramSettingsSection.icons.rawValue)
        }
    ))
    for (index, icon) in icons.enumerated() {
        let isSelected = currentIcon == icon.1
        entries.append(SosuzagramSettingsEntry(
            section: SosuzagramSettingsSection.icons.rawValue,
            stableId: UInt64(100 + index),
            sortId: Int32(100 + index),
            signature: "icon:\(icon.1):\(isSelected)",
            buildItem: { presentationData, arguments in
                ItemListDisclosureItem(
                    presentationData: presentationData,
                    systemStyle: .glass,
                    title: icon.0,
                    label: isSelected ? "Выбрано" : "",
                    sectionId: SosuzagramSettingsSection.icons.rawValue,
                    style: .blocks,
                    disclosureStyle: .none,
                    action: {
                        arguments.selectIcon(icon.1)
                    }
                )
            }
        ))
    }

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.plugins.rawValue,
        stableId: 200,
        sortId: 200,
        signature: "plugins-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "Плагины Extera (iOS)", sectionId: SosuzagramSettingsSection.plugins.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.plugins.rawValue,
        stableId: 201,
        sortId: 201,
        signature: "plugins-import",
        buildItem: { presentationData, arguments in
            ItemListActionItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "Загрузить .plugin",
                kind: .generic,
                alignment: .natural,
                sectionId: SosuzagramSettingsSection.plugins.rawValue,
                style: .blocks,
                action: {
                    arguments.importPlugin()
                }
            )
        }
    ))

    for (index, plugin) in plugins.enumerated() {
        let status = sosuzagramPluginEnabled(plugin.id) ? "Вкл" : "Выкл"
        entries.append(SosuzagramSettingsEntry(
            section: SosuzagramSettingsSection.plugins.rawValue,
            stableId: UInt64(1000 + index),
            sortId: Int32(1000 + index),
            signature: "plugin:\(plugin.id):\(status):\(plugin.desc)",
            buildItem: { presentationData, arguments in
                ItemListDisclosureItem(
                    presentationData: presentationData,
                    systemStyle: .glass,
                    title: plugin.name,
                    label: status,
                    additionalDetailLabel: plugin.desc,
                    sectionId: SosuzagramSettingsSection.plugins.rawValue,
                    style: .blocks,
                    disclosureStyle: .arrow,
                    action: {
                        arguments.openPlugin(plugin.id)
                    }
                )
            }
        ))
    }

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.plugins.rawValue,
        stableId: 2000,
        sortId: 2000,
        signature: "plugins-info",
        buildItem: { presentationData, _ in
            ItemListTextItem(presentationData: presentationData, text: .plain("Новые .plugin-файлы не импортируются автоматически. Для каждого нового плагина нужен отдельный нативный порт под Sosuzagram."), sectionId: SosuzagramSettingsSection.plugins.rawValue)
        }
    ))

    _ = theme
    return entries
}

public func sosuzagramSettingsController(context: AccountContext) -> ViewController {
    deployEmbeddedPluginsIfNeeded()

    let statePromise = ValuePromise<Bool>(true, ignoreRepeated: false)
    var updateSettingsImpl: (() -> Void)?
    var openPluginImpl: ((String) -> Void)?
    var importPluginImpl: (() -> Void)?

    let arguments = SosuzagramSettingsControllerArguments(
        context: context,
        toggleSkipReadHistory: { value in
            let _ = updateExperimentalUISettingsInteractively(accountManager: context.sharedContext.accountManager, { settings in
                var settings = settings
                settings.skipReadHistory = value
                return settings
            }).start()
            UserDefaults.standard.set(value, forKey: "sosuzagram_skip_read_history")
            updateSettingsImpl?()
        },
        toggleHideStoryViews: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_story_views")
            updateSettingsImpl?()
        },
        toggleHideTyping: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_typing")
            updateSettingsImpl?()
        },
        toggleKeepLocalHistory: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_local_history")
            updateSettingsImpl?()
        },
        toggleShowMarker: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_show_marker")
            updateSettingsImpl?()
        },
        toggleHideStories: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_stories")
            updateSettingsImpl?()
        },
        toggleConfirmCalls: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_confirm_calls")
            updateSettingsImpl?()
        },
        toggleConfirmVoiceMessages: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_confirm_voice_messages")
            updateSettingsImpl?()
        },
        toggleHideShareButton: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_share_button")
            updateSettingsImpl?()
        },
        togglePollResultsBeforeVoting: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_poll_results_before_voting")
            updateSettingsImpl?()
        },
        toggleHideKeyboardOnScroll: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_keyboard_on_scroll")
            updateSettingsImpl?()
        },
        toggleHideSendAsButton: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_send_as_button")
            updateSettingsImpl?()
        },
        toggleReplaceEditedWithIcon: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_replace_edited_with_icon")
            updateSettingsImpl?()
        },
        toggleHideFloatingButton: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_floating_button")
            updateSettingsImpl?()
        },
        toggleHideAllChatsTab: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_all_chats_tab")
            updateSettingsImpl?()
        },
        toggleHideGreetingSticker: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_greeting_sticker")
            updateSettingsImpl?()
        },
        toggleHideStickerTimestamp: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_sticker_timestamp")
            updateSettingsImpl?()
        },
        selectIcon: { iconName in
            let targetName = iconName == "nil" ? nil : iconName
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(targetName) { error in
                    if let error {
                        print("Error setting alternate icon: \(error.localizedDescription)")
                    }
                }
            }
            UserDefaults.standard.set(iconName, forKey: "sosuzagram_current_icon")
            updateSettingsImpl?()
        },
        openPlugin: { pluginId in
            openPluginImpl?(pluginId)
        },
        importPlugin: {
            importPluginImpl?()
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
        let hideShareButton = UserDefaults.standard.bool(forKey: "sosuzagram_hide_share_button")
        let pollResultsBeforeVoting = UserDefaults.standard.bool(forKey: "sosuzagram_poll_results_before_voting")
        let hideKeyboardOnScroll = UserDefaults.standard.bool(forKey: "sosuzagram_hide_keyboard_on_scroll")
        let hideSendAsButton = UserDefaults.standard.bool(forKey: "sosuzagram_hide_send_as_button")
        let replaceEditedWithIcon = UserDefaults.standard.bool(forKey: "sosuzagram_replace_edited_with_icon")
        let hideFloatingButton = UserDefaults.standard.bool(forKey: "sosuzagram_hide_floating_button")
        let hideAllChatsTab = UserDefaults.standard.bool(forKey: "sosuzagram_hide_all_chats_tab")
        let hideGreetingSticker = UserDefaults.standard.bool(forKey: "sosuzagram_hide_greeting_sticker")
        let hideStickerTimestamp = UserDefaults.standard.bool(forKey: "sosuzagram_hide_sticker_timestamp")
        let currentIcon = UserDefaults.standard.string(forKey: "sosuzagram_current_icon") ?? "nil"
        let plugins = sosuzagramBuiltInPlugins()

        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("Настройки Sosuzagram"),
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
            hideShareButton: hideShareButton,
            pollResultsBeforeVoting: pollResultsBeforeVoting,
            hideKeyboardOnScroll: hideKeyboardOnScroll,
            hideSendAsButton: hideSendAsButton,
            replaceEditedWithIcon: replaceEditedWithIcon,
            hideFloatingButton: hideFloatingButton,
            hideAllChatsTab: hideAllChatsTab,
            hideGreetingSticker: hideGreetingSticker,
            hideStickerTimestamp: hideStickerTimestamp,
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
    openPluginImpl = { [weak controller] pluginId in
        controller?.push(sosuzagramPluginSettingsController(context: context, pluginId: pluginId))
    }
    importPluginImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        var documentTypes = ["public.item"]
        if #available(iOS 14.0, *) {
            for fileExtension in ["plugin", "sosuzagramplugin"] {
                if let identifier = UTType(filenameExtension: fileExtension)?.identifier, !documentTypes.contains(identifier) {
                    documentTypes.append(identifier)
                }
            }
        }
        
        let pickerController = legacyICloudFilePicker(theme: presentationData.theme, mode: .import, documentTypes: documentTypes, completion: { [weak controller] urls in
            guard let controller, let url = urls.first else {
                return
            }
            let scopedAccess = url.startAccessingSecurityScopedResource()
            defer {
                if scopedAccess {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            let allowedExtensions: Set<String> = ["plugin", "sosuzagramplugin"]
            guard allowedExtensions.contains(url.pathExtension.lowercased()) else {
                controller.present(textAlertController(context: context, title: "Импорт плагина", text: "Выбери файл с расширением .plugin или .sosuzagramplugin.", actions: [
                    TextAlertAction(type: .defaultAction, title: presentationData.strings.Common_OK, action: {})
                ]), in: .window(.root))
                return
            }
            
            do {
                let importedPlugin = try sosuzagramImportPluginFile(from: url)
                let supportedPlugin = sosuzagramBuiltInPlugin(id: importedPlugin.id)
                if supportedPlugin != nil {
                    sosuzagramSetPluginEnabled(importedPlugin.id, true)
                }
                updateSettingsImpl?()
                
                var actions: [TextAlertAction] = []
                if supportedPlugin != nil {
                    actions.append(TextAlertAction(type: .genericAction, title: "Открыть", action: {
                        controller.push(sosuzagramPluginSettingsController(context: context, pluginId: importedPlugin.id))
                    }))
                }
                actions.append(TextAlertAction(type: .defaultAction, title: presentationData.strings.Common_OK, action: {}))
                
                let message: String
                if supportedPlugin != nil {
                    message = "Плагин \(importedPlugin.name) импортирован и включён. Его настройки уже доступны в Sosuzagram."
                } else {
                    message = "Файл \(importedPlugin.name) импортирован в SosuzagramPlugins, но для работы нужен отдельный нативный порт под iOS."
                }
                
                controller.present(textAlertController(context: context, title: "Импорт плагина", text: message, actions: actions), in: .window(.root))
            } catch {
                controller.present(textAlertController(context: context, title: "Импорт плагина", text: "Не удалось импортировать файл: \(error.localizedDescription)", actions: [
                    TextAlertAction(type: .defaultAction, title: presentationData.strings.Common_OK, action: {})
                ]), in: .window(.root))
            }
        })
        controller.present(pickerController, in: .window(.root))
    }
    return controller
}
