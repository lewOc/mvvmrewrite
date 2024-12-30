import SwiftData
import Foundation

@Model
final class TryOnSession {
    var id: UUID
    var startedAt: Date
    var status: TryOnStatus
    var wardrobeItem: WardrobeItem?
    @Relationship(deleteRule: .cascade) var results: [TryOnResult]
    
    init(
        id: UUID = UUID(),
        startedAt: Date = .now,
        status: TryOnStatus = .preparing,
        wardrobeItem: WardrobeItem? = nil
    ) {
        self.id = id
        self.startedAt = startedAt
        self.status = status
        self.wardrobeItem = wardrobeItem
        self.results = []
    }
}

enum TryOnStatus: String, Codable {
    case preparing
    case inProgress
    case completed
    case failed
} 