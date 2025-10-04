final class ScheduleBetweenStationsService: SegmentsServiceProtocol {
	
	// MARK: - Private Constants
    private let client: Client
    private let apiKey: String
    
	// MARK: - Interanl Init
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
	// MARK: - Internal Methods
    func search(
        from: String,
        to: String
    ) async throws -> Segments {
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apiKey,
            from: from,
            to: to
        ))
        
        return try response.ok.body.json
    }
}
