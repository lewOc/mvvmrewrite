import SwiftData
import Foundation

@Model
final class WardrobeItem {
    var id: UUID
    var name: String
    var category: ItemCategory
    var imageURL: URL?
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        category: ItemCategory,
        imageURL: URL? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.imageURL = imageURL
        self.createdAt = createdAt
    }
}

enum ItemCategory: String, Codable, CaseIterable {
    case tShirt = "tshirt"
    case trousers
    case dress
    
    var displayName: String {
        switch self {
        case .tShirt: return "T-Shirt"
        case .trousers: return "Trousers"
        case .dress: return "Dress"
        }
    }
} 