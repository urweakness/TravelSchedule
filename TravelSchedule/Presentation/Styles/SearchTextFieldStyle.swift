import SwiftUI

struct SearchTextFieldStyle: TextFieldStyle {
    @Binding var text: String
    @State private var isEmpty = true
    
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
    
    private func clear() {
        text = ""
    }
    
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
}
