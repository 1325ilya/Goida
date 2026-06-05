import Foundation

public enum AyuChatKind: String, Sendable, Codable, Equatable {
    case user
    case group
    case supergroup
    case channel
    case privateEncrypted
}

public struct AyuMessageSnapshot: Sendable, Codable, Equatable, Identifiable {
    public var id: Int64 { messageId }
    public let peerId: Int64
    public let messageId: Int64
    public let chatKind: AyuChatKind
    public let senderId: Int64?
    public let text: String?
    public let mediaLocalIdentifier: String?
    public let originalTimestamp: Date
    public let isOutgoing: Bool

    public init(
        peerId: Int64,
        messageId: Int64,
        chatKind: AyuChatKind,
        senderId: Int64?,
        text: String?,
        mediaLocalIdentifier: String? = nil,
        originalTimestamp: Date,
        isOutgoing: Bool
    ) {
        self.peerId = peerId
        self.messageId = messageId
        self.chatKind = chatKind
        self.senderId = senderId
        self.text = text
        self.mediaLocalIdentifier = mediaLocalIdentifier
        self.originalTimestamp = originalTimestamp
        self.isOutgoing = isOutgoing
    }
}

public struct AyuArchivedMessage: Sendable, Codable, Equatable, Identifiable {
    public var id: Int64 { snapshot.messageId }
    public let snapshot: AyuMessageSnapshot
    public var removedTimestamp: Date?
    public var isRemoved: Bool

    public init(snapshot: AyuMessageSnapshot, removedTimestamp: Date? = nil, isRemoved: Bool = false) {
        self.snapshot = snapshot
        self.removedTimestamp = removedTimestamp
        self.isRemoved = isRemoved
    }
}
