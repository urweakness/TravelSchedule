import SwiftUI

struct TravelPointChooseView<D: TravelPoint>: View {
	
    // MARK: - State Private Properties
    @StateObject private var viewModel = TravelPointChooseViewModel<D>()
    
	// MARK: - DI States
    @ObservedObject var manager: TravelRoutingManager
    @EnvironmentObject private var coordinator: Coordinator
    
    // MARK: - Private Constants
    private let networkServicesManager = ServicesManager.shared
    
    // MARK: - Body
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
		.navigationTitle(coordinator.navigationTitle)
		.navigationBarTitleDisplayMode(coordinator.navigationTitleDisplayMode)
        .background(.travelWhite)
        .customNavigationBackButton()
        .animation(.bouncy, value: viewModel.filteredObjects)
    }
    
    // MARK: - Private Properties
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
                            coordinator.push(page: .stationChoose)
                        } else if let station = destination as? Station {
                            if isDestination {
                                manager.destinationStation = station
                            } else {
                                manager.startStation = station
                            }
                            coordinator.popToRoot()
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
