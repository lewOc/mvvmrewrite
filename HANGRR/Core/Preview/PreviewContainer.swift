import SwiftUI
import SwiftData

@MainActor
struct PreviewContainer {
    static let shared = PreviewContainer()
    
    let container: ModelContainer
    var mainContext: ModelContext { container.mainContext }
    
    init() {
        let schema = Schema([
            WardrobeItem.self,
            TryOnSession.self,
            TryOnResult.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: schema, configurations: configuration)
            // Add sample data if needed
            createSampleData()
        } catch {
            fatalError("Could not create preview container: \(error)")
        }
    }
    
    private func createSampleData() {
        let item = WardrobeItem(
            name: "Sample T-Shirt",
            category: .tShirt,
            imageURL: nil
        )
        mainContext.insert(item)
        try? mainContext.save()
    }
}

#Preview {
    @MainActor func previewView() -> some View {
        TryOnItemView(modelContext: PreviewContainer.shared.mainContext)
    }
    return previewView()
} 