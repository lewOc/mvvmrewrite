import SwiftUI
import SwiftData

@MainActor
final class TryOnItemViewModel: ObservableObject {
    @Published var userImage: UIImage?
    @Published var garmentImage: UIImage?
    @Published var selectedCategory: ItemCategory?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showError = false
    @Published var resultImageURL: URL?
    
    var canTryOn: Bool {
        userImage != nil && garmentImage != nil && selectedCategory != nil
    }
    
    private let modelContext: ModelContext
    private let fashnService: FashnAPIService
    
    init(modelContext: ModelContext, fashnService: FashnAPIService) {
        self.modelContext = modelContext
        self.fashnService = fashnService
    }
    
    func generateTryOn() async {
        guard canTryOn,
              let userImage = userImage,
              let garmentImage = garmentImage,
              let userImageData = userImage.jpegData(compressionQuality: 0.8),
              let garmentImageData = garmentImage.jpegData(compressionQuality: 0.8) else {
            error = FashnAPIError.requestFailed("Missing required images")
            showError = true
            return
        }
        
        isLoading = true
        
        do {
            let resultURL = try await fashnService.generateTryOn(
                userImage: userImageData,
                garmentImage: garmentImageData
            )
            
            let session = TryOnSession(status: .completed)
            let result = TryOnResult(imageURL: resultURL, session: session)
            
            modelContext.insert(session)
            modelContext.insert(result)
            try modelContext.save()
            
            resultImageURL = resultURL
            
        } catch {
            self.error = error
            showError = true
        }
        
        isLoading = false
    }
} 