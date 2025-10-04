final actor CopyrightService: CopyrightServiceProtocol {
	
	// --- private constants ---
	private let client: Client
	private let apiKey: String
	
	// --- internal init ---
	init(client: Client, apiKey: String) {
		self.client = client
		self.apiKey = apiKey
	}
	
	// --- internal methods ---
    func getCopyright() async throws -> CopyrightResponse {
        let response = try await client.getCopyright(
            query: .init(
				apikey: apiKey,
				format: .json
			)
        )

        return try response.ok.body.json
    }
}
