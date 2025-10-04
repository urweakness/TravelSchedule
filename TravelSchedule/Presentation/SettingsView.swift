import SwiftUI

struct SettingsView: View {
    
	// MARK: - State Storage
    @AppStorage("darkThemeIsActive") private var theme: Bool = false
	
	// MARK: - DI States
	let push: (Page) -> Void
    
	// MARK: - Body
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
    
	// MARK: - Private Views
    private var themeSwitch: some View {
        TravelListCell(text: "Темная тема", buttonAction: nil) {
            Toggle("", isOn: $theme)
                .tint(.travelBlue)
        }
    }
    
    private var userAgreement: some View {
        TravelListCell(
            text: "Пользовательское соглашение",
            buttonAction: {
				push(.userAgreement)
			}
		) {
            Image(systemName: "chevron.right")
                .font(.bold17)
        }
    }
    
    private var about: some View {
        VStack(spacing: 16) {
            Text("Приложение использует API «Яндекс.Расписания»")
            Text("Версия 1.0 (beta)")
        }
        .font(.regular12)
        .foregroundStyle(.travelBlack)
        .padding(.bottom, 24)
    }
}
