import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    @ViewBuilder
    var body: some View {
        VStack(spacing: 20) {
            StoriesView(stories: stories)
            RoutingView()
            
            if coordinator.travelPointsFilled {
                findButton
                    .transition(.opacity)
            }
            Spacer()
        }
        .background(.travelWhite)
        .task {
            Task {
//                await ServicesManager.shared.showCarrierInfo()
//                await ServicesManager.shared.showThreadStations()
//                await ServicesManager.shared.showCopyright()
//                await ServicesManager.shared.showStationSchedule()
                
//                await ServicesManager.shared.showNearestCity()
//                await ServicesManager.shared.showNearestStations()
//                await ServicesManager.shared.showSegments()
                await ServicesManager.shared.showStationsList()
            }
        }
    }
    
    private var findButton: some View {
        Button(action: {
            coordinator.push(page: .transportersChoose)
            coordinator.isDestination = nil
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
