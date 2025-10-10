import SwiftUI

struct UserAgreementView: View {
	
	// --- private states ---
	@State private var isLoading = true
	
	// --- DI ---
	let pop: () -> Void
	let navigationTitle: String
	let navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode
	@Environment(\.colorScheme) private var colorScheme: ColorScheme
	
	// --- body ---
    var body: some View {
		ZStack {
			Color.travelWhite
				.ignoresSafeArea()
			
			if let url = URL(string: GlobalConstants.userAgreementURLString) {
				WebViewRepresentable(
					url: url,
					isLoading: $isLoading,
					colorScheme: colorScheme
				)
				
				if isLoading {
					ProgressView()
						.colorMultiply(.travelWhite)
						.progressViewStyle(.circular)
						.scaleEffect(1.5)
				}
				
			} else {
				Text(.sorryThisDocumentIsCurrentlyUnavailable)
					.font(.bold34)
					.foregroundStyle(.travelBlack)
			}
		}
		.animation(.spring(.bouncy), value: isLoading)
		.navigationTitle(navigationTitle)
		.navigationBarTitleDisplayMode(navigationTitleDisplayMode)
		.customNavigationBackButton(pop: pop)
    }
}
