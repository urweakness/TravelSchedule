import SwiftUI

struct RoutingView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var travelRoutingManager: TravelRoutingViewModel
    
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
            let townName = travelRoutingManager.startTown?.name,
            let stationName = travelRoutingManager.startStation?.name
        {
            "\(townName) (\(stationName))"
        } else {
            "Откуда"
        }
    }
    
    private var toTitle: String {
        if
            let townName = travelRoutingManager.destinationTown?.name,
            let stationName = travelRoutingManager.destinationStation?.name
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
                    travelRoutingManager.swapDestinations()
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
        travelRoutingManager.isDestination = isDestination
        coordinator.push(page: .townChoose)
        coordinator.navigationTitleDisplayMode = .inline
    }
}
