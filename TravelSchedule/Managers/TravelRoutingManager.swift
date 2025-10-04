import SwiftUI

final class TravelRoutingManager: ObservableObject {
    @Published var destinationTown: Town?
    @Published var destinationStation: Station?
    
    @Published var startTown: Town?
    @Published var startStation: Station?
    
    @Published var isDestination: Bool?
    
    @Published var choosedCarrier: String?
    
    @Published var filter: FilterModel?
    
    @inlinable
    var travelPointsFilled: Bool {
        startTown != nil && startStation != nil &&
        destinationTown != nil && destinationStation != nil
    }
    
    @inlinable
    func swapDestinations() {
        (destinationTown, startTown) = (startTown, destinationTown)
        (destinationStation, startStation) = (startStation, destinationStation)
    }
    
    @inlinable
    var title: String {
        "\(startTown?.name ?? "")(\(startStation?.name ?? "")) → \(destinationTown?.name ?? "")(\(destinationStation?.name ?? ""))"
    }
}
