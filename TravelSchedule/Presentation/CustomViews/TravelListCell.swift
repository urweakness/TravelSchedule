import SwiftUI

struct TravelListCell<V: View>: View {
    
	// --- DI ---
	let text: String
	let buttonAction: (() -> Void)?
	let rightView: () -> V
    
	// --- body ---
    var body: some View {
		if let buttonAction {
			Button(action: buttonAction){
				content
			}
			.buttonStyle(.plain)
		} else {
			content
		}
    }
	
	private var content: some View {
		HStack {
			Text(text)
				.font(.regular17)
				.accessibilityIdentifier(
					AccessibilityIdentifier.settingsLabel.rawValue
				)
			Spacer()
			rightView()
		}
		.padding(.vertical, 12)
	}
}
