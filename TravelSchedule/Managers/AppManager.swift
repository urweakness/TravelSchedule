import Foundation

@MainActor
@Observable
final class AppManager {
    var appState: AppState = .stage
    var loadingState: LoadingState = .idle
    var stationList: AllStationsResponse?
}
