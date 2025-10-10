protocol CarrierServiceProtocol {
    func getCarrierInfo(
        code: String,
        system: CodingSystem
	) async throws -> Result<CarrierJsonPayload, ErrorKind>
}
