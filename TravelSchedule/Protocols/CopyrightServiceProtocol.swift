protocol CopyrightServiceProtocol {
	func getCopyright() async throws -> Result<CopyrightResponse, ErrorKind>
}
