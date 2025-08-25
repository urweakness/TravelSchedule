import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations() async throws -> HTTPBody
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getAllStations() async throws -> HTTPBody {
        let response = try await client.getAllStations(query: .init(apikey: apiKey))
        
        return try response.ok.body.text_html_charset_utf_hyphen_8
    }
}
