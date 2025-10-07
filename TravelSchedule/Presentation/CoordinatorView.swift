import SwiftUI

struct CoordinatorView: View {
	
	// MARK: - Private States
    @StateObject private var coordinator: Coordinator
	@State private var viewModel: CoordinatorViewViewModel
    
    var body: some View {
		#warning(
			"""
				TODO: 
					Coordinator navigation path is internal now.
					Needs to make path private. 
					Because we injecting Coordinator into Views.
					Any view can change Coordinator navigation path.
					It's not safe.
					SOLID intruder.
			"""
		)
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .tabView)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                    coordinator.build(fullScreenCover: fullScreenCover)
                }
        }
		.navigationBarBackButtonHidden()
		.task(priority: .high) {
			guard
				coordinator.dependencies.appManager.stationList == nil
			else { return }
			coordinator.dependencies.appManager.stationList = await viewModel
				.fetchAllStations()
		}
    }
}

// MARK: - CoordinatorView Extensions
// MARK: Internal DI Init
extension CoordinatorView {
    init() {
        let appManager = AppManager()
        let storiesManager: StoriesManager
        let travelManager = TravelRoutingManager()
		let dataCoordinator = DataCoordinator()
        
        switch appManager.appState {
        case .stage:
            storiesManager = StoriesManager(stories: mockStories)
        case .prod:
            storiesManager = StoriesManager()
        }
        
        let dependencies = AppDependencies(
            appManager: appManager,
            storiesManager: storiesManager,
            travelManager: travelManager,
			dataCoordinator: dataCoordinator
        )
	
        _coordinator = StateObject(
            wrappedValue: Coordinator(dependencies: dependencies)
        )
		
		_viewModel = State(
			initialValue: CoordinatorViewViewModel(
				dataCoordinator: dependencies.dataCoordinator
			)
		)
    }
}

#Preview {
    CoordinatorView()
}
