import Foundation

final actor ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {
	
	// --- private constants ---
	private let client: Client
	private let apiKey: String
	
	// --- internal init ---
	init(client: Client, apiKey: String) {
		self.client = client
		self.apiKey = apiKey
	}
	
	// --- internal methods ---
    func search(
        from: String,
        to: String
	) async throws -> Result<ScheduleBetweenStationsResponse, ErrorKind> {
		let response = try await client.getScheduleBetweenStations(query: .init(
			apikey: apiKey,
			from: from,
			to: to,
			transfers: true
		))
		
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
