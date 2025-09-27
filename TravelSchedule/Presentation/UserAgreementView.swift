import SwiftUI

struct UserAgreementView: View {
	
	// MARK: - Private States
	@State private var isLoading = true
	
	// MARK: - DI States
	@EnvironmentObject private var coordinator: Coordinator
	
	// MARK: - Body
    var body: some View {
		ZStack {
			Color.travelWhite
				.ignoresSafeArea()
			
			if let url = URL(string: "https://yandex.ru/legal/practicum_offer") {
				WebViewRepresentable(
					url: url,
					isLoading: $isLoading
				)
				
				if isLoading {
					ProgressView()
						.colorMultiply(.travelWhite)
						.progressViewStyle(.circular)
						.scaleEffect(1.5)
				}
				
			} else {
				Text("Sorry, this document is currently unavailable.")
					.font(.bold34)
					.foregroundStyle(.travelBlack)
			}
		}
		.animation(.spring(.bouncy), value: isLoading)
		.navigationTitle(coordinator.navigationTitle)
		.navigationBarTitleDisplayMode(coordinator.navigationTitleDisplayMode)
		.customNavigationBackButton()
    }
}

#Preview {
    UserAgreementView()
}
