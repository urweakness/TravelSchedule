protocol NearestSettlementServiceProtocol {
    func getNearestCity(
        lat: Double,
        lng: Double
    ) async throws -> NearestCityResponse
}
