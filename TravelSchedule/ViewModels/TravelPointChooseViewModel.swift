import Combine
import SwiftUI

@MainActor
final class TravelPointChooseViewModel<D: TravelPoint>: ObservableObject {

	// --- publishers ---
	// init filteredObject with all points (to avoid initial debounce delay)
    @Published private(set) var filteredObjects = [D]()
    @Published var searchText: String = ""
	
	@Published private var appManager: AppManager
	@Bindable private var routingManager: TravelRoutingManager
	private let push: (Page) -> Void
	private let popToRoot: () -> Void

	// --- private properties ---
	private var travelPoints = [D]()
    private var cancellables = Set<AnyCancellable>()

	init(
		appManager: AppManager,
		routingManager: TravelRoutingManager,
		push: @escaping (Page) -> Void,
		popToRoot: @escaping () -> Void
	) {
		// if search is empty -> showing all points
		self.appManager = appManager
		self.routingManager = routingManager
		self.push = push
		self.popToRoot = popToRoot
		
		parseTravelPoints()
        setupBindings()
    }

	// --- private methods ---
    private func setupBindings() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { [weak self] searchText -> [D] in
                guard let self else { return [] }
                return parseObjects(for: searchText)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.filteredObjects, on: self)
            .store(in: &cancellables)
    }

    private func parseObjects(for searchText: String) -> [D] {
        let clearText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if clearText.isEmpty {
            return Array(self.travelPoints)
        } else {
            return self.travelPoints.filter {
                $0.name.lowercased().contains(clearText)
            }
        }
    }

	func parseTravelPoints() {
		var points: [D]?
		
		switch D.self {
		case is Town.Type:
			points = parseTowns() as? [D]
		case is Station.Type:
			points = parseStations() as? [D]
		default:
			break
		}
		
		travelPoints = points ?? []
		filteredObjects = travelPoints
	}
	
	private func parseTowns() -> [Town] {

		guard
			let countries = appManager.stationList?.countries
		else { return [] }
		
		var result = [Town]()
		
		let country = countries.first(where: { $0.title == "Россия" })
		guard let regions = country?.regions else { return [] }
		
		for region in regions {
			guard let settlements = region.settlements else { continue }
			
			for settlement in settlements {
				guard
					let title = settlement.title,
					let code = settlement.codes?.yandex_code
				else { continue }
				result.append(
					Town(
						name: title,
						code: code
					)
				)
			}
		}
		
		return result
	}
	
	private func parseStations() -> [Station] {
		var result = [Station]()
		
		guard
			let isDestination = routingManager.isDestination
		else {
			return []
		}
		
		var targetTownName: String?
		if isDestination {
			targetTownName = routingManager.destinationTown?.name
		} else {
			targetTownName = routingManager.startTown?.name
		}
		
		guard let countries = appManager.stationList?.countries else { return [] }
		for country in countries {
			
			for region in country.regions ?? [] {
				
				for settlement in region.settlements ?? [] {
					guard
						settlement.title == targetTownName
					else { continue }
					
					for station in settlement.stations ?? [] {
						
						guard
							let title = station.title
						else { continue }
						
						result.append(
							Station(
								name: title,
								esrCode: station.codes?.esr_code,
								yandexCode: station.codes?.yandex_code
							)
						)
					}
				}
			}
		}
		
		return result
	}
	
	// --- internal methods ---
	func didTapOnObject(destination: D) {
		guard let isDestination = routingManager.isDestination else { return }
		if let town = destination as? Town {
			if isDestination  {
				routingManager.destinationTown = town
			} else {
				routingManager.startTown = town
			}
			push(.stationChoose)
		} else if let station = destination as? Station {
			if isDestination {
				routingManager.destinationStation = station
			} else {
				routingManager.startStation = station
			}
			popToRoot()
		}
	}
	
}
