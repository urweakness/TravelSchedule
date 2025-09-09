import Foundation

struct DataLoader {
    func downloadData(url: URL) async -> Data? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
