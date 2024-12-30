import SwiftUI
import SwiftData

struct TryOnItemView: View {
    @StateObject private var viewModel: TryOnItemViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: TryOnItemViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxHeight: .infinity)
                } else {
                    ItemPreviewView(item: viewModel.selectedItem)
                        .frame(height: 200)
                        .accessibilityLabel("Selected item preview")
                    
                    CameraPreviewView(isActive: $viewModel.isCameraActive)
                        .frame(maxHeight: .infinity)
                        .accessibilityLabel("Camera preview")
                    
                    TryOnControlsView(
                        onCapture: {
                            Task {
                                await viewModel.captureImage()
                            }
                        }
                    )
                }
            }
            .padding()
            .navigationTitle("Try On Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") { }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "An unknown error occurred")
            }
        }
    }
}

#Preview {
    TryOnItemView(modelContext: PreviewContainer.shared.mainContext)
} 