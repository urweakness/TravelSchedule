import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations() async throws -> AllStationsResponse
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getAllStations() async throws -> AllStationsResponse {
        let response = try await client.getAllStations(
            query: .init(
                apikey: apiKey
            )
        )
        
        switch response {
        case .ok(let ok):
            
            switch ok.body {
            case .json(let payload):
                
                return payload
                
            case .html(let body):
                
                var data = Data()
                for try await chunk in body {
                    data.append(contentsOf: chunk)
                }
                
                return try JSONDecoder().decode(AllStationsResponse.self, from: data)
                
            }
            
        default:
            throw URLError(.badServerResponse)
        }
    }
}
