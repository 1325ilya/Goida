import Foundation

public struct PrivacySettings: Sendable, Equatable {
    public var keepLocalHistory: Bool
    public var keepText: Bool
    public var keepMediaReferences: Bool
    public var skipPrivateEncryptedChats: Bool
    public var showLocalMarker: Bool

    public init(
        keepLocalHistory: Bool = true,
        keepText: Bool = true,
        keepMediaReferences: Bool = true,
        skipPrivateEncryptedChats: Bool = true,
        showLocalMarker: Bool = true
    ) {
        self.keepLocalHistory = keepLocalHistory
        self.keepText = keepText
        self.keepMediaReferences = keepMediaReferences
        self.skipPrivateEncryptedChats = skipPrivateEncryptedChats
        self.showLocalMarker = showLocalMarker
    }
}
