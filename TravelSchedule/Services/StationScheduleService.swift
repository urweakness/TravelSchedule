import Foundation

final actor StationScheduleService: StationScheduleServiceProtocol {
	
	// --- private constants ---
	private let client: Client
	private let apiKey: String
	
	// --- internal init ---
	init(client: Client, apiKey: String) {
		self.client = client
		self.apiKey = apiKey
	}
	
	// --- internal methods ---
	func getStationSchedule(station: String) async throws -> Result<ScheduleResponse, ErrorKind> {
        let response = try await client.getStationSchedule(
			query: .init(
				apikey: apiKey,
				station: station
			)
		)
		
		switch response {
		case .ok(let body):
			return .success(try body.body.json)
			
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
