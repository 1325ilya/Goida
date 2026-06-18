import Foundation
import os

public struct SosuzagramAndroidDesignModeChange: Sendable {
    public let enabled: Bool
    public let restoredKeys: [String]
    public let overriddenKeys: [String]
    public let conflicts: [String]
    public let failureReason: String?
}

private enum SosuzagramAndroidDesignSnapshotValueKind: String, Codable {
    case bool
    case int
    case string
    case missing
}

private struct SosuzagramAndroidDesignSnapshotEntry: Codable {
    let key: String
    let kind: SosuzagramAndroidDesignSnapshotValueKind
    let boolValue: Bool?
    let intValue: Int?
    let stringValue: String?
}

private enum SosuzagramAndroidDesignPresetValue: Equatable {
    case bool(Bool)
    case int(Int)
    case string(String)

    var description: String {
        switch self {
        case let .bool(value):
            return value ? "true" : "false"
        case let .int(value):
            return "\(value)"
        case let .string(value):
            return value
        }
    }
}

public enum SosuzagramAndroidDesignManager {
    public static let modeKey = "sosuzagram_android_design"

    private static let snapshotKey = "sosuzagram_android_design_snapshot_v1"
    private static let logger = Logger(subsystem: "app.sosuzagram", category: "AndroidDesignBeta")
    private static let logQueue = DispatchQueue(label: "app.sosuzagram.android-design-log")
    private static var seenMarkers = Set<String>()

    private static let presetValues: [(String, SosuzagramAndroidDesignPresetValue)] = [
        ("sosuzagram_avatar_shape", .string("circle")),
        ("sosuzagram_unified_rounding", .bool(true)),
        ("sosuzagram_disable_separators", .bool(false)),
        ("sosuzagram_separate_headers", .bool(false)),
        ("sosuzagram_chat_themes", .bool(true)),
        ("sosuzagram_material_design_level", .int(3)),
        ("sosuzagram_system_fonts", .bool(false)),
        ("sosuzagram_system_emoji", .bool(false)),
        ("sosuzagram_sticky_avatar_animation", .bool(true)),
        ("sosuzagram_force_snow", .bool(false)),
        ("sosuzagram_hide_chat_list_status", .bool(false)),
        ("sosuzagram_center_chat_list_title", .bool(false)),
        ("sosuzagram_mini_avatars", .bool(false)),
        ("sosuzagram_smooth_animations", .bool(true)),
        ("sosuzagram_show_folder_badges", .bool(true)),
        ("sosuzagram_folder_tab_titles", .string("title_and_icon")),
        ("sosuzagram_chat_list_title_text", .string("name"))
    ]

    public static var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: modeKey)
    }

    public static func materialDesignLevel() -> Int {
        max(0, min(3, UserDefaults.standard.integer(forKey: "sosuzagram_material_design_level")))
    }

    public static func toggleBetaMode(_ enabled: Bool) -> SosuzagramAndroidDesignModeChange {
        enabled ? enableBetaMode() : disableBetaMode()
    }

    public static func logApplied(screen: String, elements: [String], detail: String? = nil) {
        guard !elements.isEmpty else {
            return
        }
        let normalizedElements = elements.sorted().joined(separator: ", ")
        let message = detail.map { "screen=\(screen) elements=[\(normalizedElements)] detail=\($0)" } ?? "screen=\(screen) elements=[\(normalizedElements)]"
        emit(.info, category: "applied", message: message, onceKey: "applied|\(screen)|\(normalizedElements)")
    }

    public static func logSkipped(screen: String, elements: [String], reason: String) {
        guard !elements.isEmpty else {
            return
        }
        let normalizedElements = elements.sorted().joined(separator: ", ")
        emit(.info, category: "skipped", message: "screen=\(screen) elements=[\(normalizedElements)] reason=\(reason)", onceKey: "skipped|\(screen)|\(normalizedElements)|\(reason)")
    }

    public static func logFailure(screen: String, message: String) {
        emit(.error, category: "failure", message: "screen=\(screen) \(message)")
    }

    public static func logConflict(screen: String, conflicts: [String]) {
        guard !conflicts.isEmpty else {
            return
        }
        let normalizedConflicts = conflicts.sorted().joined(separator: "; ")
        emit(.info, category: "conflict", message: "screen=\(screen) \(normalizedConflicts)", onceKey: "conflict|\(screen)|\(normalizedConflicts)")
    }

    private static func enableBetaMode() -> SosuzagramAndroidDesignModeChange {
        let defaults = UserDefaults.standard
        let snapshot = captureSnapshot(defaults: defaults)
        let conflicts = collectConflicts(defaults: defaults)
        if !conflicts.isEmpty {
            logConflict(screen: "android_design_beta", conflicts: conflicts)
        }

        do {
            let data = try JSONEncoder().encode(snapshot)
            defaults.set(data, forKey: snapshotKey)
        } catch {
            let message = "failed to encode rollback snapshot: \(error.localizedDescription)"
            logFailure(screen: "android_design_beta", message: message)
            return SosuzagramAndroidDesignModeChange(
                enabled: false,
                restoredKeys: [],
                overriddenKeys: [],
                conflicts: conflicts,
                failureReason: message
            )
        }

        for (key, value) in presetValues {
            store(value: value, forKey: key, defaults: defaults)
        }
        defaults.set(true, forKey: modeKey)

        logModeChange(enabled: true, restoredKeys: [], overriddenKeys: presetValues.map(\.0), conflicts: conflicts, failureReason: nil)
        return SosuzagramAndroidDesignModeChange(
            enabled: true,
            restoredKeys: [],
            overriddenKeys: presetValues.map(\.0),
            conflicts: conflicts,
            failureReason: nil
        )
    }

    private static func disableBetaMode() -> SosuzagramAndroidDesignModeChange {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: modeKey)

        var restoredKeys: [String] = []
        var failureReason: String?

        if let data = defaults.data(forKey: snapshotKey) {
            do {
                let snapshot = try JSONDecoder().decode([SosuzagramAndroidDesignSnapshotEntry].self, from: data)
                for entry in snapshot {
                    restore(entry: entry, defaults: defaults)
                    restoredKeys.append(entry.key)
                }
                defaults.removeObject(forKey: snapshotKey)
            } catch {
                failureReason = "failed to decode rollback snapshot: \(error.localizedDescription)"
            }
        } else {
            failureReason = "rollback snapshot is missing; applied best-effort cleanup"
            for (key, _) in presetValues {
                defaults.removeObject(forKey: key)
                restoredKeys.append(key)
            }
        }

        if let failureReason {
            logFailure(screen: "android_design_beta", message: failureReason)
        }

        logModeChange(enabled: false, restoredKeys: restoredKeys, overriddenKeys: [], conflicts: [], failureReason: failureReason)
        return SosuzagramAndroidDesignModeChange(
            enabled: false,
            restoredKeys: restoredKeys,
            overriddenKeys: [],
            conflicts: [],
            failureReason: failureReason
        )
    }

    private static func captureSnapshot(defaults: UserDefaults) -> [SosuzagramAndroidDesignSnapshotEntry] {
        presetValues.map { key, _ in
            snapshotEntry(forKey: key, value: defaults.object(forKey: key))
        }
    }

    private static func snapshotEntry(forKey key: String, value: Any?) -> SosuzagramAndroidDesignSnapshotEntry {
        switch value {
        case let boolValue as Bool:
            return .init(key: key, kind: .bool, boolValue: boolValue, intValue: nil, stringValue: nil)
        case let intValue as Int:
            return .init(key: key, kind: .int, boolValue: nil, intValue: intValue, stringValue: nil)
        case let stringValue as String:
            return .init(key: key, kind: .string, boolValue: nil, intValue: nil, stringValue: stringValue)
        default:
            return .init(key: key, kind: .missing, boolValue: nil, intValue: nil, stringValue: nil)
        }
    }

    private static func restore(entry: SosuzagramAndroidDesignSnapshotEntry, defaults: UserDefaults) {
        switch entry.kind {
        case .bool:
            defaults.set(entry.boolValue, forKey: entry.key)
        case .int:
            defaults.set(entry.intValue, forKey: entry.key)
        case .string:
            defaults.set(entry.stringValue, forKey: entry.key)
        case .missing:
            defaults.removeObject(forKey: entry.key)
        }
    }

    private static func store(value: SosuzagramAndroidDesignPresetValue, forKey key: String, defaults: UserDefaults) {
        switch value {
        case let .bool(boolValue):
            defaults.set(boolValue, forKey: key)
        case let .int(intValue):
            defaults.set(intValue, forKey: key)
        case let .string(stringValue):
            defaults.set(stringValue, forKey: key)
        }
    }

    private static func collectConflicts(defaults: UserDefaults) -> [String] {
        presetValues.compactMap { key, presetValue in
            let currentValue = defaults.object(forKey: key)
            guard let currentValue else {
                return nil
            }
            if presetMatches(currentValue: currentValue, presetValue: presetValue) {
                return nil
            }
            return "\(key): \(describe(currentValue: currentValue)) -> \(presetValue.description)"
        }
    }

    private static func presetMatches(currentValue: Any, presetValue: SosuzagramAndroidDesignPresetValue) -> Bool {
        switch presetValue {
        case let .bool(value):
            return (currentValue as? Bool) == value
        case let .int(value):
            return (currentValue as? Int) == value
        case let .string(value):
            return (currentValue as? String) == value
        }
    }

    private static func describe(currentValue: Any) -> String {
        if let boolValue = currentValue as? Bool {
            return boolValue ? "true" : "false"
        } else if let intValue = currentValue as? Int {
            return "\(intValue)"
        } else if let stringValue = currentValue as? String {
            return stringValue
        } else {
            return String(describing: currentValue)
        }
    }

    private static func logModeChange(enabled: Bool, restoredKeys: [String], overriddenKeys: [String], conflicts: [String], failureReason: String?) {
        logQueue.sync {
            seenMarkers.removeAll()
        }
        let state = enabled ? "enabled" : "disabled"
        var parts = ["state=\(state)"]
        if !overriddenKeys.isEmpty {
            parts.append("overrides=[\(overriddenKeys.sorted().joined(separator: ", "))]")
        }
        if !restoredKeys.isEmpty {
            parts.append("restored=[\(restoredKeys.sorted().joined(separator: ", "))]")
        }
        if !conflicts.isEmpty {
            parts.append("conflicts=\(conflicts.count)")
        }
        if let failureReason {
            parts.append("failure=\(failureReason)")
        }
        emit(.info, category: "mode", message: parts.joined(separator: " "))
    }

    private static func emit(_ level: OSLogType, category: String, message: String, onceKey: String? = nil) {
        logQueue.sync {
            if let onceKey, seenMarkers.contains(onceKey) {
                return
            }
            if let onceKey {
                seenMarkers.insert(onceKey)
            }
            switch level {
            case .error, .fault:
                logger.error("[\(category, privacy: .public)] \(message, privacy: .public)")
            default:
                logger.log("[\(category, privacy: .public)] \(message, privacy: .public)")
            }
            NSLog("[AndroidDesignBeta][%@] %@", category, message)
        }
    }
}
