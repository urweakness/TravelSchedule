import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierResponse = Components.Schemas.CarrierResponse
typealias CodingSystem = Components.Schemas.CodingSystem
typealias JsonPayload = Operations.getCarrierInfo.Output.Ok.Body.jsonPayload

protocol CarrierServiceProtocol {
    func getCarrierInfo(
        code: String,
        system: CodingSystem
    ) async throws -> JsonPayload
}

final class CarrierService: CarrierServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
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
