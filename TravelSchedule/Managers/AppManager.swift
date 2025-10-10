import Foundation

@MainActor
@Observable
final class AppManager {
    var appState: AppState = .stage
    var stationList: AllStationsResponse?
}
