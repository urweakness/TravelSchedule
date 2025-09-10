import SwiftUI

#Preview {
    TravelPointChooseView<Town>()
        .environmentObject(Coordinator())
        .environmentObject(TravelRoutingViewModel())
}

struct TravelPointChooseView<D: TravelPoint>: View {
    // MARK: - State Private Properties
    @StateObject private var viewModel = TravelPointChooseViewModel<D>()
    
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var travelRoutingViewModel: TravelRoutingViewModel
    
    // MARK: - Private Constants
    private let manager = ServicesManager.shared
    
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
        .navigationTitle(D.navigationTitleText)
        .navigationBarTitleDisplayMode(.inline)
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
                        guard let isDestination = travelRoutingViewModel.isDestination else { return }
                        if let town = destination as? Town {
                            if isDestination  {
                                travelRoutingViewModel.destinationTown = town
                            } else {
                                travelRoutingViewModel.startTown = town
                            }
                            coordinator.push(page: .stationChoose)
                        } else if let station = destination as? Station {
                            if isDestination {
                                travelRoutingViewModel.destinationStation = station
                            } else {
                                travelRoutingViewModel.startStation = station
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
