final actor ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {
	
	// --- private constants ---
	private let client: Client
	private let apiKey: String
	
	// --- internal init ---
	init(client: Client, apiKey: String) {
		self.client = client
		self.apiKey = apiKey
	}
	
	// --- internal methods ---
    func search(
        from: String,
        to: String
	) async throws -> ScheduleBetweenStationsResponse {
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apiKey,
            from: from,
            to: to
        ))
        
		return try response.ok.body.json
    }
}
