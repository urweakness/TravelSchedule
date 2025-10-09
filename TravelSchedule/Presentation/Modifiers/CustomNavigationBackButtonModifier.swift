import SwiftUI

struct CustomNavigationBackButtonModifier: ViewModifier {
    
	// --- DI ---
	let pop: () -> Void
    
	// --- body ---
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: pop) {
                        Image(systemName: "chevron.left")
                            .renderingMode(.template)
                            .foregroundStyle(.travelBlack)
                            .font(.bold17)
                    }
					.accessibilityIdentifier(
						AccessibilityIdentifier.backButton.rawValue
					)
                }
            }
    }
}
