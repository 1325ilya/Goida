import Foundation

public enum SosuzagramBuiltInAppIcon: String, CaseIterable, Codable, Sendable {
    case systemDefault = "default"
    case red = "Red"
    case green = "Green"
    case orange = "Orange"
    case purple = "Purple"

    public var alternateIconName: String? {
        switch self {
        case .systemDefault:
            return nil
        case .red, .green, .orange, .purple:
            return self.rawValue
        }
    }
}

public struct SosuzagramCustomAppIconMetadata: Codable, Equatable, Sendable {
    public let id: UUID
    public let originalFilename: String
    public let pixelWidth: Int
    public let pixelHeight: Int
    public let fileSizeBytes: Int
    public let importedAt: Date

    public init(
        id: UUID,
        originalFilename: String,
        pixelWidth: Int,
        pixelHeight: Int,
        fileSizeBytes: Int,
        importedAt: Date
    ) {
        self.id = id
        self.originalFilename = originalFilename
        self.pixelWidth = pixelWidth
        self.pixelHeight = pixelHeight
        self.fileSizeBytes = fileSizeBytes
        self.importedAt = importedAt
    }
}

public enum SosuzagramAppIconSelection: Equatable, Sendable, Codable {
    case builtIn(SosuzagramBuiltInAppIcon)
    case custom(UUID)

    private enum CodingKeys: String, CodingKey {
        case kind
        case builtIn
        case customId
    }

    private enum Kind: String, Codable {
        case builtIn
        case custom
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)
        switch kind {
        case .builtIn:
            self = .builtIn(try container.decode(SosuzagramBuiltInAppIcon.self, forKey: .builtIn))
        case .custom:
            self = .custom(try container.decode(UUID.self, forKey: .customId))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .builtIn(icon):
            try container.encode(Kind.builtIn, forKey: .kind)
            try container.encode(icon, forKey: .builtIn)
        case let .custom(id):
            try container.encode(Kind.custom, forKey: .kind)
            try container.encode(id, forKey: .customId)
        }
    }
}

public struct SosuzagramAppIconPreferences: Codable, Equatable, Sendable {
    public var selection: SosuzagramAppIconSelection
    public var customIcon: SosuzagramCustomAppIconMetadata?
    public var lastAppliedBuiltInIcon: SosuzagramBuiltInAppIcon

    public init(
        selection: SosuzagramAppIconSelection = .builtIn(.systemDefault),
        customIcon: SosuzagramCustomAppIconMetadata? = nil,
        lastAppliedBuiltInIcon: SosuzagramBuiltInAppIcon = .systemDefault
    ) {
        self.selection = selection
        self.customIcon = customIcon
        self.lastAppliedBuiltInIcon = lastAppliedBuiltInIcon
    }
}
