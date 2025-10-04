import SwiftUI

struct TravelTabView: View {
    
	// MARK: - Private States
    @State private var selectedTab: TravelTab = .main
	
	// MARK: - State Storage
    @AppStorage("darkThemeIsActive") private var darkThemeIsActive: Bool = false
    
	// MARK: - DI States
    @EnvironmentObject var coordinator: Coordinator
    
	// MARK: - Body
    @ViewBuilder
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
