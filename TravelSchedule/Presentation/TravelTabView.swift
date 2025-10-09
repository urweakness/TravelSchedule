import SwiftUI

struct TravelTabView: View {
	// --- private states ---
	@State private var viewModel: TravelTabViewModel
    @State private var selectedTab: TravelTab = .main
	
	// --- storage ---
    @AppStorage("darkThemeIsActive") private var darkThemeIsActive: Bool = false
	
	// --- DI ---
	@Bindable var manager: AppManager
	let buildMainView: () -> MainView
	let buildSettingsView: () -> SettingsView
	
	init(
		manager: AppManager,
		dataCoordinator: DataCoordinator,
		buildMainView: @escaping () -> MainView,
		buildSettingsView: @escaping () -> SettingsView
	) {
		self.buildMainView = buildMainView
		self.buildSettingsView = buildSettingsView
		self.manager = manager
		_viewModel = .init(
			initialValue: .init(
				dataCoordinator: dataCoordinator
			)
		)
	}
	
	// --- body ---
    var body: some View {
        TabView(selection: $selectedTab) {
			buildMainView()
				.tabItem {
					Label("", systemImage: "arrow.up.message.fill")
						.accessibilityIdentifier(
							AccessibilityIdentifier.tabViewMainTabItem.rawValue
						)
				}
				.tag(TravelTab.main)
			
			buildSettingsView()
				.tabItem {
					Label("", systemImage: "gearshape.fill")
						.accessibilityIdentifier(
							AccessibilityIdentifier.tabViewSettingsTabItem.rawValue
						)
				}
				.tag(TravelTab.settings)
        }
		.accessibilityIdentifier(
			AccessibilityIdentifier.tabView.rawValue
		)
        .tint(Color.travelBlack)
        .preferredColorScheme(darkThemeIsActive ? .dark : .light)
		.task {
			await fetchStations()
		}
    }
	
	private func fetchStations() async {
		guard
			manager.stationList == nil
		else { return }
		manager.stationList = await viewModel
			.fetchAllStations()
	}
}
