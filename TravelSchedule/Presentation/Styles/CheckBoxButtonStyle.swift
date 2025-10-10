import SwiftUI

struct CheckBoxButtonStyle<V: View>: ButtonStyle {
    
    // --- DI ---
    let checkboxView: (() -> V)?
    
    // --- body ---
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
