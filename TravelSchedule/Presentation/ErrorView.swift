import SwiftUI

struct ErrorView: View {
    
    // MARK: - Error kind
    let kind: ErrorKind
    
    // MARK: - Body
    @ViewBuilder
    var body: some View {
        ZStack {
            Color.travelWhite
                .ignoresSafeArea()
            
            makeErrorBody(kind: kind)
                .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Private Views
    private func makeErrorBody(kind: ErrorKind) -> some View {
        VStack(spacing: 16) {
            Image(kind.imageResource)
            Text(kind.description)
                .font(.bold24)
                .foregroundStyle(.travelBlack)
                .multilineTextAlignment(.center)
                .lineLimit(4)
        }
    }
}

#Preview {
    ErrorView(kind: .unknown(NSError(domain: "osidjfodisjfosidjfoidj", code: 0)))
}
