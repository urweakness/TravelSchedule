import SwiftUI

final class TravelRoutingViewModel: ObservableObject {
    @Published var destinationTown: Town?
    @Published var destinationStation: Station?
    
    @Published var startTown: Town?
    @Published var startStation: Station?
    
    @Published var isDestination: Bool?
    
    @Published var choosedCarrier: String?
    
    @Published var filter: FilterModel?
    
    var travelPointsFilled: Bool {
        startTown != nil && startStation != nil &&
        destinationTown != nil && destinationStation != nil
    }
    
    func swapDestinations() {
        (destinationTown, startTown) = (startTown, destinationTown)
        (destinationStation, startStation) = (startStation, destinationStation)
    }
    
    var title: String {
        "\(startTown?.name ?? "")(\(startStation?.name ?? "")) → \(destinationTown?.name ?? "")(\(destinationStation?.name ?? ""))"
    }
}
