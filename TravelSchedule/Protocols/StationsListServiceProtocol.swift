protocol StationsListServiceProtocol {
	func getAllStations() async throws -> Result<AllStationsResponse, ErrorKind>
}
