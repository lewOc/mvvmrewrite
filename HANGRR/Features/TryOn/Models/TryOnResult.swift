import SwiftData
import Foundation

@Model
final class TryOnResult {
    var id: UUID
    var createdAt: Date
    var imageURL: URL?
    var session: TryOnSession?
    
    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        imageURL: URL? = nil,
        session: TryOnSession? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.imageURL = imageURL
        self.session = session
    }
} 