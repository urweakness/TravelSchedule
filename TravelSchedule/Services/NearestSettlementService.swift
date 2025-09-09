final class NearestSettlementService: NearestSettlementServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
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
