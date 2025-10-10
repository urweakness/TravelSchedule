import SwiftUI

struct SettingsView: View {
    
	// --- storage ---
    @AppStorage("darkThemeIsActive") private var theme: Bool = false
	
	// --- DI ---
	let push: (Page) -> Void
    
	// --- body ---
    var body: some View {
        VStack {
            themeSwitch
            userAgreement
            Spacer()
            about
        }
        .padding(.horizontal, 16)
        .background(.travelWhite)
        .animation(.linear(duration: 0.15), value: theme)
    }
    
	// --- private subviews ---
    private var themeSwitch: some View {
        TravelListCell(
			text: .init(localized: .darkTheme),
			buttonAction: nil
		) {
            Toggle("", isOn: $theme)
				.labelsHidden()
                .tint(.travelBlue)
				.accessibilityIdentifier(
					AccessibilityIdentifier.themeSwitch.rawValue
				)
        }
    }
    
    private var userAgreement: some View {
        TravelListCell(
			text: .init(localized: .userAgreement),
            buttonAction: {
				push(.userAgreement)
			}
		) {
            Image(systemName: "chevron.right")
                .font(.bold17)
				.accessibilityIdentifier(
					AccessibilityIdentifier.chevronRight.rawValue
				)
        }
    }
    
    private var about: some View {
        VStack(spacing: 16) {
            Text(.appUsage)
				.accessibilityIdentifier(
					AccessibilityIdentifier.about.rawValue
				)
            Text(.version)
				.accessibilityIdentifier(
					AccessibilityIdentifier.version.rawValue
				)
        }
        .font(.regular12)
        .foregroundStyle(.travelBlack)
        .padding(.bottom, 24)
    }
}

#if DEBUG
#Preview {
	SettingsView(push: {_ in})
}
#endif
