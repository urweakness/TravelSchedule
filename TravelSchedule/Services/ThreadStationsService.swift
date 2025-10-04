final actor ThreadStationsService: ThreadStationsServiceProtocol {
	
	// --- private constants ---
	private let client: Client
	private let apiKey: String
	
	// --- internal init ---
	init(client: Client, apiKey: String) {
		self.client = client
		self.apiKey = apiKey
	}
	
	// --- internal methods ---
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
