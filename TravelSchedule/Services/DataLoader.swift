import Foundation

struct DataLoader {
	func downloadData(url: URL) async throws -> Data {
        do {
            async let (data, _) = URLSession.shared.data(from: url)
            return try await data
        } catch {
            throw NSError(domain: "DataLoader", code: 0, userInfo: nil)
        }
    }
}
