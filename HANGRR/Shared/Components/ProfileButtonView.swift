import SwiftUI

struct ProfileButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.primary)
        }
        .accessibilityLabel("Profile")
    }
} 