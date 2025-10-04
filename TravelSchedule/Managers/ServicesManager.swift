import OpenAPIURLSession
import SwiftUI

final actor ServicesManager {
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
    
    static let shared = ServicesManager()
    private init() {}
}

extension ServicesManager {
		
	// --- getStationsList ---
    func getStationsList(format: Format = .json) async throws -> AllStationsResponse {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let stationsListService = StationsListService(
                client: client,
                apiKey: apiKey
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
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            
            let threadStationsService = ThreadStationsService(
                client: client,
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
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            
            let stationScheduleService = StationScheduleService(
                client: client,
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
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let nearestStationsService = NearestStationsService(
                client: client,
                apiKey: apiKey
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
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let segmentsService = ScheduleBetweenStationsService(
                client: client,
                apiKey: apiKey
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
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let copyrightService = CopyrightService(
                client: client,
                apiKey: apiKey
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
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let nearestSettlementService = NearestSettlementService(
                client: client,
                apiKey: apiKey
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
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let carrierService = CarrierService(
                client: client,
                apiKey: apiKey
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
