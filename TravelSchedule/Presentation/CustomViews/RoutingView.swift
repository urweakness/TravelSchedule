import SwiftUI

struct RoutingView: View {
    
	@Bindable var manager: TravelRoutingManager
	let push: (Page) -> Void
    
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
    
    private var fromTitle: String {
        if
            let townName = manager.startTown?.name,
            let stationName = manager.startStation?.name
        {
            "\(townName) (\(stationName))"
        } else {
            "Откуда"
        }
    }
    
    private var toTitle: String {
        if
            let townName = manager.destinationTown?.name,
            let stationName = manager.destinationStation?.name
        {
            "\(townName) (\(stationName))"
        } else {
            "Куда"
        }
    }
    
    private var fromTextView: some View {
        HStack {
            Text(fromTitle)
                .font(.regular17)
                .foregroundColor(fromTitle == "Откуда" ? .travelGray : .black)
                .lineLimit(1)
            Spacer()
        }
        .padding(16)
        .padding(.horizontal, 5)
        .background(.white)
        .simultaneousGesture(
            TapGesture().onEnded { _ in
                route(isDestination: false)
            }
        )
    }
    
    private var toTextView: some View {
        HStack {
            Text(toTitle)
                .font(.regular17)
                .foregroundColor(toTitle == "Куда" ? .travelGray : .black)
                .lineLimit(1)
            Spacer()
        }
        .padding(16)
        .padding(.horizontal, 5)
        .background(.white)
        .simultaneousGesture(
            TapGesture().onEnded { _ in
                route(isDestination: true)
            }
        )
    }
    
    private var textFields: some View {
        VStack(spacing: 0) {
            fromTextView
            toTextView
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
    }
    
    private func route(isDestination: Bool) {
        manager.isDestination = isDestination
        push(.townChoose)
    }
}
