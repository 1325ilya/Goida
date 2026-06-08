import Foundation
import UIKit
import Display
import SwiftSignalKit
import TelegramCore
import TelegramPresentationData
import ItemListUI
import AccountContext

private struct SosuzagramPluginSettingsArguments {
    let setPluginEnabled: (Bool) -> Void
    let setToggle: (String, Bool) -> Void
    let openSelector: (String, String, Int, [String]) -> Void
    let updateInput: (String, String) -> Void
}

private struct SosuzagramPluginSettingsEntry: ItemListNodeEntry {
    let section: ItemListSectionId
    let stableId: UInt64
    let sortId: Int32
    let signature: String
    let buildItem: (ItemListPresentationData, SosuzagramPluginSettingsArguments) -> ListViewItem

    static func == (lhs: SosuzagramPluginSettingsEntry, rhs: SosuzagramPluginSettingsEntry) -> Bool {
        return lhs.section == rhs.section
            && lhs.stableId == rhs.stableId
            && lhs.sortId == rhs.sortId
            && lhs.signature == rhs.signature
    }

    static func < (lhs: SosuzagramPluginSettingsEntry, rhs: SosuzagramPluginSettingsEntry) -> Bool {
        return lhs.sortId < rhs.sortId
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        return self.buildItem(presentationData, arguments as! SosuzagramPluginSettingsArguments)
    }
}

private func sosuzagramPluginSettingsEntries(
    context: AccountContext,
    plugin: SosuzagramPluginDescriptor,
    presentationData: PresentationData
) -> [SosuzagramPluginSettingsEntry] {
    var entries: [SosuzagramPluginSettingsEntry] = []
    var sectionId: Int32 = 0
    var stableId: UInt64 = 0
    var sortId: Int32 = 0

    let pluginEnabled = sosuzagramPluginEnabled(plugin.id)
    let initialSection = sectionId
    entries.append(SosuzagramPluginSettingsEntry(
        section: initialSection,
        stableId: stableId,
        sortId: sortId,
        signature: "enabled:\(pluginEnabled)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "Включить плагин",
                value: pluginEnabled,
                sectionId: initialSection,
                style: .blocks,
                updated: { value in
                    arguments.setPluginEnabled(value)
                }
            )
        }
    ))
    stableId += 1
    sortId += 1

    entries.append(SosuzagramPluginSettingsEntry(
        section: initialSection,
        stableId: stableId,
        sortId: sortId,
        signature: plugin.desc,
        buildItem: { presentationData, _ in
            ItemListTextItem(presentationData: presentationData, text: .plain(plugin.desc), sectionId: initialSection)
        }
    ))
    stableId += 1
    sortId += 1

    for content in plugin.settings() {
        switch content {
        case let .header(title):
            sectionId += 1
            let currentSection = sectionId
            entries.append(SosuzagramPluginSettingsEntry(
                section: currentSection,
                stableId: stableId,
                sortId: sortId,
                signature: "header:\(title)",
                buildItem: { presentationData, _ in
                    ItemListSectionHeaderItem(presentationData: presentationData, text: title, sectionId: currentSection)
                }
            ))
            stableId += 1
            sortId += 1
        case let .info(text):
            let currentSection = sectionId
            entries.append(SosuzagramPluginSettingsEntry(
                section: currentSection,
                stableId: stableId,
                sortId: sortId,
                signature: "info:\(text)",
                buildItem: { presentationData, _ in
                    ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: currentSection)
                }
            ))
            stableId += 1
            sortId += 1
        case let .setting(row):
            let currentSection = sectionId
            switch row.control {
            case let .toggle(defaultValue):
                let value = sosuzagramPluginSettingBool(pluginId: plugin.id, key: row.key, defaultValue: defaultValue)
                entries.append(SosuzagramPluginSettingsEntry(
                    section: currentSection,
                    stableId: stableId,
                    sortId: sortId,
                    signature: "toggle:\(row.key):\(value):\(row.subtitle ?? "")",
                    buildItem: { presentationData, arguments in
                        ItemListSwitchItem(
                            presentationData: presentationData,
                            systemStyle: .glass,
                            title: row.title,
                            value: value,
                            sectionId: currentSection,
                            style: .blocks,
                            updated: { updated in
                                arguments.setToggle(row.key, updated)
                            }
                        )
                    }
                ))
                stableId += 1
                sortId += 1
                if let subtitle = row.subtitle {
                    entries.append(SosuzagramPluginSettingsEntry(
                        section: currentSection,
                        stableId: stableId,
                        sortId: sortId,
                        signature: "subtitle:\(row.key):\(subtitle)",
                        buildItem: { presentationData, _ in
                            ItemListTextItem(presentationData: presentationData, text: .plain(subtitle), sectionId: currentSection)
                        }
                    ))
                    stableId += 1
                    sortId += 1
                }
            case let .selector(defaultIndex, options):
                let currentIndex = max(0, min(options.count - 1, sosuzagramPluginSettingInt(pluginId: plugin.id, key: row.key, defaultValue: defaultIndex)))
                let label = options[currentIndex]
                entries.append(SosuzagramPluginSettingsEntry(
                    section: currentSection,
                    stableId: stableId,
                    sortId: sortId,
                    signature: "selector:\(row.key):\(currentIndex):\(row.subtitle ?? "")",
                    buildItem: { presentationData, arguments in
                        ItemListDisclosureItem(
                            presentationData: presentationData,
                            systemStyle: .glass,
                            title: row.title,
                            label: label,
                            additionalDetailLabel: row.subtitle,
                            sectionId: currentSection,
                            style: .blocks,
                            disclosureStyle: .arrow,
                            action: {
                                arguments.openSelector(row.key, row.title, currentIndex, options)
                            }
                        )
                    }
                ))
                stableId += 1
                sortId += 1
            case let .input(defaultValue, numeric):
                let currentValue = sosuzagramPluginSettingString(pluginId: plugin.id, key: row.key, defaultValue: defaultValue)
                entries.append(SosuzagramPluginSettingsEntry(
                    section: currentSection,
                    stableId: stableId,
                    sortId: sortId,
                    signature: "input:\(row.key):\(currentValue):\(row.subtitle ?? "")",
                    buildItem: { presentationData, arguments in
                        ItemListSingleLineInputItem(
                            presentationData: presentationData,
                            systemStyle: .glass,
                            title: NSAttributedString(string: row.title),
                            text: currentValue,
                            placeholder: defaultValue,
                            type: numeric ? .number : .regular(capitalization: false, autocorrection: false),
                            sectionId: currentSection,
                            textUpdated: { text in
                                arguments.updateInput(row.key, text)
                            },
                            action: {
                            }
                        )
                    }
                ))
                stableId += 1
                sortId += 1
                if let subtitle = row.subtitle {
                    entries.append(SosuzagramPluginSettingsEntry(
                        section: currentSection,
                        stableId: stableId,
                        sortId: sortId,
                        signature: "inputsubtitle:\(row.key):\(subtitle)",
                        buildItem: { presentationData, _ in
                            ItemListTextItem(presentationData: presentationData, text: .plain(subtitle), sectionId: currentSection)
                        }
                    ))
                    stableId += 1
                    sortId += 1
                }
            }
        }
    }

    if plugin.id == "server_status" {
        sectionId += 1
        let currentSection = sectionId
        let dcId = SosuzagramServerStatus.shared.currentDatacenterId != 0 ? SosuzagramServerStatus.shared.currentDatacenterId : Int32(context.account.network.datacenterId)
        if sosuzagramPluginEnabled("server_status") {
            SosuzagramServerStatus.shared.startPinging(datacenterId: dcId)
        }
        var pingText: String
        if let ping = SosuzagramServerStatus.shared.currentPing {
            pingText = "Текущий датацентр: DC\(dcId), пинг \(ping) мс."
        } else {
            pingText = "Текущий датацентр: DC\(dcId), пинг ещё измеряется."
        }
        if let ping = SosuzagramServerStatus.shared.currentPing {
            pingText = "Текущий датацентр: DC\(dcId), пинг \(ping) мс."
        } else if let error = SosuzagramServerStatus.shared.lastErrorDescription, !error.isEmpty {
            pingText = "Текущий датацентр: DC\(dcId), измерение не удалось (\(error))."
        } else {
            pingText = "Текущий датацентр: DC\(dcId), пинг ещё измеряется."
        }
        entries.append(SosuzagramPluginSettingsEntry(
            section: currentSection,
            stableId: stableId,
            sortId: sortId,
            signature: "serverstatus:\(pingText)",
            buildItem: { presentationData, _ in
                ItemListSectionHeaderItem(presentationData: presentationData, text: "Текущий статус", sectionId: currentSection)
            }
        ))
        stableId += 1
        sortId += 1
        entries.append(SosuzagramPluginSettingsEntry(
            section: currentSection,
            stableId: stableId,
            sortId: sortId,
            signature: "serverstatusinfo:\(pingText)",
            buildItem: { presentationData, _ in
                ItemListTextItem(presentationData: presentationData, text: .plain(pingText), sectionId: currentSection)
            }
        ))
    }

    return entries
}

public func sosuzagramPluginSettingsController(context: AccountContext, pluginId: String) -> ViewController {
    guard let plugin = sosuzagramBuiltInPlugin(id: pluginId) else {
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let signal: Signal<(ItemListControllerState, (ItemListNodeState, Void)), NoError> = .single((
            ItemListControllerState(
                presentationData: ItemListPresentationData(presentationData),
                title: .text("Plugin"),
                leftNavigationButton: nil,
                rightNavigationButton: nil,
                backNavigationButton: nil
            ),
            (
                ItemListNodeState(
                    presentationData: ItemListPresentationData(presentationData),
                    entries: [
                        SosuzagramPluginSettingsEntry(
                            section: 0,
                            stableId: 0,
                            sortId: 0,
                            signature: "missing-plugin",
                            buildItem: { presentationData, _ in
                                ItemListTextItem(presentationData: presentationData, text: .plain("Plugin is not available in the built-in Sosuzagram bundle."), sectionId: 0)
                            }
                        )
                    ],
                    style: .blocks,
                    animateChanges: false
                ),
                Void()
            )
        ))
        return ItemListController(context: context, state: signal)
    }

    let statePromise = ValuePromise<Bool>(true, ignoreRepeated: false)
    var updateState: (() -> Void)?
    var controller: ItemListController?

    let arguments = SosuzagramPluginSettingsArguments(
        setPluginEnabled: { value in
            sosuzagramSetPluginEnabled(plugin.id, value)
            updateState?()
        },
        setToggle: { key, value in
            UserDefaults.standard.set(value, forKey: sosuzagramPluginSettingKey(plugin.id, key))
            updateState?()
        },
        openSelector: { key, title, currentIndex, options in
            guard !options.isEmpty else {
                return
            }
            let presentationData = context.sharedContext.currentPresentationData.with { $0 }
            let actionSheet = ActionSheetController(presentationData: presentationData)
            var items: [ActionSheetItem] = [ActionSheetTextItem(title: title)]

            for (index, option) in options.enumerated() {
                let optionTitle = index == currentIndex ? "[selected] \(option)" : option
                items.append(ActionSheetButtonItem(title: optionTitle, color: .accent, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                    UserDefaults.standard.set(index, forKey: sosuzagramPluginSettingKey(plugin.id, key))
                    updateState?()
                }))
            }

            actionSheet.setItemGroups([
                ActionSheetItemGroup(items: items),
                ActionSheetItemGroup(items: [
                    ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                        actionSheet?.dismissAnimated()
                    })
                ])
            ])
            controller?.present(actionSheet, in: .window(.root))
        },
        updateInput: { key, value in
            UserDefaults.standard.set(value, forKey: sosuzagramPluginSettingKey(plugin.id, key))
        }
    )

    let signal = combineLatest(
        context.sharedContext.presentationData,
        statePromise.get()
    )
    |> map { presentationData, _ -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text(plugin.name),
            leftNavigationButton: nil,
            rightNavigationButton: nil,
            backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
        )

        let entries = sosuzagramPluginSettingsEntries(
            context: context,
            plugin: plugin,
            presentationData: presentationData
        )

        let listState = ItemListNodeState(
            presentationData: ItemListPresentationData(presentationData),
            entries: entries,
            style: .blocks,
            animateChanges: false
        )

        return (controllerState, (listState, arguments))
    }

    let itemListController = ItemListController(context: context, state: signal)
    controller = itemListController
    updateState = {
        statePromise.set(true)
    }
    return itemListController
}
