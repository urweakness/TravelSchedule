protocol ScheduleBetweenStationsServiceProtocol {
    func search(
        from: String,
        to: String
    ) async throws -> Segments
}
