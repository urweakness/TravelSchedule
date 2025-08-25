import OpenAPIURLSession

final class ServicesManager {
    
    static let shared = ServicesManager()
    private init() {}
    
    
    func showThreadStationsService() async  {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            
            let threadStationsService = ThreadStationsService(
                client: client,
                apiKey: GlobalConstants.apiKey
            )
            
            let threadStations = try await threadStationsService.getThreadStations(
                uid: "7303A_9600213_g13_af"
            )
            
            print("THREAD STATIONS --> ", threadStations)
        } catch {
            print("An error occurred --> \(error)\n")
        }
    }
    
    func showStationScheduleService() async {
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
    
    func showServices() async {
        do {
            let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport())
            let apiKey = GlobalConstants.apiKey
            
            let nearestStationsService = NearestStationsService(
                client: client,
                apiKey: apiKey
            )
            let segmentsService = SegmentsService(
                client: client,
                apiKey: apiKey
            )
            let copyrightService = CopyrightService(
                client: client,
                apiKey: apiKey
            )
            let stationsListService = StationsListService(
                client: client,
                apiKey: apiKey
            )
            let carrierService = CarrierService(
                client: client,
                apiKey: apiKey
            )
            let nearestSettlementService = NearestSettlementService(
                client: client,
                apiKey: apiKey
            )
             
            let stations = try await nearestStationsService.getNearestStations(
                lat: 59.864177,
                lng: 30.319163,
                distance: 50
            )
            let copyright = try await copyrightService.getCopyright()
            let search = try await segmentsService.search(
                from: "s9600213",
                to: "c146"
            )
            let carrierInfo = try await carrierService.getCarrierInfo(
                code: "TK",
                system: .iata
            )
            let nearestCity = try await nearestSettlementService.getNearestCity(
                lat: 59.864177,
                lng: 30.319163
            )
            let stationList = try await stationsListService.getAllStations()
            
            print("COPYRIGHT --> ", copyright, "\n")
            print("SEARCH --> ", search, "\n")
            print("STATIONS --> ", stations, "\n")
            print("CARRIER --> ", carrierInfo, "\n")
            print("NEAREST CITY --> ", nearestCity, "\n")
            print("STATION LIST --> ", stationList, "\n")
        } catch {
            print("An error occurred --> \(error)\n")
        }
    }
}
