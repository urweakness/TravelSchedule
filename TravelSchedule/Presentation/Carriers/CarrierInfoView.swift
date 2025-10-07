import SwiftUI

struct CarrierInfoView: View {
    
    // --- private states ---
    @State private var carrierImage: Image?
    
	// --- DI ---
	let carrier: CarrierModel
	let pop: () -> Void
	let navigationTitle: String
	let navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode
    
    // --- body ---
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
		.navigationTitle(navigationTitle)
		.navigationBarTitleDisplayMode(navigationTitleDisplayMode)
		.customNavigationBackButton(pop: pop)
    }
    
    // --- private views ---
    @ViewBuilder
    private var carrierImageVIew: some View {
		if
			let logoURLString = carrier.logoURLString,
			!logoURLString.isEmpty
		{
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
    }
    
    private var carrierNameView: some View {
		Text(carrier.name)
            .font(.bold24)
            .foregroundColor(.travelBlack)
    }
    
    @ViewBuilder
    private var carrierEmailView: some View {
		if
			let email = carrier.email,
			!email.isEmpty
		{
			VStack(
				alignment: .leading,
				spacing: 0
			) {
				Text("E-mail")
					.font(.regular17)
					.foregroundStyle(.travelBlack)
				
				if let url = URL(string: "mailto:\(email)") {
					Link(
						email,
						destination: url
					)
					.font(.regular12)
				}
			}
        }
    }
    
    @ViewBuilder
    private var carrierPhoneView: some View {
        if
			let phone = carrier.phone,
			!phone.isEmpty
		{
 		   VStack(
				alignment: .leading,
				spacing: 0
			) {
				Text("Телефон")
					.font(.regular17)
					.foregroundStyle(.travelBlack)
				
				if let url = URL(string: "tel:\(phone)") {
					Link(
						phone,
						destination: url
					)
					.font(.regular12)
				}
			}
        }
    }
    
    // --- private methods ---
    private func fetchImage() async {
        let loader = DataLoader()
        guard
			let logoURLString = carrier.logoURLString,
			let url = URL(string: logoURLString),
            let data = try? await loader.downloadData(url: url),
            let uiImage = UIImage(data: data)
        else {
            return
        }
        
        withAnimation {
            carrierImage = Image(uiImage: uiImage)
        }
    }
}
