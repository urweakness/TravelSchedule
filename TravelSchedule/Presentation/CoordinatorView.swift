import SwiftUI

struct CoordinatorView: View {
    
    @StateObject private var coordinator = Coordinator()
    @StateObject private var appManager = AppManager()
    @StateObject private var storiesViewModel = StoriesManager()
    @StateObject private var travelRoutingViewModel = TravelRoutingViewModel()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .main)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                    coordinator.build(fullScreenCover: fullScreenCover)
                }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(coordinator.navigationTitle)
        .navigationBarTitleDisplayMode(coordinator.navigationTitleDisplayMode)
        .environmentObject(coordinator)
        .environmentObject(storiesViewModel)
        .environmentObject(travelRoutingViewModel)
        .environmentObject(appManager)
//        .task(priority: .background) {
//            Task {
//                appManager.loadingState = .fetching
//                do {
//                    appManager.stationList = try await ServicesManager.shared.getStationsList()
//                    appManager.loadingState = .idle
//                } catch {
//                    appManager.loadingState = .error(.unknown(error))
//                }
//            }
//        }
    }
}

#Preview {
    CoordinatorView()
}
