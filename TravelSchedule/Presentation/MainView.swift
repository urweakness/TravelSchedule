import SwiftUI

struct MainView: View {
    
	// --- DI ---
	@Bindable var manager: TravelRoutingManager
	let coordinator: Coordinator
    
    // --- body ---
    @ViewBuilder
    var body: some View {
        ZStack {
            Color.travelWhite
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                coordinator.build(page: .storiesPreview)

                coordinator.build(page: .routing)
                
				if manager.travelPointsFilled {
                    findButtonView
                        .transition(.opacity)
                }
                Spacer()
            }
        }
    }
    
    // --- private subviews ---
    private var findButtonView: some View {
        Button(action: {
			coordinator.push(page: .carriersChoose)
            manager.isDestination = nil
        }) {
            Text("Найти")
                .font(.bold17)
                .foregroundColor(.white)
                .padding(20)
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.travelBlue)
        )
    }
}
