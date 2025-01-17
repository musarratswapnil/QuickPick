import SwiftUI

struct WhitePlaceholderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .accentColor(.white)  // Changes cursor and selection color
            .foregroundColor(.white)  // Changes text color
            .tint(.white)  // Changes any tintable elements
            .colorScheme(.dark)  // This helps with placeholder color
    }
}

extension View {
    func whitePlaceholder() -> some View {
        modifier(WhitePlaceholderStyle())
    }
} 