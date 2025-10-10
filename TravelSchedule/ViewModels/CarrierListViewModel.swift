import Observation
import Foundation

@MainActor
@Observable
final class CarrierListViewModel {
	
	// --- internal ---
	let manager: TravelRoutingManager
	
	// --- private(set) properties ---
	private(set) var filteredCarriers = [CarrierModel]()
	private(set) var carriers = [CarrierModel]()
	
	// --- private constants ---
	private let dataCoordinator: DataCoordinator
	private let pushCarrier: () -> Void
	
	private let parser = CarrierParser()
	private let filterApplier = CarrierFilterApplier()
	
	// --- internal computed properties ---
	var title: String {
		manager.title
	}
	
	// --- internal init ---
	init(
		manager: TravelRoutingManager,
		dataCoordinator: DataCoordinator,
		pushCarrier: @escaping () -> Void
	) {
		self.manager = manager
		self.dataCoordinator = dataCoordinator
		self.pushCarrier = pushCarrier
	}
	
	// --- updating filtered carriers using filter ---
	func updateCarriers() {
		var _carriers = [CarrierModel]()
		carriers.forEach {
			if
				let carrier = filterApplier.applyFilterToCarrierModel(
					$0,
					filter: manager.filter
				)
			{
				_carriers.append(carrier)
			}
		}
		
		mutateFilteredCarriers { [_carriers] _ in
			_carriers
		}
	}
	
	// --- on tap concrete carrier handler ---
	func didTap(_ carrier: CarrierModel) {
		manager.choosedCarrier = carrier
		pushCarrier()
	}
	
	// --- async task fetch result parsing ---
	func parseResponse(_ response: ScheduleBetweenStationsResponse) {
		let carriers = parser.parseResponse(response)
		mutateCarriers { _ in
			carriers
		}
	}
	
	// --- async task fetch ---
	func fetchScheduleBetweenStations() async -> ScheduleBetweenStationsResponse? {
		guard
			let fromCode = manager.startStation?.yandexCode,
			let toCode = manager.destinationStation?.yandexCode
		else { return nil }

		async let asyncResponse = dataCoordinator.getScheduleBetweenStations(
			from: fromCode,
			to: toCode
		)
		
		do {
			return try await asyncResponse
		} catch {
			print("\n\(#function) An error occurred --> \(error)\n")
			return nil
		}
	}
}

// MARK: - CarrierListViewModel Extensions

// --- private safe exec context mutating ---
private extension CarrierListViewModel {
	private func mutateCarriers(_ block: @escaping @Sendable ([CarrierModel]) -> [CarrierModel]) {
		let prevCarriers = self.carriers
		let updatedCarriers = block(prevCarriers)
		self.carriers = updatedCarriers
	}
	
	private func mutateFilteredCarriers(_ block: @escaping @Sendable ([CarrierModel]) -> [CarrierModel]) {
		let prevCarriers = self.filteredCarriers
		let updatedCarriers = block(prevCarriers)
		self.filteredCarriers = updatedCarriers
	}
}
