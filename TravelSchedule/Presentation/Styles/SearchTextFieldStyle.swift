import SwiftUI

struct SearchTextFieldStyle: TextFieldStyle {
	
	// MARK: - States
    @Binding var text: String
    @State private var isEmpty = true
    
	// MARK: - Body
    @ViewBuilder
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            magnifyingglass
            
            configuration.body
                .foregroundStyle(.travelBlack)
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
    
	// MARK: - Private views
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
	
	// MARK: - Private Methods
	private func clear() {
		text = ""
	}
}
