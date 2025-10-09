import Foundation

final actor NearestSettlementService: NearestSettlementServiceProtocol {
	
	// --- private constants ---
	private let client: Client
	private let apiKey: String
	
	// --- internal init ---
	init(client: Client, apiKey: String) {
		self.client = client
		self.apiKey = apiKey
	}
	
	// --- internal methods ---
    func getNearestCity(
        lat: Double,
        lng: Double
	) async throws -> Result<NearestCityResponse, ErrorKind> {
        let response = try await client.getNearestCity(
            query: .init(
                apikey: apiKey,
                lat: lat,
                lng: lng
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
