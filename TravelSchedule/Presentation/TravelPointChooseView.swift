import SwiftUI

struct TravelPointChooseView<D: TravelPoint>: View {
    
    let travelPoints: [D]
    @State private var filteredDestinations = [D]()
    @State private var searchText: String = ""
    
    @EnvironmentObject private var coordinator: Coordinator
    
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
    
    private var emptyDestinationsView: some View {
        GeometryReader {
            Text(D.noContentTitleText)
                .font(.bold24)
                .transition(.blurReplace)
                .frame(height: $0.size.height)
        }
//        VStack {
//            Spacer()
//            Text(D.noContentTitleText)
//                .font(.bold24)
//                .transition(.blurReplace)
//            Spacer()
//        }
    }

    private var destinationsView: some View {
        VStack {
            ForEach(filteredDestinations) { destination in
                TravelListCell(
                    text: destination.name,
                    buttonAction: {
                        guard let isDestination = coordinator.isDestination else { return }
                        if let town = destination as? Town {
                            if isDestination  {
                                coordinator.destinationTown = town
                            } else {
                                coordinator.startTown = town
                            }
                            coordinator.push(page: .stationChoose)
                        } else if let station = destination as? Station {
                            if isDestination {
                                coordinator.destinationStation = station
                            } else {
                                coordinator.startStation = station
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
        TextField("Веедите запрос", text: $searchText)
            .textFieldStyle(SearchTextFieldStyle(text: $searchText))
            .onChange(of: searchText) {
                setFilter()
            }
    }
    
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
