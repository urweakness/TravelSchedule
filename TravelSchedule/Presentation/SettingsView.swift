import SwiftUI

struct SettingsView: View {
    
    @AppStorage("darkThemeIsActive") private var theme: Bool = false
    
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
                
        }) {
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

#Preview {
    SettingsView()
}
