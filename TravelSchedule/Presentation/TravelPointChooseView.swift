import SwiftUI

#Preview {
    TravelPointChooseView(travelPoints: Town.allCases)
        .environmentObject(Coordinator())
        .environmentObject(TravelRoutingViewModel())
}

struct TravelPointChooseView<D: TravelPoint>: View {
    
    // MARK: - Internal Constants
    let travelPoints: [D]
    
    // MARK: - State Private Properties
    @State private var filteredDestinations = [D]()
    @State private var searchText: String = ""
    
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var travelRoutingViewModel: TravelRoutingViewModel
    
    // MARK: - Private Constants
    private let manager = ServicesManager.shared
    
    // MARK: - Body
    @ViewBuilder
    var body: some View {
        VStack(spacing: 16) {
            searchFieldView
            
            if filteredDestinations.isEmpty {
                emptyDestinationsView
            } else {
                destinationsView
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle(D.navigationTitleText)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: setFilter)
        .background(.travelWhite)
        .customNavigationBackButton()
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
            ForEach(filteredDestinations) { destination in
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
        TextField("Введите запрос", text: $searchText)
            .textFieldStyle(SearchTextFieldStyle(text: $searchText))
            .onChange(of: searchText) {
                setFilter()
            }
    }
    
    // MARK: - Private Methods
    private func setFilter() {
        withAnimation(.easeInOut(duration: 0.15)) {
            if searchText.isEmpty {
                filteredDestinations = travelPoints
            } else {
                filteredDestinations = travelPoints.filter {
                    $0.name
                        .lowercased()
                        .contains(searchText.lowercased())
                }
            }
        }
    }
}
