import SwiftUI

struct CheckBoxButtonStyle<V: View>: ButtonStyle {
    
    // MARK: - Internal Constants
    let checkboxView: (() -> V)?
    
    // MARK: - Body
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            if let checkboxView {
                checkboxView()
                    .opacity(configuration.isPressed ? 0.5 : 1)
                    .scaleEffect(configuration.isPressed ? 0.95 : 1)
            }
        }
        .padding(.vertical, 19)
    }
}
