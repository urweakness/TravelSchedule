import OpenAPIURLSession
import SwiftUI

final class ServicesManager {
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
    func getStationsList(format: Format = .json) async throws -> AllStationsResponse {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let stationsListService = StationsListService(
                client: client,
                apiKey: apiKey
            )
            
            let stationList = try await stationsListService.getAllStations()
            
            return stationList
        } catch {
            throw ServiceError.stationListError(error.localizedDescription)
        }
    }
    
    
    
    func showThreadStations() async  {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            
            let threadStationsService = ThreadStationsService(
                client: client,
                apiKey: GlobalConstants.apiKey
            )
            
            let threadStations = try await threadStationsService.getThreadStations(
                uid: "SU-1484_250826_c26_12"
            )
            
            print("THREAD STATIONS --> ", threadStations)
        } catch {
            print("An error occurred --> \(error)\n")
        }
    }
    
    func showStationSchedule() async {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            
            let stationScheduleService = StationScheduleService(
                client: client,
                apiKey: GlobalConstants.apiKey
            )
            
            let stationSchedule = try await stationScheduleService.getStationSchedule(
                station: "s9600213"
            )
            
            print("STATION SCHEDULE --> ", stationSchedule)
        } catch {
            print("An error occurred --> \(error)\n")
        }
    }
    
    func showNearestStations() async {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let nearestStationsService = NearestStationsService(
                client: client,
                apiKey: apiKey
            )
            
            let stations = try await nearestStationsService.getNearestStations(
                lat: 59.864177,
                lng: 30.319163,
                distance: 50
            )
            
            print("STATIONS --> ", stations, "\n")
        } catch {
            print("An error occurred --> \(error)\n")
        }
    }
    
    func showSegments() async {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let segmentsService = SegmentsService(
                client: client,
                apiKey: apiKey
            )
             
            let search = try await segmentsService.search(
                from: "s9600213",
                to: "c146"
            )
            
            print("SEARCH --> ", search, "\n")
        } catch {
            print("An error occurred --> \(error)\n")
        }
    }
    
    func showCopyright() async {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let copyrightService = CopyrightService(
                client: client,
                apiKey: apiKey
            )
             
            let copyright = try await copyrightService.getCopyright()
            
            print("COPYRIGHT --> ", copyright, "\n")
        } catch {
            print("An error occurred --> \(error)\n")
        }
    }
    
    func showNearestCity() async {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let nearestSettlementService = NearestSettlementService(
                client: client,
                apiKey: apiKey
            )
            
            let nearestCity = try await nearestSettlementService.getNearestCity(
                lat: 59.864177,
                lng: 30.319163
            )
            
            print("NEAREST CITY --> ", nearestCity, "\n")
        } catch {
            print("An error occurred --> \(error)\n")
        }
    }
    
    func showCarrierInfo() async {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let carrierService = CarrierService(
                client: client,
                apiKey: apiKey
            )

            let carrierInfo = try await carrierService.getCarrierInfo(
                code: "TK",
                system: .iata
            )

            print("CARRIER --> ", carrierInfo, "\n")
        } catch {
            print("An error occurred --> \(error)\n")
        }
    }
}
