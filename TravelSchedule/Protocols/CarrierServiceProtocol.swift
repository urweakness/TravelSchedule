protocol CarrierServiceProtocol {
    func getCarrierInfo(
        code: String,
        system: CodingSystem
    ) async throws -> JsonPayload
}
