import SwiftUI

struct RoutingView: View {
    
	// --- DI ---
	@Bindable var manager: TravelRoutingManager
	let push: (Page) -> Void
    
	// --- body ---
    var body: some View {
        ViewThatFits {
            HStack(spacing: 16) {
                textFields
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                switchButton
            }
            .padding(16)
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.travelBlue)
        }
        .padding(.horizontal, 16)
    }
    
	// --- private subviews ---
    private var fromTitle: String {
        if
            let townName = manager.startTown?.name,
            let stationName = manager.startStation?.name
        {
            "\(townName) (\(stationName))"
        } else {
			.init(localized: .from)
        }
    }
    
    private var toTitle: String {
        if
            let townName = manager.destinationTown?.name,
            let stationName = manager.destinationStation?.name
        {
            "\(townName) (\(stationName))"
        } else {
			.init(localized: .to)
        }
    }
	
	@ViewBuilder
	private func textView(isFrom: Bool) -> some View {
		let title = isFrom ? fromTitle : toTitle
		let localized = String(localized: isFrom ? .from : .to)
		
		HStack {
			Text(title)
				.font(.regular17)
				.foregroundColor(
					title == localized ? .travelGray : .black
				)
				.lineLimit(1)
				.accessibilityIdentifier(
					isFrom ?
					AccessibilityIdentifier.fromLabel.rawValue :
					AccessibilityIdentifier.toLabel.rawValue
				)
			Spacer()
		}
		.padding(16)
		.padding(.horizontal, 5)
		.background(.white)
		.simultaneousGesture(
			TapGesture().onEnded { _ in
				route(isDestination: !isFrom)
			}
		)
	}
    
    private var textFields: some View {
        VStack(spacing: 0) {
			textView(isFrom: true)
			textView(isFrom: false)
        }
    }
    
    private var switchButton: some View {
        Button(
            action: {
                withAnimation(.easeInOut(duration: 0.15)) {
                    manager.swapDestinations()
                }
            }
        ) {
            Circle()
                .fill(Color.white)
                .frame(width: 36)
                .overlay {
                    Image(systemName: "arrow.2.squarepath")
                        .renderingMode(.template)
                        .tint(.travelBlue)
                }
        }
		.accessibilityIdentifier(
			AccessibilityIdentifier.switchLabelsButton.rawValue
		)
    }
    
    private func route(isDestination: Bool) {
        manager.isDestination = isDestination
        push(.townChoose)
    }
}
