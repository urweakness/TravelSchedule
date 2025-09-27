import SwiftUI

// MARK: - View Extensions

// MARK: Internal custom nav back button
extension View {
    func customNavigationBackButton() -> some View {
        modifier(CustomNavigationBackButton())
    }
}
