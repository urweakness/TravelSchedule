import SwiftUI

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: Int = 0
    @Published var fullScreenCover: FullScreenCover?
    @Published var navigationTitle = ""
    @Published var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
}

// MARK: - Coordinator Extensions
// MARK: Builders
extension Coordinator {
    @ViewBuilder @preconcurrency
    func build(page: Page) -> some View {
        switch page {
        case .main:
            TravelTabView()
            
        case .townChoose:
            TravelPointChooseView(
                travelPoints: Town.allCases
            )
            
        case .stationChoose:
            TravelPointChooseView(
                travelPoints: Station.allCases
            )
            
        case .userAgreement:
            UserAgreementView()
            
        case .carriersChoose:
            CarriersListView()
            
        case .filtration:
            FiltrationView()
            
        case .carrierInfo:
            CarrierInfoView()
            
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder @preconcurrency
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .story:
            StoryView()
            
        case .error(let errorKind):
            ErrorView(kind: errorKind)
            
        default:
            EmptyView()
        }
    }
}

// MARK: Presentation
extension Coordinator {
    @preconcurrency
    func push(page: Page) {
        path.append(page)
    }
    
    @preconcurrency
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
}

// MARK: Dismissing
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

