import SwiftUI

enum Page: Identifiable, Hashable {
    case none
    case main
    case townChoose
    case stationChoose
    case userAgreement
    case transportersChoose
    
    var id: Self { self }
}

enum Sheet: Identifiable, Hashable {
    case none
    
    var id: Self { self }
}

enum FullScreenCover: Identifiable, Hashable {
    case none
    
    var id: Self { self }
}



final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: Int = 0
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    @Published var navigationTitle = ""
    @Published var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
    
    @Published var destinationTown: Town?
    @Published var destinationStation: Station?
    
    @Published var startTown: Town?
    @Published var startStation: Station?
    
    @Published var isDestination: Bool?
    
    var travelPointsFilled: Bool {
        startTown != nil && startStation != nil &&
        destinationTown != nil && destinationStation != nil
    }
}

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
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder @preconcurrency
    func build(sheet: Sheet) -> some View {
        switch sheet {
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder @preconcurrency
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        default:
            EmptyView()
        }
    }
}

extension Coordinator {
    @preconcurrency
    func push(page: Page) {
        path.append(page)
    }
    
    @preconcurrency
    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    @preconcurrency
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
}

extension Coordinator {
    @preconcurrency
    func dismissSheet() {
        sheet = nil
    }
    
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


struct CoordinatorView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            NavigationStack(path: $coordinator.path) {
                coordinator.build(page: .main)
                    .navigationDestination(for: Page.self) { page in
                        coordinator.build(page: page)
                    }
                    .sheet(item: $coordinator.sheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
                    .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                        coordinator.build(fullScreenCover: fullScreenCover)
                    }
            }
            .navigationTitle(coordinator.navigationTitle)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(coordinator.navigationTitleDisplayMode)
        }
    }
}
