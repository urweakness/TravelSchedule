import SwiftUI

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: Int = 0
    @Published var fullScreenCover: FullScreenCover?
	@Published private(set) var navigationTitle = ""
    @Published private(set) var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
    
    private let dependencies: AppDependencies
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - Coordinator Extensions

// MARK: Internal Builders
extension Coordinator {
    @ViewBuilder @preconcurrency
    func build(page: Page) -> some View {
        switch page {
        case .tabView:
            TravelTabView()
            
        case .main:
            MainView(manager: dependencies.travelManager)
            
        case .routing:
            RoutingView(manager: dependencies.travelManager)
        
        case .settings:
            SettingsView()
            
        case .storiesPreview:
            StoriesPreviewView()
				.environment(dependencies.storiesManager)
        
        case .townChoose:
            TravelPointChooseView<Town>(manager: dependencies.travelManager)
            
        case .stationChoose:
            TravelPointChooseView<Station>(manager: dependencies.travelManager)
            
        case .userAgreement:
            UserAgreementView()
            
        case .carriersChoose:
            CarriersListView(manager: dependencies.travelManager)
            
        case .filtration:
            FiltrationView(manager: dependencies.travelManager)
            
        case .carrierInfo:
            CarrierInfoView(manager: dependencies.travelManager)
		
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder @preconcurrency
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .story:
            FullScreenStoriesView()
				.environment(dependencies.storiesManager)
            
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

