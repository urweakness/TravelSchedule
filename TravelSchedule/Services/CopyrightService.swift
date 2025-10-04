final class CopyrightService: CopyrightServiceProtocol {
	
	// MARK: - Private Constants
    private let client: Client
    private let apiKey: String
    
	// MARK: - Internal Init
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
	// MARK: - Internal Methods
    func getCopyright() async throws -> CopyrightResponse {
        let response = try await client.getCopyright(
            query: .init(apikey: apiKey, format: .json)
        )

        return try response.ok.body.json
    }
}
