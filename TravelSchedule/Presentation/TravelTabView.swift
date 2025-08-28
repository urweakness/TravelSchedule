import SwiftUI

struct TravelTabView: View {
    
    @State private var selectedTab: TravelTab = .main
    @AppStorage("darkThemeIsActive") private var darkThemeIsActive: Bool = false
    
    @ViewBuilder
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView()
                .tabItem {
                    Label("", systemImage: "arrow.up.message.fill")
                }
                .tag(TravelTab.main)
            SettingsView()
                .tabItem {
                    Label("", systemImage: "gearshape.fill")
                }
                .tag(TravelTab.settings)
        }
        .tint(Color.travelBlack)
        .preferredColorScheme(darkThemeIsActive ? .dark : .light)
    }
}

#Preview {
    TravelTabView()
}
