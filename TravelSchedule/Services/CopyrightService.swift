final class CopyrightService: CopyrightServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getCopyright() async throws -> CopyrightResponse {
        let response = try await client.getCopyright(
            query: .init(apikey: apiKey, format: .json)
        )

        return try response.ok.body.json
    }
}
