final actor CarrierService: CarrierServiceProtocol {
	
	// --- private constants ---
    private let client: Client
    private let apiKey: String
    
	// --- internal init ---
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
	// --- internal methods ---
    func getCarrierInfo(
		code: String,
		system: CodingSystem
	) async throws -> CarrierJsonPayload {
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
