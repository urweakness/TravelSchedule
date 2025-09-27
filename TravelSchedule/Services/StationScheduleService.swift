final class StationScheduleService: StationScheduleServiceProtocol {
	
	// MARK: - Private Constants
    private let client: Client
    private let apiKey: String
    
	// MARK: - Internal Init
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
	// MARK: - Internal Methods
    func getStationSchedule(station: String) async throws -> ScheduleResponse {
        let response = try await client.getStationSchedule(query: .init(apikey: apiKey, station: station))
        
        return try response.ok.body.json
    }
}
