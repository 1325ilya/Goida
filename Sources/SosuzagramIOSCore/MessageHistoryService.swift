import Foundation

public struct MessageHistoryService: Sendable {
    private let store: LocalHistoryStore
    private let settingsProvider: @Sendable () -> PrivacySettings

    public init(
        store: LocalHistoryStore,
        settingsProvider: @escaping @Sendable () -> PrivacySettings = { PrivacySettings() }
    ) {
        self.store = store
        self.settingsProvider = settingsProvider
    }

    public func recordIncomingMessage(_ snapshot: MessageSnapshot) async throws {
        let settings = settingsProvider()
        guard settings.keepLocalHistory else { return }
        if settings.skipPrivateEncryptedChats && snapshot.chatKind == .privateEncrypted { return }

        let sanitized = MessageSnapshot(
            peerId: snapshot.peerId,
            messageId: snapshot.messageId,
            chatKind: snapshot.chatKind,
            senderId: snapshot.senderId,
            text: settings.keepText ? snapshot.text : nil,
            mediaLocalIdentifier: settings.keepMediaReferences ? snapshot.mediaLocalIdentifier : nil,
            originalTimestamp: snapshot.originalTimestamp,
            isOutgoing: snapshot.isOutgoing
        )

        try await store.save(LocalHistoryItem(snapshot: sanitized))
    }

    public func recordMessageRemoval(peerId: Int64, messageIds: [Int64], at date: Date = Date()) async throws {
        let settings = settingsProvider()
        guard settings.keepLocalHistory else { return }
        try await store.markNoLongerVisible(peerId: peerId, messageIds: messageIds, at: date)
    }

    public func localCopy(peerId: Int64, messageId: Int64) async throws -> LocalHistoryItem? {
        try await store.item(peerId: peerId, messageId: messageId)
    }

    public func localCopies(peerId: Int64) async throws -> [LocalHistoryItem] {
        try await store.items(peerId: peerId)
    }
}
