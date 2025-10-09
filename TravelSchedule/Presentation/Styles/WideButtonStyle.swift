import SwiftUI

struct WideButtonStyle: ButtonStyle {
    // --- body ---
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.bold17)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.travelBlue)
            }
            .padding(.horizontal, 16)
    }
}
