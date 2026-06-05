import Foundation

public enum ChatKind: String, Sendable, Codable, Equatable {
    case user
    case group
    case supergroup
    case channel
    case privateEncrypted
}

public struct MessageSnapshot: Sendable, Codable, Equatable, Identifiable {
    public var id: Int64 { messageId }
    public let peerId: Int64
    public let messageId: Int64
    public let chatKind: ChatKind
    public let senderId: Int64?
    public let text: String?
    public let mediaLocalIdentifier: String?
    public let originalTimestamp: Date
    public let isOutgoing: Bool

    public init(
        peerId: Int64,
        messageId: Int64,
        chatKind: ChatKind,
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

public struct LocalHistoryItem: Sendable, Codable, Equatable, Identifiable {
    public var id: Int64 { snapshot.messageId }
    public let snapshot: MessageSnapshot
    public var noLongerVisibleAt: Date?
    public var isNoLongerVisible: Bool

    public init(snapshot: MessageSnapshot, noLongerVisibleAt: Date? = nil, isNoLongerVisible: Bool = false) {
        self.snapshot = snapshot
        self.noLongerVisibleAt = noLongerVisibleAt
        self.isNoLongerVisible = isNoLongerVisible
    }
}
