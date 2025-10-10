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
	
	// --- private constants ---
	private let parser = TravelPointParser()

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
	
	private var targetTownName: String? {
		if let isDestination = routingManager.isDestination {
			isDestination ? routingManager.destinationTown?.name : routingManager.startTown?.name
		} else {
			"NIL"
		}
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
		let clearText = searchText.trimmingCharacters(
			in: .whitespacesAndNewlines
		).lowercased()
		
		return clearText.isEmpty ? Array(travelPoints) : travelPoints.filter {
			$0.name.lowercased().contains(clearText)
		}
	}

	func parseTravelPoints() {
		var points: [D]?
		
		switch D.self {
		case is Town.Type:
			points = parser.parseTowns(
				countries: appManager.stationList?.countries
			) as? [D]
		case is Station.Type:
			points = parser.parseStations(
				countries: appManager.stationList?.countries,
				targetTownName: targetTownName
			) as? [D]
		default:
			break
		}
		
		travelPoints = points ?? []
		filteredObjects = travelPoints
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
