import SwiftUI

struct ErrorView: View {
    
    // --- DI ---
    let kind: ErrorKind
	let onDismiss: () -> Void
    
    // --- body ---
    @ViewBuilder
    var body: some View {
        ZStack {
            Color.travelWhite
                .ignoresSafeArea()
            
            makeErrorBody(kind: kind)
                .padding(.horizontal, 16)
        }
		.overlay(alignment: .topTrailing) {
			dismissButton
				.frame(width: 40, height: 40)
				.padding(16)
		}
    }
    
    // --- private views ---
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
	
	@ViewBuilder
	private var dismissButton: some View {
		if kind != .noInternet {
			Button(action: {
				onDismiss()
			}) {
				Image(systemName: "xmark")
					.foregroundStyle(.travelBlack)
			}
		}
	}
}

#if DEBUG
#Preview {
//    ErrorView(kind: .unknown(NSError(domain: "osidjfodisjfosidjfoidj", code: 0)))
	ErrorView(kind: .serverError, onDismiss: {})
}
#endif
