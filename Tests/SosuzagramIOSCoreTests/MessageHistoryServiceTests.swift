import XCTest
@testable import SosuzagramIOSCore

final class MessageHistoryServiceTests: XCTestCase {
    func testRecordsIncomingMessage() async throws {
        let store = InMemoryLocalHistoryStore()
        let service = MessageHistoryService(store: store)
        let snapshot = makeSnapshot(text: "hello")

        try await service.recordIncomingMessage(snapshot)
        let copy = try await service.localCopy(peerId: 1, messageId: 10)

        XCTAssertEqual(copy?.snapshot.text, "hello")
        XCTAssertEqual(copy?.isNoLongerVisible, false)
    }

    func testMarksMessageAsNoLongerVisible() async throws {
        let store = InMemoryLocalHistoryStore()
        let service = MessageHistoryService(store: store)
        let snapshot = makeSnapshot(text: "hidden text")

        try await service.recordIncomingMessage(snapshot)
        try await service.recordMessageRemoval(peerId: 1, messageIds: [10], at: Date(timeIntervalSince1970: 200))
        let copy = try await service.localCopy(peerId: 1, messageId: 10)

        XCTAssertEqual(copy?.snapshot.text, "hidden text")
        XCTAssertEqual(copy?.isNoLongerVisible, true)
        XCTAssertEqual(copy?.noLongerVisibleAt, Date(timeIntervalSince1970: 200))
    }

    func testSkipsPrivateEncryptedChatsByDefault() async throws {
        let store = InMemoryLocalHistoryStore()
        let service = MessageHistoryService(store: store)
        let snapshot = MessageSnapshot(
            peerId: 1,
            messageId: 10,
            chatKind: .privateEncrypted,
            senderId: 2,
            text: "secret",
            originalTimestamp: Date(timeIntervalSince1970: 100),
            isOutgoing: false
        )

        try await service.recordIncomingMessage(snapshot)
        let copy = try await service.localCopy(peerId: 1, messageId: 10)

        XCTAssertNil(copy)
    }

    private func makeSnapshot(text: String) -> MessageSnapshot {
        MessageSnapshot(
            peerId: 1,
            messageId: 10,
            chatKind: .user,
            senderId: 2,
            text: text,
            originalTimestamp: Date(timeIntervalSince1970: 100),
            isOutgoing: false
        )
    }
}
