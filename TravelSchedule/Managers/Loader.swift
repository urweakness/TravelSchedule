import Observation

@MainActor
@Observable
final class Loader {
	private(set) var loadingState: LoadingState = .idle
	
	func fetchData<T: Codable>(
		_ operation: @escaping @Sendable () async throws -> T
	) async throws -> T {
		loadingState = .fetching
		defer { loadingState = .idle }
		do {
			let response = try await operation()
			return response
		} catch {
			loadingState = .error(.serverError)
			throw error
		}
	}
}
