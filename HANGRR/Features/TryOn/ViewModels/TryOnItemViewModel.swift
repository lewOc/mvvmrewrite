import SwiftUI
import SwiftData

@MainActor
final class TryOnItemViewModel: ObservableObject {
    @Published var selectedItem: WardrobeItem?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showError = false
    @Published var isCameraActive = false
    @Published var currentSession: TryOnSession?
    
    private let modelContext: ModelContext
    private let tryOnService: TryOnService
    
    init(modelContext: ModelContext, tryOnService: TryOnService = TryOnService()) {
        self.modelContext = modelContext
        self.tryOnService = tryOnService
    }
    
    func startSession(with item: WardrobeItem) {
        isLoading = true
        
        let session = TryOnSession(wardrobeItem: item)
        modelContext.insert(session)
        currentSession = session
        
        do {
            try modelContext.save()
            selectedItem = item
            isLoading = false
        } catch {
            self.error = error
            showError = true
            isLoading = false
        }
    }
    
    func captureImage() async {
        guard let session = currentSession else { return }
        
        isLoading = true
        do {
            let result = try await tryOnService.captureImage(session: session)
            modelContext.insert(result)
            try modelContext.save()
            isLoading = false
        } catch {
            self.error = error
            showError = true
            isLoading = false
        }
    }
} 