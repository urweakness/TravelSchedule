import SwiftUI

struct TravelListCell<V: View>: View {
    
	// MARK: - State Properties
    @State var text: String
    @State var rightView: () -> V
	
	// MARK: - Constant Actions
	let buttonAction: (() -> Void)?
	
	init(
		text: String,
		buttonAction: (() -> Void)?,
		rightView: @escaping () -> V,
	) {
		self.text = text
		self.rightView = rightView
		self.buttonAction = buttonAction
	}
    
    var body: some View {
        Button(action: buttonAction ?? {}){
            HStack {
                Text(text)
                    .font(.regular17)
                Spacer()
                rightView()
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}
