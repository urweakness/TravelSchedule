import Observation
import Foundation

@MainActor
@Observable
final class Loader {
	private(set) var loadingState: LoadingState = .idle
	
	func fetchData<T: Codable>(
		_ operation: @escaping @Sendable () async throws -> Result<T, ErrorKind>
	) async throws -> T {
		loadingState = .fetching

		do {
			switch try await operation() {
			case .success(let data):
				loadingState = .idle
				return data
			case .failure(let error):
				loadingState = .error(error)
				throw error
			}
			
		} catch {
			throw error
		}
	}
}
