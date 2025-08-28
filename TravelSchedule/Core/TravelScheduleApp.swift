import SwiftUI
import SwiftData

@main
struct TravelScheduleApp: App {
    
    @StateObject private var coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .environmentObject(coordinator)
        }
    }
}
