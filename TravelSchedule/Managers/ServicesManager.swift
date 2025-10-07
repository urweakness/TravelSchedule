import OpenAPIURLSession
import SwiftUI

final actor DataFetcher {
    enum ServiceError: Error {
        case stationListError(String)
        case threadStationsError(String)
        case stationScheduleError(String)
        case nearestStationsError(String)
        case segmentsError(String)
        case copyrightError(String)
        case nearestCityError(String)
        case carrierInfoError(String)
    }
	
	private func client() throws -> Client {
		.init(
			serverURL: try Servers.Server1.url(),
			transport: URLSessionTransport()
		)
	}
}

// MARK: - DataFetcher Extensions

// --- internal methods ---
extension DataFetcher {
		
	// --- getStationsList ---
    func getStationsList(format: Format = .json) async throws -> AllStationsResponse {
        do {
            let stationsListService = StationsListService(
                client: try client(),
				apiKey: GlobalConstants.apiKey
            )
            
			async let stationList = stationsListService.getAllStations()
			
            return try await stationList
        } catch {
            throw ServiceError.stationListError(error.localizedDescription)
        }
    }
    
	// --- getThreadStations ---
	func getThreadStations(by uid: String) async throws -> ThreadStationsResponse {
        do {
            let threadStationsService = ThreadStationsService(
                client: try client(),
                apiKey: GlobalConstants.apiKey
            )
            
            async let threadStations = threadStationsService.getThreadStations(
                uid: uid
            )
			return try await threadStations
        } catch {
			throw ServiceError.threadStationsError(error.localizedDescription)
        }
    }
    
	// --- getStationSchedule ---
	func getStationSchedule(station: String) async throws -> ScheduleResponse {
        do {
            let stationScheduleService = StationScheduleService(
                client: try client(),
                apiKey: GlobalConstants.apiKey
            )
            
            async let stationSchedule = stationScheduleService.getStationSchedule(
				station: station
            )
			return try await stationSchedule
        } catch {
            throw ServiceError.stationScheduleError(error.localizedDescription)
        }
    }
    
	// --- getNearestStations ---
	func getNearestStations(
		lat: Double,
		lng: Double,
		distance: Int
	) async throws -> NearestStations {
        do {
            let nearestStationsService = NearestStationsService(
                client: try client(),
				apiKey: GlobalConstants.apiKey
            )
            
            async let stations = nearestStationsService.getNearestStations(
				lat: lat,
				lng: lng,
				distance: distance
            )
			return try await stations
        } catch {
            throw ServiceError.nearestStationsError(error.localizedDescription)
        }
    }
    
	// --- getScheduleBetweenStations ---
	func getScheduleBetweenStations(
		from: String,
		to: String
	) async throws -> ScheduleBetweenStationsResponse {
        do {
            let segmentsService = ScheduleBetweenStationsService(
                client: try client(),
				apiKey: GlobalConstants.apiKey
            )
             
			async let search = segmentsService.search(
                from: from,
				to: to
            )
			return try await search
        } catch {
            throw ServiceError.segmentsError(error.localizedDescription)
        }
    }
    
	// --- getCopyright ---
	func getCopyright() async throws -> CopyrightResponse {
        do {
            let copyrightService = CopyrightService(
                client: try client(),
				apiKey: GlobalConstants.apiKey
            )
            async let copyright = copyrightService.getCopyright()
			return try await copyright
        } catch {
            throw ServiceError.copyrightError(error.localizedDescription)
        }
    }
    
	// --- getNearestCity ---
    func getNearestCity(
		lat: Double,
		lng: Double
	) async throws -> NearestCityResponse {
        do {
            let nearestSettlementService = NearestSettlementService(
                client: try client(),
				apiKey: GlobalConstants.apiKey
            )
            
            async let nearestCity = nearestSettlementService.getNearestCity(
				lat: lat,
                lng: lng
            )
			return try await nearestCity
        } catch {
            throw ServiceError.nearestCityError(error.localizedDescription)
        }
    }
    
	// --- getCarrierInfo ---
	func getCarrierInfo(
		carrierCode: String,
		codingSystem: CodingSystem
	) async throws -> CarrierJsonPayload {
        do {
            let carrierService = CarrierService(
                client: try client(),
				apiKey: GlobalConstants.apiKey
            )

            async let carrierInfo = carrierService.getCarrierInfo(
				code: carrierCode,
				system: codingSystem
            )
			return try await carrierInfo
        } catch {
            throw ServiceError.carrierInfoError(error.localizedDescription)
        }
    }
}
