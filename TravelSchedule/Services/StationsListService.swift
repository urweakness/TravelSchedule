import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations(format: Format) async throws -> HTTPBody
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getAllStations(format: Format = .json) async throws -> HTTPBody {
        let response = try await client.getAllStations(
            query: .init(
                apikey: apiKey,
                format: format
            )
        )
        
        let httpBody = try response.ok.body.text_html_charset_utf_hyphen_8
        
//        var answer: AllStationsResponse?
        
        switch format {
        case .json:
            // TODO: - implement json parsing
            break
//            let mapSequence = httpBody.asDecodedJSONLines(of: AllStationsResponse.self)
//            
//            for try await stationResponse in mapSequence {
//                answer = stationResponse
//            }
        case .xml:
            // TODO: - implement xml parsing
            break
//            let serializationSquence = httpBody.asDecodedServerSentEvents()
//            
//            for try await event in serializationSquence {
//                guard
//                    let stringData = event.data,
//                    let data = stringData.data(using: .utf8)
//                else {
//                    continue
//                }
//                let xmlParser = XMLParser(data: data)
//                xmlParser.parse()
//                xmlParser.
//            }
        }
        
        return httpBody
    }
}
