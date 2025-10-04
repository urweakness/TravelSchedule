import SwiftUI

struct CoordinatorView: View {
	
	// MARK: - Private States
    @StateObject private var coordinator: Coordinator
    
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
    }
}

// MARK: - CoordinatorView Extensions
// MARK: Internal DI Init
extension CoordinatorView {
    init() {
        let appManager = AppManager()
        let storiesManager: StoriesManager
        let travelManager = TravelRoutingManager()
        
        switch appManager.appState {
        case .stage:
            storiesManager = StoriesManager(stories: mockStories)
        case .prod:
            storiesManager = StoriesManager()
        }
        
        let dependencies = AppDependencies(
            appManager: appManager,
            storiesManager: storiesManager,
            travelManager: travelManager
        )
	
        _coordinator = StateObject(
            wrappedValue: Coordinator(dependencies: dependencies)
        )
    }
}

#Preview {
    CoordinatorView()
}
