import SwiftUI

struct MainView: View{
    
	// --- DI ---
	@Bindable var manager: TravelRoutingManager
	let storiesPreviewContent: () -> StoriesPreviewView
	let routingContent: () -> RoutingView
	let push: (Page) -> Void
    
    // --- body ---
    @ViewBuilder
    var body: some View {
        ZStack {
            Color.travelWhite
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
				storiesPreviewContent()
				
				routingContent()
                
				if manager.travelPointsFilled {
                    findButtonView
                        .transition(.opacity)
                }
                Spacer()
            }
        }
		.onAppear {
			manager.clearFilter()
		}
    }
    
    // --- private subviews ---
    private var findButtonView: some View {
        Button(action: {
			push(.carriersChoose)
			manager.isDestination = nil
        }) {
			Text(.find)
				.font(.bold17)
				.foregroundColor(.white)
				.padding(20)
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.travelBlue)
        )
		.accessibilityIdentifier(
			AccessibilityIdentifier.findButton.rawValue
		)
    }
}
