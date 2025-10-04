import SwiftUI

@MainActor
@Observable
final class TravelRoutingManager {
    var destinationTown: Town?
	var destinationStation: Station?
    
    var startTown: Town?
    var startStation: Station?
    
    var isDestination: Bool?
    
    var choosedCarrier: String?
    
    var filter: FilterModel?
    
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
