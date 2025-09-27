final class CarrierService: CarrierServiceProtocol {
	
	// MARK: - Private Constants
    private let client: Client
    private let apiKey: String
    
	// MARK: - Internal Init
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
	// MARK: - Internal Methods
    func getCarrierInfo(code: String, system: CodingSystem) async throws -> JsonPayload {
        let response = try await client.getCarrierInfo(
            query: .init(
                apikey: apiKey,
                code: code,
                system: system
            )
        )
        
        return try response.ok.body.json
    }
}
