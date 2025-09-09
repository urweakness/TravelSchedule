final class ThreadStationsService: ThreadStationsServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
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
