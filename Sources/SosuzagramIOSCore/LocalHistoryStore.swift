import Foundation

public protocol LocalHistoryStore: Sendable {
    func save(_ item: LocalHistoryItem) async throws
    func item(peerId: Int64, messageId: Int64) async throws -> LocalHistoryItem?
    func items(peerId: Int64) async throws -> [LocalHistoryItem]
    func markNoLongerVisible(peerId: Int64, messageIds: [Int64], at date: Date) async throws
    func clear(peerId: Int64?) async throws
}
