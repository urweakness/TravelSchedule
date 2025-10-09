protocol ThreadStationsServiceProtocol {
	func getThreadStations(uid: String) async throws -> Result<ThreadStationsResponse, ErrorKind>
}
