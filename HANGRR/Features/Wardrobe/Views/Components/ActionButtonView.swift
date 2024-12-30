import SwiftUI

struct ActionButtonView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pink.opacity(0.3))
            .foregroundColor(.pink)
            .cornerRadius(12)
        }
        .accessibilityLabel(title)
    }
} 