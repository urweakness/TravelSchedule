protocol ScheduleBetweenStationsServiceProtocol {
    func search(
        from: String,
        to: String
	) async throws -> Result<ScheduleBetweenStationsResponse, ErrorKind>
}
