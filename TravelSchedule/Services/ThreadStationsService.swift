final class ThreadStationsService: ThreadStationsServiceProtocol {
	
	// MARK: - Private Constants
    private let client: Client
    private let apiKey: String
    
	// MARK: - Internal Init
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
	// MARK: - Internal Methods
    func getThreadStations(uid: String) async throws -> ThreadStationsResponse {
        let response = try await client.getRouteStations(
            query: .init(
                apikey: apiKey,
                uid: uid
            )
        )
        
        return try response.ok.body.json
    }
}
