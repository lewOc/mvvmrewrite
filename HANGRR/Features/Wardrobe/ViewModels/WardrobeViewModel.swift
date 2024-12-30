import SwiftUI
import SwiftData

@MainActor
final class WardrobeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addItem(_ item: WardrobeItem) {
        isLoading = true
        defer { isLoading = false }
        
        do {
            modelContext.insert(item)
            try modelContext.save()
        } catch {
            errorMessage = "Failed to add item: \(error.localizedDescription)"
            showError = true
        }
    }
    
    func handleProfileTap() {
        // Handle profile navigation
    }
    
    func handleTryOnOutfit() {
        // Handle try on outfit action
    }
    
    func handleTryOnItem() {
        // Handle try on item action
    }
    
    func handleAddItem() {
        // Handle add item action
    }
} 