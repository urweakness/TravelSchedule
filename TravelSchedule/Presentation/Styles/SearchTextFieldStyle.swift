import SwiftUI

@MainActor
struct SearchTextFieldStyle: @MainActor TextFieldStyle {
	
	// --- states ---
    @Binding var text: String
    @State private var isEmpty = true
    
	// --- body ---
    @ViewBuilder
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            magnifyingglass
            
            configuration.body.foregroundStyle(.travelBlack)
            Spacer()

            if !isEmpty {
                clearButton
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.travelLightGray)
        )
        .onChange(of: text) { oldValue, newValue in
            withAnimation(.linear(duration: 0.1)) {
                isEmpty = newValue.isEmpty
            }
        }
    }
    
	// --- private subviews ---
    private var magnifyingglass: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.travelGray)
    }
    
    private var clearButton: some View {
        Button(action: clear) {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.travelGray)
        }
        .transition(.opacity)
    }
	
	// --- private methods ---
	private func clear() {
		text = ""
	}
}
