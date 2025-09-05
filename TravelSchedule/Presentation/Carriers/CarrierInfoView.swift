import SwiftUI

struct CarrierInfoView: View {
    
    // MARK: - State Private Properties
    @State private var carrierImage: Image?
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.travelWhite
                .ignoresSafeArea()
            
            VStack(
                alignment: .leading,
                spacing: 28
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {
                    carrierImageVIew
                    carrierNameView
                }
                VStack(spacing: 16) {
                    carrierEmailView
                    carrierPhoneView
                }
                Spacer()
            }
            .padding(16)
            .task {
                Task {
                    await fetchImage()
                }
            }
        }
        .customNavigationBackButton()
    }
    
    // MARK: - Private Views
    @ViewBuilder
    private var carrierImageVIew: some View {
        if let carrierImage {
            carrierImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 104)
                .frame(maxWidth: .infinity)
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )
        } else {
            Rectangle()
                .fill(.clear)
                .frame(height: 104)
        }
    }
    
    private var carrierNameView: some View {
        Text("ОАО «РЖД»")
            .font(.bold24)
            .foregroundColor(.travelBlack)
    }
    
    @ViewBuilder
    private var carrierEmailView: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            Text("E-mail")
                .font(.regular17)
                .foregroundStyle(.travelBlack)
            
            if let url = URL(string: "mailto:i.lozgkina@yandex.ru") {
                Link(
                    "i.lozgkina@yandex.ru",
                    destination: url
                )
                .font(.regular12)
            }
        }
    }
    
    @ViewBuilder
    private var carrierPhoneView: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            Text("Телефон")
                .font(.regular17)
                .foregroundStyle(.travelBlack)
            
            if let url = URL(string: "tel:+7 (904) 329-27-71") {
                Link(
                    "+7 (904) 329-27-71",
                    destination: url
                )
                .font(.regular12)
            }
        }
    }
    
    // MARK: - Private Methods
    private func fetchImage() async {
        guard
            let url = URL(string: "https://yastat.net/s3/rasp/media/data/company/logo/thy_kopya.jpg"),
            let data = try? Data(contentsOf: url),
            let uiImage = UIImage(data: data)
        else {
            return
        }
        
        withAnimation {
            carrierImage = Image(uiImage: uiImage)
        }
    }
}

#Preview {
    CarrierInfoView()
}
