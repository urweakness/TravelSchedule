@MainActor
@Observable
final class TravelTabViewModel {
	
	private let dataCoordinator: DataCoordinator
	init(dataCoordinator: DataCoordinator) {
		self.dataCoordinator = dataCoordinator
	}
	
	func fetchAllStations() async -> AllStationsResponse? {
		do {
			return try await dataCoordinator.getStationsList()
		} catch {
			print("Cant fetch stations --> \(error)")
		}
		
		return nil
	}
}