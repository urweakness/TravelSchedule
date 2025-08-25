import OpenAPIRuntime
import OpenAPIURLSession

typealias Segments = Components.Schemas.Segments

protocol SegmentsServiceProtocol {
    func search(
        from: String,
        to: String
    ) async throws -> Segments
}

final class SegmentsService: SegmentsServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func search(
        from: String,
        to: String
    ) async throws -> Segments {
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apiKey,
            from: from,
            to: to
        ))
        
        return try response.ok.body.json
    }
}
