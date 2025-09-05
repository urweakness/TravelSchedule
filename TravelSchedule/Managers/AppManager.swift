import Foundation

final class AppManager: ObservableObject {
    @Published var loadingState: LoadingState = .idle
    @Published var stationList: AllStationsResponse?
}
