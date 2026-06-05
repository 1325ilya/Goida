import Foundation

public struct AntiDeleteSettings: Sendable, Equatable {
    public var isEnabled: Bool
    public var archiveTextMessages: Bool
    public var archiveMediaReferences: Bool
    public var ignoreSecretChats: Bool
    public var showDeletedBadge: Bool

    public init(
        isEnabled: Bool = true,
        archiveTextMessages: Bool = true,
        archiveMediaReferences: Bool = true,
        ignoreSecretChats: Bool = true,
        showDeletedBadge: Bool = true
    ) {
        self.isEnabled = isEnabled
        self.archiveTextMessages = archiveTextMessages
        self.archiveMediaReferences = archiveMediaReferences
        self.ignoreSecretChats = ignoreSecretChats
        self.showDeletedBadge = showDeletedBadge
    }
}
