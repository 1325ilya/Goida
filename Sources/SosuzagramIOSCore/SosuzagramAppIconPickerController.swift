import Foundation
import UIKit
import Display
import SwiftSignalKit
import TelegramPresentationData
import ItemListUI
import AccountContext
import PresentationDataUtils
import LegacyMediaPickerUI
import AlertUI

private enum SosuzagramAppIconPickerSection: Int32 {
    case native
    case custom
    case customActions
    case status
}

private struct SosuzagramAppIconPickerArguments {
    let applyBuiltIn: (SosuzagramBuiltInAppIcon) -> Void
    let importCustom: () -> Void
    let activateCustom: () -> Void
    let resetToDefault: () -> Void
    let removeCustom: () -> Void
    let openPreview: () -> Void
}

private struct SosuzagramAppIconPickerEntry: ItemListNodeEntry {
    let section: ItemListSectionId
    let stableId: UInt64
    let sortId: Int32
    let signature: String
    let buildItem: (ItemListPresentationData, SosuzagramAppIconPickerArguments) -> ListViewItem

    static func == (lhs: SosuzagramAppIconPickerEntry, rhs: SosuzagramAppIconPickerEntry) -> Bool {
        lhs.section == rhs.section
            && lhs.stableId == rhs.stableId
            && lhs.sortId == rhs.sortId
            && lhs.signature == rhs.signature
    }

    static func < (lhs: SosuzagramAppIconPickerEntry, rhs: SosuzagramAppIconPickerEntry) -> Bool {
        lhs.sortId < rhs.sortId
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        self.buildItem(presentationData, arguments as! SosuzagramAppIconPickerArguments)
    }
}

private func sosuzagramAppIconPickerEntries(
    presentationData: PresentationData,
    snapshot: SosuzagramAppIconSnapshot
) -> [SosuzagramAppIconPickerEntry] {
    let manager = SosuzagramAppIconManager.shared
    var entries: [SosuzagramAppIconPickerEntry] = []
    var stableId: UInt64 = 0
    var sortId: Int32 = 0

    entries.append(SosuzagramAppIconPickerEntry(
        section: SosuzagramAppIconPickerSection.native.rawValue,
        stableId: stableId,
        sortId: sortId,
        signature: "native-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(
                presentationData: presentationData,
                text: "Встроенные иконки",
                sectionId: SosuzagramAppIconPickerSection.native.rawValue
            )
        }
    ))
    stableId += 1
    sortId += 1

    for icon in SosuzagramBuiltInAppIcon.allCases {
        let isSelected = snapshot.selectedBuiltInIcon == icon
        let isApplied = snapshot.activeBuiltInIcon == icon
        let label: String
        if isSelected && isApplied {
            label = "Выбрано"
        } else if isSelected {
            label = "Сохранено"
        } else if isApplied {
            label = "Активно"
        } else {
            label = ""
        }

        entries.append(SosuzagramAppIconPickerEntry(
            section: SosuzagramAppIconPickerSection.native.rawValue,
            stableId: stableId,
            sortId: sortId,
            signature: "native:\(icon.rawValue):\(label)",
            buildItem: { presentationData, arguments in
                ItemListDisclosureItem(
                    presentationData: presentationData,
                    systemStyle: .glass,
                    title: manager.displayTitle(for: icon),
                    label: label,
                    sectionId: SosuzagramAppIconPickerSection.native.rawValue,
                    style: .blocks,
                    disclosureStyle: .none,
                    action: {
                        arguments.applyBuiltIn(icon)
                    }
                )
            }
        ))
        stableId += 1
        sortId += 1
    }

    entries.append(SosuzagramAppIconPickerEntry(
        section: SosuzagramAppIconPickerSection.custom.rawValue,
        stableId: stableId,
        sortId: sortId,
        signature: "custom-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(
                presentationData: presentationData,
                text: "Пользовательская иконка",
                sectionId: SosuzagramAppIconPickerSection.custom.rawValue
            )
        }
    ))
    stableId += 1
    sortId += 1

    if let customIcon = snapshot.preferences.customIcon {
        let label = snapshot.selectedCustomIcon?.id == customIcon.id ? "Превью активно" : "Импортировано"
        let detail = "\(customIcon.originalFilename) • \(customIcon.pixelWidth)x\(customIcon.pixelHeight) • \(ByteCountFormatter.string(fromByteCount: Int64(customIcon.fileSizeBytes), countStyle: .file))"
        entries.append(SosuzagramAppIconPickerEntry(
            section: SosuzagramAppIconPickerSection.custom.rawValue,
            stableId: stableId,
            sortId: sortId,
            signature: "custom-file:\(customIcon.id.uuidString):\(label)",
            buildItem: { presentationData, arguments in
                ItemListDisclosureItem(
                    presentationData: presentationData,
                    systemStyle: .glass,
                    title: "Открыть превью",
                    label: label,
                    additionalDetailLabel: detail,
                    sectionId: SosuzagramAppIconPickerSection.custom.rawValue,
                    style: .blocks,
                    disclosureStyle: .arrow,
                    action: {
                        arguments.openPreview()
                    }
                )
            }
        ))
        stableId += 1
        sortId += 1
    } else {
        entries.append(SosuzagramAppIconPickerEntry(
            section: SosuzagramAppIconPickerSection.custom.rawValue,
            stableId: stableId,
            sortId: sortId,
            signature: "custom-missing",
            buildItem: { presentationData, _ in
                ItemListTextItem(
                    presentationData: presentationData,
                    text: .plain("Импортируй квадратное изображение, чтобы сохранить его как пользовательское превью иконки."),
                    sectionId: SosuzagramAppIconPickerSection.custom.rawValue
                )
            }
        ))
        stableId += 1
        sortId += 1
    }

    entries.append(SosuzagramAppIconPickerEntry(
        section: SosuzagramAppIconPickerSection.customActions.rawValue,
        stableId: stableId,
        sortId: sortId,
        signature: "custom-import-action",
        buildItem: { presentationData, arguments in
            ItemListActionItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: snapshot.preferences.customIcon == nil ? "Импортировать изображение" : "Заменить изображение",
                kind: .generic,
                alignment: .natural,
                sectionId: SosuzagramAppIconPickerSection.customActions.rawValue,
                style: .blocks,
                action: {
                    arguments.importCustom()
                }
            )
        }
    ))
    stableId += 1
    sortId += 1

    if snapshot.preferences.customIcon != nil {
        entries.append(SosuzagramAppIconPickerEntry(
            section: SosuzagramAppIconPickerSection.customActions.rawValue,
            stableId: stableId,
            sortId: sortId,
            signature: "custom-activate-action",
            buildItem: { presentationData, arguments in
                ItemListActionItem(
                    presentationData: presentationData,
                    systemStyle: .glass,
                    title: "Сделать активным превью",
                    kind: .generic,
                    alignment: .natural,
                    sectionId: SosuzagramAppIconPickerSection.customActions.rawValue,
                    style: .blocks,
                    action: {
                        arguments.activateCustom()
                    }
                )
            }
        ))
        stableId += 1
        sortId += 1

        entries.append(SosuzagramAppIconPickerEntry(
            section: SosuzagramAppIconPickerSection.customActions.rawValue,
            stableId: stableId,
            sortId: sortId,
            signature: "custom-remove-action",
            buildItem: { presentationData, arguments in
                ItemListActionItem(
                    presentationData: presentationData,
                    systemStyle: .glass,
                    title: "Удалить пользовательское превью",
                    kind: .destructive,
                    alignment: .natural,
                    sectionId: SosuzagramAppIconPickerSection.customActions.rawValue,
                    style: .blocks,
                    action: {
                        arguments.removeCustom()
                    }
                )
            }
        ))
        stableId += 1
        sortId += 1
    }

    entries.append(SosuzagramAppIconPickerEntry(
        section: SosuzagramAppIconPickerSection.customActions.rawValue,
        stableId: stableId,
        sortId: sortId,
        signature: "reset-default-action",
        buildItem: { presentationData, arguments in
            ItemListActionItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "Сбросить на стандартную",
                kind: .generic,
                alignment: .natural,
                sectionId: SosuzagramAppIconPickerSection.customActions.rawValue,
                style: .blocks,
                action: {
                    arguments.resetToDefault()
                }
            )
        }
    ))
    stableId += 1
    sortId += 1

    let selectedSummary: String
    if let selectedBuiltInIcon = snapshot.selectedBuiltInIcon {
        selectedSummary = "Выбранная иконка: \(manager.displayTitle(for: selectedBuiltInIcon))."
    } else if snapshot.selectedCustomIcon != nil {
        selectedSummary = "Выбрано пользовательское превью. На домашнем экране остаётся стандартная иконка."
    } else {
        selectedSummary = "Выбранная иконка не определена, используется безопасный откат к стандартной."
    }
    let appliedSummary = "Фактически активная иконка на Home Screen: \(manager.displayTitle(for: snapshot.activeBuiltInIcon))."
    entries.append(SosuzagramAppIconPickerEntry(
        section: SosuzagramAppIconPickerSection.status.rawValue,
        stableId: stableId,
        sortId: sortId,
        signature: "status-info:\(selectedSummary):\(appliedSummary)",
        buildItem: { presentationData, _ in
            ItemListTextItem(
                presentationData: presentationData,
                text: .plain("\(selectedSummary)\n\(appliedSummary)\n\niOS поддерживает только заранее встроенные alternate app icons. Пользовательские изображения Sosuzagram хранит как превью, логирует ограничение и безопасно откатывает реальный app icon на стандартный."),
                sectionId: SosuzagramAppIconPickerSection.status.rawValue
            )
        }
    ))

    return entries
}

private final class SosuzagramAppIconPreviewController: ViewController {
    private let presentationData: PresentationData
    private let image: UIImage
    private let metadata: SosuzagramCustomAppIconMetadata

    init(presentationData: PresentationData, image: UIImage, metadata: SosuzagramCustomAppIconMetadata) {
        self.presentationData = presentationData
        self.image = image
        self.metadata = metadata
        super.init(navigationBarPresentationData: NavigationBarPresentationData(presentationData: presentationData))
        self.title = "Превью иконки"
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let rootView = UIView()
        rootView.backgroundColor = self.presentationData.theme.list.blocksBackgroundColor

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        let imageView = UIImageView(image: self.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 28.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = self.presentationData.theme.list.itemBlocksBackgroundColor

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = self.metadata.originalFilename
        titleLabel.textColor = self.presentationData.theme.list.itemPrimaryTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = self.presentationData.theme.list.itemSecondaryTextColor
        infoLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.text = "\(self.metadata.pixelWidth)x\(self.metadata.pixelHeight)\n\(ByteCountFormatter.string(fromByteCount: Int64(self.metadata.fileSizeBytes), countStyle: .file))"

        let noteLabel = UILabel()
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.textColor = self.presentationData.theme.list.freeTextColor
        noteLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        noteLabel.numberOfLines = 0
        noteLabel.textAlignment = .center
        noteLabel.text = "Это сохранённое превью. iOS не позволяет напрямую применить пользовательскую картинку как иконку приложения."

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(noteLabel)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32.0),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 180.0),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),

            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0),
            infoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            noteLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20.0),
            noteLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            noteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32.0)
        ])

        self.view = rootView
    }
}

func sosuzagramAppIconPickerController(context: AccountContext, onUpdate: @escaping () -> Void) -> ViewController {
    let statePromise = ValuePromise<Int>(0, ignoreRepeated: false)
    var controller: ItemListController?
    var updateState: (() -> Void)?

    func presentMessage(_ text: String) {
        guard let controller else {
            return
        }
        controller.present(
            textAlertController(
                context: context,
                title: "Иконка приложения",
                text: text,
                actions: [
                    TextAlertAction(type: .defaultAction, title: "OK", action: {})
                ]
            ),
            in: .window(.root)
        )
    }

    let arguments = SosuzagramAppIconPickerArguments(
        applyBuiltIn: { icon in
            Task { @MainActor in
                do {
                    let outcome = try await SosuzagramAppIconManager.shared.applyBuiltInIcon(icon)
                    onUpdate()
                    updateState?()
                    if let notice = outcome.notice {
                        presentMessage(notice)
                    }
                } catch {
                    presentMessage(error.localizedDescription)
                }
            }
        },
        importCustom: {
            guard let controller else {
                return
            }
            let presentationData = context.sharedContext.currentPresentationData.with { $0 }
            let pickerController = legacyICloudFilePicker(
                theme: presentationData.theme,
                mode: .import,
                documentTypes: ["public.image"],
                completion: { urls in
                    guard let url = urls.first else {
                        return
                    }
                    do {
                        _ = try SosuzagramAppIconManager.shared.importCustomIcon(from: url)
                        onUpdate()
                        updateState?()
                    } catch {
                        presentMessage(error.localizedDescription)
                    }
                }
            )
            controller.present(pickerController, in: .window(.root))
        },
        activateCustom: {
            Task { @MainActor in
                do {
                    let outcome = try await SosuzagramAppIconManager.shared.activateCustomIconPreview()
                    onUpdate()
                    updateState?()
                    if let notice = outcome.notice {
                        presentMessage(notice)
                    }
                } catch {
                    presentMessage(error.localizedDescription)
                }
            }
        },
        resetToDefault: {
            Task { @MainActor in
                do {
                    _ = try await SosuzagramAppIconManager.shared.applyBuiltInIcon(.systemDefault)
                    onUpdate()
                    updateState?()
                } catch {
                    presentMessage(error.localizedDescription)
                }
            }
        },
        removeCustom: {
            do {
                _ = try SosuzagramAppIconManager.shared.removeCustomIcon()
                onUpdate()
                updateState?()
            } catch {
                presentMessage(error.localizedDescription)
            }
        },
        openPreview: {
            let snapshot = SosuzagramAppIconManager.shared.snapshot()
            guard let metadata = snapshot.preferences.customIcon,
                  let image = SosuzagramAppIconManager.shared.previewImage(for: metadata) else {
                presentMessage("Не удалось открыть сохранённое превью иконки.")
                return
            }
            let presentationData = context.sharedContext.currentPresentationData.with { $0 }
            controller?.push(SosuzagramAppIconPreviewController(presentationData: presentationData, image: image, metadata: metadata))
        }
    )

    let signal = combineLatest(
        context.sharedContext.presentationData,
        statePromise.get()
    )
    |> map { presentationData, _ -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let snapshot = SosuzagramAppIconManager.shared.snapshot()
        let entries = sosuzagramAppIconPickerEntries(
            presentationData: presentationData,
            snapshot: snapshot
        )
        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("Иконка приложения"),
            leftNavigationButton: nil,
            rightNavigationButton: nil,
            backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
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
        statePromise.set(Int(Date().timeIntervalSince1970))
    }
    return itemListController
}
