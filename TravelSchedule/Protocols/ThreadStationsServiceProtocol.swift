protocol ThreadStationsServiceProtocol {
    func getThreadStations(uid: String) async throws -> ThreadStationsResponse
}
