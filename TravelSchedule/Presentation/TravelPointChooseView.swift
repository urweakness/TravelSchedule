import SwiftUI

struct TravelPointChooseView<D: TravelPoint>: View {
	
    // --- private states ---
    @StateObject private var viewModel = TravelPointChooseViewModel<D>()
    
	// --- DI ---
	@Bindable var manager: TravelRoutingManager
	let push: (Page) -> Void
	let pop: () -> Void
	let popToRoot: () -> Void
	let navigationTitle: String
	let navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode
    
    // --- private constants
    private let networkServicesManager = ServicesManager.shared
    
    // --- body ---
    @ViewBuilder
    var body: some View {
        VStack(spacing: 16) {
            searchFieldView
            
            if viewModel.filteredObjects.isEmpty {
                emptyDestinationsView
            } else {
                destinationsView
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
		.navigationTitle(navigationTitle)
		.navigationBarTitleDisplayMode(navigationTitleDisplayMode)
        .background(.travelWhite)
		.customNavigationBackButton(pop: pop)
        .animation(.bouncy, value: viewModel.filteredObjects)
    }
    
    // --- private subviews ---
    private var emptyDestinationsView: some View {
        GeometryReader {
            Text(D.noContentTitleText)
                .font(.bold24)
                .transition(.blurReplace)
                .frame(width: $0.size.width, height: $0.size.height)
        }
    }

    private var destinationsView: some View {
        VStack {
            ForEach(viewModel.filteredObjects) { destination in
                TravelListCell(
                    text: destination.name,
                    buttonAction: {
                        guard let isDestination = manager.isDestination else { return }
                        if let town = destination as? Town {
                            if isDestination  {
                                manager.destinationTown = town
                            } else {
                                manager.startTown = town
                            }
                            push(.stationChoose)
                        } else if let station = destination as? Station {
                            if isDestination {
                                manager.destinationStation = station
                            } else {
                                manager.startStation = station
                            }
                            popToRoot()
                        }
                    }, rightView: {
                        Image(systemName: "chevron.right")
                            .font(.bold17)
                    })
            }
        }
        .transition(.blurReplace)
    }
    
    private var searchFieldView: some View {
        TextField("Введите запрос", text: $viewModel.searchText)
            .textFieldStyle(SearchTextFieldStyle(text: $viewModel.searchText))
    }
}
