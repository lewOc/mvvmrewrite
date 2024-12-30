import SwiftUI
import SwiftData

struct WardrobeView: View {
    @StateObject private var viewModel: WardrobeViewModel
    @Query(sort: \WardrobeItem.createdAt, order: .reverse) private var recentItems: [WardrobeItem]
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: WardrobeViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Wardrobe")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        ProfileButtonView(action: viewModel.handleProfileTap)
                    }
                    
                    actionButtons
                    wardrobeItemsSection
                    tryOnResultsSection
                    outfitsSection
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
            .sheet(isPresented: $viewModel.showTryOnView) {
                TryOnItemView(modelContext: viewModel.modelContext)
            }
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            ActionButtonView(
                title: "Try On Outfit",
                icon: "tshirt",
                action: viewModel.handleTryOnOutfit
            )
            
            ActionButtonView(
                title: "Try On Item",
                icon: "person.fill",
                action: viewModel.handleTryOnItem
            )
        }
    }
    
    private var wardrobeItemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Wardrobe Items")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button(action: viewModel.handleAddItem) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.pink)
                }
                .accessibilityLabel("Add wardrobe item")
            }
            
            Text("These are all of your wardrobe items")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Grid of wardrobe items would go here
            if viewModel.isLoading {
                ProgressView()
            } else {
                EmptyView() // Placeholder for grid implementation
            }
        }
    }
    
    private var tryOnResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Try On Results")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            
            Text("View your virtual try-on history")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var outfitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Outfits")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            
            Text("Click an outfit to add accessories")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

