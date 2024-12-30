import SwiftUI
import SwiftData

struct TryOnItemView: View {
    @StateObject private var viewModel: TryOnItemViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showImagePicker = false
    @State private var imagePickerType: ImagePickerType = .user
    
    init(modelContext: ModelContext) {
        let fashnService = FashnAPIService(apiKey: "YOUR_API_KEY")
        _viewModel = StateObject(wrappedValue: TryOnItemViewModel(
            modelContext: modelContext,
            fashnService: fashnService
        ))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Your Photo Section
            VStack(alignment: .leading, spacing: 16) {
                Text("Your Photo")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                PhotoUploadView(
                    image: $viewModel.userImage,
                    onTap: {
                        imagePickerType = .user
                        showImagePicker = true
                    }
                )
            }
            
            // Category Selection
            VStack(alignment: .leading, spacing: 16) {
                Text("Select Category")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                CategorySelectionView(
                    selectedCategory: $viewModel.selectedCategory
                )
            }
            
            // Garment Selection
            VStack(alignment: .leading, spacing: 16) {
                Text("Select Garment")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                GarmentUploadView(
                    image: $viewModel.garmentImage,
                    onTap: {
                        imagePickerType = .garment
                        showImagePicker = true
                    }
                )
            }
            
            Spacer()
            
            // Try It On Button
            VStack(spacing: 8) {
                Button(action: {
                    Task {
                        await viewModel.generateTryOn()
                    }
                }) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Try It On")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray4))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!viewModel.canTryOn)
                
                Text("Use AI to virtually try on an item. This currently works with tops, bottoms and all in ones like dresses and one-pieces")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Try On Item")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.blue)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: imagePickerType == .user ? $viewModel.userImage : $viewModel.garmentImage)
        }
    }
}

// MARK: - Supporting Views
struct PhotoUploadView: View {
    @Binding var image: UIImage?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [8]))
                        .foregroundColor(.pink)
                        .frame(height: 200)
                    
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundColor(.pink)
                }
            }
        }
    }
}

struct CategorySelectionView: View {
    @Binding var selectedCategory: ItemCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ItemCategory.allCases, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        Text(category.displayName)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedCategory == category 
                                ? Color.pink.opacity(0.2) 
                                : Color(.systemGray6)
                            )
                            .foregroundColor(
                                selectedCategory == category 
                                ? .pink 
                                : .primary
                            )
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}

struct GarmentUploadView: View {
    @Binding var image: UIImage?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.pink.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .overlay(
                        VStack(spacing: 4) {
                            Image(systemName: "plus")
                                .foregroundColor(.pink)
                            Text("Upload")
                                .font(.caption)
                                .foregroundColor(.pink)
                        }
                    )
            }
        }
    }
}


#Preview {
    TryOnItemView(modelContext: PreviewContainer.shared.mainContext)
} 
