protocol StationScheduleServiceProtocol {
    func getStationSchedule(station: String) async throws -> ScheduleResponse
}
