final actor NearestStationsService: NearestStationsServiceProtocol {
	
	// --- private constants ---
	private let client: Client
	private let apiKey: String
	
	// --- internal init ---
	init(client: Client, apiKey: String) {
		self.client = client
		self.apiKey = apiKey
	}
	
	// --- internal methods ---
    func getNearestStations(
        lat: Double,
        lng: Double,
        distance: Int
    ) async throws -> NearestStations {
        let response = try await client.getNearestStations(query: .init(
                apikey: apiKey,
                lat: lat,
                lng: lng,
                distance: distance
            )
        )
        
        return try response.ok.body.json
    }
}
