import SwiftUI

@MainActor
@Observable
final class Coordinator: ObservableObject {
    var path = NavigationPath()
    var selectedTab: Int = 0
	var fullScreenCover: FullScreenCover?
	private(set) var navigationTitle = ""
    private(set) var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
    
    let dependencies: AppDependencies
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
	
	func navigationPath(_ block: @Sendable (NavigationPath) -> Void) {
		block(path)
	}
	
	func setNavPath(_ path: NavigationPath) {
		self.path = path
	}
}

// MARK: - Coordinator Extensions

// MARK: Internal Builders
extension Coordinator {
    @ViewBuilder @preconcurrency
    func build(page: Page) -> some View {
        switch page {
        case .tabView:
            TravelTabView(coordinator: self)
            
        case .main:
            MainView(
				manager: dependencies.travelManager,
				coordinator: self
			)
            
        case .routing:
            RoutingView(
				manager: dependencies.travelManager,
				push: push
			)
        
        case .settings:
			SettingsView(push: push)
            
        case .storiesPreview:
			StoriesPreviewView(
				manager: dependencies.storiesManager,
				present: present
			)
        
        case .townChoose:
            TravelPointChooseView<Town>(
				manager: dependencies.travelManager,
				push: push,
				pop: pop,
				popToRoot: popToRoot,
				navigationTitle: navigationTitle,
				navigationTitleDisplayMode: navigationTitleDisplayMode
			)
            
        case .stationChoose:
            TravelPointChooseView<Station>(
				manager: dependencies.travelManager,
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
				manager: dependencies.travelManager,
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
            
        case .error(let errorKind):
            ErrorView(kind: errorKind)
            
        default:
            EmptyView()
        }
    }
}

// MARK: Internal Presentation
extension Coordinator {
    @preconcurrency
    func push(page: Page) {
		navigationTitle = page.navigationTitle
		navigationTitleDisplayMode = page.navigationTitleDisplayMode
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
        path.removeLast()
    }
    
    @preconcurrency
    func popToRoot() {
        path.removeLast(path.count)
    }
}

