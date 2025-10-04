import SwiftUI

struct TravelTabView: View {
	// --- private states ---
    @State private var selectedTab: TravelTab = .main
	
	// --- storage ---
    @AppStorage("darkThemeIsActive") private var darkThemeIsActive: Bool = false
    
	// --- DI ---
    let coordinator: Coordinator
    
	// --- body ---
    var body: some View {
        TabView(selection: $selectedTab) {
            coordinator.build(page: .main)
                .tabItem {
                    Label("", systemImage: "arrow.up.message.fill")
                }
                .tag(TravelTab.main)
			
            coordinator.build(page: .settings)
                .tabItem {
                    Label("", systemImage: "gearshape.fill")
                }
                .tag(TravelTab.settings)
        }
        .tint(Color.travelBlack)
        .preferredColorScheme(darkThemeIsActive ? .dark : .light)
    }
}
