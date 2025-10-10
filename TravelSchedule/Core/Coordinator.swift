import SwiftUI

@MainActor
@Observable
final class Coordinator: ObservableObject {
    var path = NavigationPath()
	var fullScreenCover: FullScreenCover?
	private(set) var navigationTitle = ""
    private(set) var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
    
    let dependencies: AppDependencies
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
	
	private func setNavigation(for page: Page) {
		navigationTitle = page.navigationTitle
		navigationTitleDisplayMode = page.navigationTitleDisplayMode
	}
}

// MARK: - Coordinator Extensions

// MARK: Internal Builders
extension Coordinator {
	
	// --- private builder helpers ---
	private func buildStoriesPreviewView() -> StoriesPreviewView {
		StoriesPreviewView(
			manager: dependencies.storiesManager,
			present: present
		)
	}
	
	private func buildRoutingView() -> RoutingView {
		RoutingView(
			manager: dependencies.travelManager,
			push: push
		)
	}
	
	private func buildMainView() -> MainView {
		MainView(
			manager: dependencies.travelManager,
			storiesPreviewContent: buildStoriesPreviewView,
			routingContent: buildRoutingView,
			push: push
		)
	}
	
	private func buildSettingsView() -> SettingsView {
		SettingsView(push: push)
	}
	
	// --- internal builder for CoordinatorView ---
    @ViewBuilder @preconcurrency
    func build(page: Page) -> some View {
        switch page {
			
        case .tabView:
			TravelTabView(
				manager: dependencies.appManager,
				dataCoordinator: dependencies.dataCoordinator,
				buildMainView: buildMainView,
				buildSettingsView: buildSettingsView
			)
            
        case .main:
			buildMainView()
            
        case .routing:
			buildRoutingView()
        
        case .settings:
			buildSettingsView()
            
        case .storiesPreview:
			buildStoriesPreviewView()
        
        case .townChoose:
            TravelPointChooseView<Town>(
				routingManager: dependencies.travelManager,
				appManager: dependencies.appManager,
				loadingState: dependencies.dataCoordinator.loader.loadingState,
				push: push,
				pop: pop,
				popToRoot: popToRoot,
				navigationTitle: navigationTitle,
				navigationTitleDisplayMode: navigationTitleDisplayMode
			)
            
        case .stationChoose:
            TravelPointChooseView<Station>(
				routingManager: dependencies.travelManager,
				appManager: dependencies.appManager,
				loadingState: dependencies.dataCoordinator.loader.loadingState,
				push: push,
				pop: pop,
				popToRoot: popToRoot,
				navigationTitle: navigationTitle,
				navigationTitleDisplayMode: navigationTitleDisplayMode
			)
            
        case .userAgreement:
			UserAgreementView(
				pop: pop,
				navigationTitle: navigationTitle,
				navigationTitleDisplayMode: navigationTitleDisplayMode
			)
            
        case .carriersChoose:
            CarriersListView(
				manager: dependencies.travelManager,
				dataCoordinator: dependencies.dataCoordinator,
				push: push,
				pop: pop
			)
            
        case .filtration:
            FiltrationView(
				manager: dependencies.travelManager,
				pop: pop
			)
            
        case .carrierInfo:
			CarrierInfoView(
				carrier: dependencies.travelManager.choosedCarrier,
				pop: pop,
				navigationTitle: navigationTitle,
				navigationTitleDisplayMode: navigationTitleDisplayMode
			)
		
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder @preconcurrency
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .story:
			FullScreenStoriesView(manager: dependencies.storiesManager)
			
		case .error(let kind):
			ErrorView(
				kind: kind,
				onDismiss: dismissFullScreenCover
			)
            
        default:
            EmptyView()
        }
    }
}

// MARK: Internal Presentation
extension Coordinator {
    @preconcurrency
    func push(page: Page) {
		setNavigation(for: page)
        path.append(page)
    }
    
    @preconcurrency
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
}

// MARK: Internal Dismissing
extension Coordinator {
    @preconcurrency
    func dismissFullScreenCover() {
        fullScreenCover = nil
    }
    
    @preconcurrency
	func pop() {
		#warning("TODO: cant change navigation title on pop beacuse we cant get NavigationPath elements directly")
        path.removeLast()
    }
    
    @preconcurrency
    func popToRoot() {
        path.removeLast(path.count)
    }
}

