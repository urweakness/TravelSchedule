protocol NearestStationsServiceProtocol {
    func getNearestStations(
        lat: Double,
        lng: Double,
        distance: Int
	) async throws -> Result<NearestStations, ErrorKind>
}
