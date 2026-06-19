import Foundation
import UIKit

struct SosuzagramAppIconSnapshot {
    let preferences: SosuzagramAppIconPreferences
    let selectedBuiltInIcon: SosuzagramBuiltInAppIcon?
    let selectedCustomIcon: SosuzagramCustomAppIconMetadata?
    let activeBuiltInIcon: SosuzagramBuiltInAppIcon
}

enum SosuzagramAppIconManagerError: LocalizedError {
    case unsupportedImage
    case imageTooSmall
    case imageNotSquare
    case imageTooLarge
    case importFailed(String)

    var errorDescription: String? {
        switch self {
        case .unsupportedImage:
            return "Файл не удалось распознать как изображение. Подойдут PNG, JPG или HEIC."
        case .imageTooSmall:
            return "Изображение слишком маленькое. Нужен квадрат минимум 120x120."
        case .imageNotSquare:
            return "Изображение должно быть почти квадратным, чтобы превью выглядело корректно."
        case .imageTooLarge:
            return "Файл слишком большой. Выбери изображение меньше 10 МБ."
        case let .importFailed(message):
            return message
        }
    }
}

struct SosuzagramAppIconOperationOutcome {
    let snapshot: SosuzagramAppIconSnapshot
    let notice: String?
}

final class SosuzagramAppIconManager {
    static let shared = SosuzagramAppIconManager()

    private let preferencesKey = "sosuzagram_app_icon_preferences_v1"
    private let legacyIconKey = "sosuzagram_current_icon"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let fileManager = FileManager.default

    private init() {}

    func snapshot() -> SosuzagramAppIconSnapshot {
        let preferences = self.loadPreferences()
        let selectedCustomIcon: SosuzagramCustomAppIconMetadata?
        if case let .custom(id) = preferences.selection, preferences.customIcon?.id == id {
            selectedCustomIcon = preferences.customIcon
        } else {
            selectedCustomIcon = nil
        }

        let selectedBuiltInIcon: SosuzagramBuiltInAppIcon?
        if case let .builtIn(icon) = preferences.selection {
            selectedBuiltInIcon = icon
        } else {
            selectedBuiltInIcon = nil
        }

        return SosuzagramAppIconSnapshot(
            preferences: preferences,
            selectedBuiltInIcon: selectedBuiltInIcon,
            selectedCustomIcon: selectedCustomIcon,
            activeBuiltInIcon: preferences.lastAppliedBuiltInIcon
        )
    }

    func settingsSummary() -> (label: String, detail: String) {
        let snapshot = self.snapshot()
        if let selectedBuiltInIcon = snapshot.selectedBuiltInIcon {
            return (
                self.displayTitle(for: selectedBuiltInIcon),
                "Системно применяется через alternate app icons."
            )
        }
        if snapshot.selectedCustomIcon != nil {
            return (
                "Кастомное превью",
                "Пользовательская иконка сохранена, но iOS оставляет на главном экране стандартную иконку приложения."
            )
        }
        return (
            self.displayTitle(for: snapshot.activeBuiltInIcon),
            "Системно применяется через alternate app icons."
        )
    }

    func displayTitle(for icon: SosuzagramBuiltInAppIcon) -> String {
        switch icon {
        case .systemDefault:
            return "Стандартная"
        case .red:
            return "Красная (Extera style)"
        case .green:
            return "Зелёная (Extera style)"
        case .orange:
            return "Оранжевая (Extera style)"
        case .purple:
            return "Фиолетовая (Extera style)"
        }
    }

    func customIconURL(for metadata: SosuzagramCustomAppIconMetadata) -> URL {
        self.iconsDirectoryURL().appendingPathComponent("custom-\(metadata.id.uuidString).png")
    }

    func previewImage(for metadata: SosuzagramCustomAppIconMetadata) -> UIImage? {
        UIImage(contentsOfFile: self.customIconURL(for: metadata).path)
    }

    func importCustomIcon(from url: URL) throws -> SosuzagramAppIconSnapshot {
        let shouldStopAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }

        let data = try Data(contentsOf: url)
        if data.count > 10 * 1024 * 1024 {
            throw SosuzagramAppIconManagerError.imageTooLarge
        }
        guard let image = UIImage(data: data) else {
            throw SosuzagramAppIconManagerError.unsupportedImage
        }

        let pixelWidth = Int(image.size.width * image.scale)
        let pixelHeight = Int(image.size.height * image.scale)
        if min(pixelWidth, pixelHeight) < 120 {
            throw SosuzagramAppIconManagerError.imageTooSmall
        }

        let aspectDelta = abs(Double(pixelWidth - pixelHeight)) / Double(max(pixelWidth, pixelHeight))
        if aspectDelta > 0.05 {
            throw SosuzagramAppIconManagerError.imageNotSquare
        }

        guard let normalizedData = image.pngData() else {
            throw SosuzagramAppIconManagerError.importFailed("Не удалось подготовить PNG-превью для импортированной иконки.")
        }

        var preferences = self.loadPreferences()
        let metadata = SosuzagramCustomAppIconMetadata(
            id: UUID(),
            originalFilename: url.lastPathComponent,
            pixelWidth: pixelWidth,
            pixelHeight: pixelHeight,
            fileSizeBytes: normalizedData.count,
            importedAt: Date()
        )

        try self.ensureIconsDirectoryExists()
        if let existing = preferences.customIcon {
            try? self.fileManager.removeItem(at: self.customIconURL(for: existing))
        }
        try normalizedData.write(to: self.customIconURL(for: metadata), options: .atomic)

        preferences.customIcon = metadata
        if case .custom = preferences.selection {
            preferences.selection = .custom(metadata.id)
        }
        try self.savePreferences(preferences)
        print("SosuzagramAppIcon: imported custom icon preview: \(metadata.originalFilename)")
        return self.snapshot()
    }

    func removeCustomIcon() throws -> SosuzagramAppIconSnapshot {
        var preferences = self.loadPreferences()
        if let existing = preferences.customIcon {
            try? self.fileManager.removeItem(at: self.customIconURL(for: existing))
        }
        preferences.customIcon = nil
        if case .custom = preferences.selection {
            preferences.selection = .builtIn(.systemDefault)
        }
        try self.savePreferences(preferences)
        return self.snapshot()
    }

    @MainActor
    func applyBuiltInIcon(_ icon: SosuzagramBuiltInAppIcon) async throws -> SosuzagramAppIconOperationOutcome {
        var preferences = self.loadPreferences()
        let notice: String?
        if UIApplication.shared.supportsAlternateIcons {
            try await self.setAlternateIconName(icon.alternateIconName)
            notice = nil
        } else {
            notice = "На этом устройстве alternate app icons недоступны, поэтому выбор только сохранён в настройках."
            print("SosuzagramAppIcon: \(notice ?? "")")
        }

        preferences.selection = .builtIn(icon)
        preferences.lastAppliedBuiltInIcon = icon
        self.persistLegacyMirror(icon)
        try self.savePreferences(preferences)
        print("SosuzagramAppIcon: applied built-in icon selection: \(icon.rawValue)")
        return SosuzagramAppIconOperationOutcome(snapshot: self.snapshot(), notice: notice)
    }

    @MainActor
    func activateCustomIconPreview() async throws -> SosuzagramAppIconOperationOutcome {
        var preferences = self.loadPreferences()
        guard let customIcon = preferences.customIcon else {
            throw SosuzagramAppIconManagerError.importFailed("Сначала импортируй пользовательскую иконку.")
        }

        let notice = "iOS не позволяет напрямую назначить произвольное пользовательское изображение как app icon. BurmalGram сохранил его как превью и безопасно вернул системную иконку по умолчанию."
        if UIApplication.shared.supportsAlternateIcons {
            try await self.setAlternateIconName(nil)
        }

        preferences.selection = .custom(customIcon.id)
        preferences.lastAppliedBuiltInIcon = .systemDefault
        self.persistLegacyMirror(.systemDefault)
        try self.savePreferences(preferences)
        print("SosuzagramAppIcon: \(notice)")
        return SosuzagramAppIconOperationOutcome(snapshot: self.snapshot(), notice: notice)
    }

    @MainActor
    private func setAlternateIconName(_ name: String?) async throws {
        try await withCheckedThrowingContinuation { continuation in
            UIApplication.shared.setAlternateIconName(name) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    private func loadPreferences() -> SosuzagramAppIconPreferences {
        if let data = UserDefaults.standard.data(forKey: self.preferencesKey),
           let decoded = try? self.decoder.decode(SosuzagramAppIconPreferences.self, from: data) {
            return decoded
        }

        let legacyValue = UserDefaults.standard.string(forKey: self.legacyIconKey) ?? "nil"
        let legacyIcon: SosuzagramBuiltInAppIcon
        switch legacyValue {
        case "Red":
            legacyIcon = .red
        case "Green":
            legacyIcon = .green
        case "Orange":
            legacyIcon = .orange
        case "Purple":
            legacyIcon = .purple
        default:
            legacyIcon = .systemDefault
        }
        return SosuzagramAppIconPreferences(
            selection: .builtIn(legacyIcon),
            customIcon: nil,
            lastAppliedBuiltInIcon: legacyIcon
        )
    }

    private func savePreferences(_ preferences: SosuzagramAppIconPreferences) throws {
        let data = try self.encoder.encode(preferences)
        UserDefaults.standard.set(data, forKey: self.preferencesKey)
    }

    private func persistLegacyMirror(_ icon: SosuzagramBuiltInAppIcon) {
        let legacyValue = icon.alternateIconName ?? "nil"
        UserDefaults.standard.set(legacyValue, forKey: self.legacyIconKey)
    }

    private func iconsDirectoryURL() -> URL {
        let appSupport = self.fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return appSupport
            .appendingPathComponent("Sosuzagram", isDirectory: true)
            .appendingPathComponent("AppIcons", isDirectory: true)
    }

    private func ensureIconsDirectoryExists() throws {
        try self.fileManager.createDirectory(at: self.iconsDirectoryURL(), withIntermediateDirectories: true, attributes: nil)
    }
}
