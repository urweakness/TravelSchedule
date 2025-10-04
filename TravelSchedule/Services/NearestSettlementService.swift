final class NearestSettlementService: NearestSettlementServiceProtocol {
	
	// MARK: - Private Constants
    private let client: Client
    private let apiKey: String
    
	// MARK: - Internal Init
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
	// MARK: - Internal Methods
    func getNearestCity(
        lat: Double,
        lng: Double
    ) async throws -> NearestCityResponse {
        let response = try await client.getNearestCity(
            query: .init(
                apikey: apiKey,
                lat: lat,
                lng: lng
            )
        )
        
        return try response.ok.body.json
    }
}
