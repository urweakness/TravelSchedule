import Foundation

final class AppManager: ObservableObject {
    @Published var appState: AppState = .stage
    @Published var loadingState: LoadingState = .idle
    @Published var stationList: AllStationsResponse?
}
