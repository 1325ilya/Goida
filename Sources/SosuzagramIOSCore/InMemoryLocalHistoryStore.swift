import Foundation

public actor InMemoryLocalHistoryStore: LocalHistoryStore {
    private var storage: [String: LocalHistoryItem] = [:]

    public init() {}

    public func save(_ item: LocalHistoryItem) async throws {
        storage[key(item.snapshot.peerId, item.snapshot.messageId)] = item
    }

    public func item(peerId: Int64, messageId: Int64) async throws -> LocalHistoryItem? {
        storage[key(peerId, messageId)]
    }

    public func items(peerId: Int64) async throws -> [LocalHistoryItem] {
        storage.values
            .filter { $0.snapshot.peerId == peerId }
            .sorted { $0.snapshot.originalTimestamp < $1.snapshot.originalTimestamp }
    }

    public func markNoLongerVisible(peerId: Int64, messageIds: [Int64], at date: Date) async throws {
        for messageId in messageIds {
            let storageKey = key(peerId, messageId)
            guard var item = storage[storageKey] else { continue }
            item.isNoLongerVisible = true
            item.noLongerVisibleAt = date
            storage[storageKey] = item
        }
    }

    public func clear(peerId: Int64?) async throws {
        if let peerId {
            storage = storage.filter { $0.value.snapshot.peerId != peerId }
        } else {
            storage.removeAll()
        }
    }

    private func key(_ peerId: Int64, _ messageId: Int64) -> String {
        "\(peerId):\(messageId)"
    }
}
