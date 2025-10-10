protocol StationScheduleServiceProtocol {
	func getStationSchedule(station: String) async throws -> Result<ScheduleResponse, ErrorKind>
}
