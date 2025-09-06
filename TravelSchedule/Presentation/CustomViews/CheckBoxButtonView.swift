import SwiftUI

struct CheckBoxButtonView: View {
    
    // MARK: - Binding Internal Propeties
    @Binding var isSelected: Bool
    
    // MARK: - Internal Constants
    let filter: Filter
    let title: String
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.regular17)
                .foregroundStyle(.travelBlack)
        }
        .buttonStyle(
            CheckBoxButtonStyle(
                checkboxView: {
                    makeCheckboxView(isSelected, filter: filter)
                }
            )
        )
    }
    
    // MARK: - Private Views
    @ViewBuilder
    private func makeCheckboxView(
        _ isSelected: Bool,
        filter: Filter
    ) -> some View {
        switch filter {
        case .departTime:
            RoundedRectangle(cornerRadius: 4)
                .stroke(.travelBlack, style: .init(lineWidth: 2.4))
                .fill(isSelected ? .travelBlack : .clear)
                .frame(width: 24, height: 24)
                .overlay {
                    if isSelected {
                        Image(systemName: "checkmark")
                            .resizable()
                            .font(.bold34)
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.travelWhite)
                    }
                }
        case .withTransfer:
            Circle()
                .stroke(.travelBlack, style: .init(lineWidth: 2.4))
                .fill(.clear)
                .frame(width: 24)
                .overlay {
                    Circle()
                        .fill(isSelected ? .travelBlack : .clear)
                        .frame(width: 12)
                }
        }
    }
}
