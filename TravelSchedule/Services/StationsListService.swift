import Foundation

final actor StationsListService: StationsListServiceProtocol {
	
	// --- private constants ---
	private let client: Client
	private let apiKey: String
	
	private let decoder = JSONDecoder()
	
	// --- internal init ---
	init(client: Client, apiKey: String) {
		self.client = client
		self.apiKey = apiKey
	}
	
	// --- internal methods ---
	func getAllStations() async throws -> Result<AllStationsResponse, ErrorKind> {
		
		do {
			let response = try await client.getAllStations(
				query: .init(
					apikey: apiKey
				)
			)
			
			switch response {
			case .ok(let ok):
				
				switch ok.body {
				case .json(let payload):
					
					return .success(payload)
					
				case .html(let body):
					
					var data = Data()
					for try await chunk in body {
						data.append(contentsOf: chunk)
					}
					
					let response = try decoder.decode(
						AllStationsResponse.self,
						from: data
					)
					return .success(response)
					
				}
				
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
		} catch {
			if error.localizedDescription.contains("offline") {
				return .failure(.noInternet)
			} else {
				throw error
			}
		}
    }
}
