import Foundation

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
	) async throws -> Result<CarrierJsonPayload, ErrorKind> {
        let response = try await client.getCarrierInfo(
            query: .init(
                apikey: apiKey,
                code: code,
                system: system
            )
        )
        
		switch response {
		case .ok(let content):
			return .success(try content.body.json)
		case .undocumented(let statusCode, let description):
			switch statusCode {
			case 400...499:
				return .failure(.noInternet)
			case 500...599:
				return .failure(.serverError)
			default:
				return .failure(
					.unknown(
						NSError(
							domain: "StationListService",
							code: 0,
							userInfo: ["description": description])
					)
				)
			}
			
		@unknown default:
			throw URLError(.badServerResponse)
		}
    }
}
