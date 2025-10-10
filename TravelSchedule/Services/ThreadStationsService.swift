import Foundation

final actor ThreadStationsService: ThreadStationsServiceProtocol {
	
	// --- private constants ---
	private let client: Client
	private let apiKey: String
	
	// --- internal init ---
	init(client: Client, apiKey: String) {
		self.client = client
		self.apiKey = apiKey
	}
	
	// --- internal methods ---
	func getThreadStations(uid: String) async throws -> Result<ThreadStationsResponse, ErrorKind> {
        let response = try await client.getRouteStations(
            query: .init(
                apikey: apiKey,
                uid: uid
            )
        )
        
		switch response {
		case .ok(let json):
			return .success(try json.body.json)
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
