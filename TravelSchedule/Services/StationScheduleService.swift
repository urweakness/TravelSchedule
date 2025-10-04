final actor StationScheduleService: StationScheduleServiceProtocol {
	
	// --- private constants ---
	private let client: Client
	private let apiKey: String
	
	// --- internal init ---
	init(client: Client, apiKey: String) {
		self.client = client
		self.apiKey = apiKey
	}
	
	// --- internal methods ---
    func getStationSchedule(station: String) async throws -> ScheduleResponse {
        let response = try await client.getStationSchedule(
			query: .init(
				apikey: apiKey,
				station: station
			)
		)
        
        return try response.ok.body.json
    }
}
