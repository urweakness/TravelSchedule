import SwiftUI

struct CoordinatorView: View {
	
	// MARK: - Private States
    @StateObject private var coordinator: Coordinator
	@State private var error: ErrorKind? {
		didSet {
			switch error {
			case nil:
				break
			default:
				if let error {
					coordinator.present(fullScreenCover: .error(error))
				}
			}
		}
	}
    
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
		
		.animation(.default, value: error)
		.onChange(of: coordinator.dependencies.dataCoordinator.loader.loadingState) { _, newValue in
			switch newValue {
			case .error(let newError):
				error = newError
			default:
				error = nil
			}
		}
		.onChange(of: coordinator.dependencies.connectionMonitor.isConnected) { _, newValue in
			error = newValue ? nil : .noInternet
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
		let connectionMonitor = ConnectionMonitor()
        
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
			dataCoordinator: dataCoordinator,
			connectionMonitor: connectionMonitor
        )
	
        _coordinator = StateObject(
            wrappedValue: Coordinator(dependencies: dependencies)
        )
    }
}

#if DEBUG
#Preview {
    CoordinatorView()
}
#endif
