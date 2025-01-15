import SwiftUI
import QuickPick

extension View {
    func withCustomStyle(delegate: TextSettingsDelegate) -> some View {
        modifier(CustomTextStyle(delegate: delegate))
    }
}

struct CustomTextStyle: ViewModifier {
    let delegate: TextSettingsDelegate
    
    func body(content: Content) -> some View {
        content
            .font(.custom(delegate.fontFamily, size: delegate.fontSize))
            .foregroundColor(delegate.textColor)
    }
} 