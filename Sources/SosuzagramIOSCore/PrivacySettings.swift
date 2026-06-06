import Foundation

public struct PrivacySettings: Sendable, Equatable {
    public var keepLocalHistory: Bool
    public var keepText: Bool
    public var keepMediaReferences: Bool
    public var skipPrivateEncryptedChats: Bool
    public var showLocalMarker: Bool

    public init() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "sosuzagram_local_history") != nil {
            self.keepLocalHistory = defaults.bool(forKey: "sosuzagram_local_history")
        } else {
            self.keepLocalHistory = true
        }
        self.keepText = true
        self.keepMediaReferences = true
        self.skipPrivateEncryptedChats = true
        self.showLocalMarker = true
    }
}
