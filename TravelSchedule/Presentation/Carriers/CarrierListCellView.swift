import SwiftUI

#if DEBUG
#Preview {
	CarrierListCellView(
		carrier: CarrierModel(
			code: 2345,
			logoURLString: "",
//			name: "УПАПDFJSDKFSDKJFHSKDJFHSKJDHFSDJKHFSKJDFSOIDJFOPSIDJFOOSDIJFPOSDIJF",
			name: "УПАП-1 - филиал ГУП Башавтотранс РБ",
			transferInfo: "С пересадкой в Костроме",
			departureDate: .now,
			startTime: "10:00",
			endTime: "20:00",
			duration: "20 часов\n15 минут",
			email: nil,
			phone: nil
		)
	)
	.padding(.horizontal, 16)
}
#endif

struct CarrierListCellView: View {
	
	// -- private states
    @State private var carrierLogoImage: Image?
	
	// --- DI ---
	let carrier: CarrierModel
	
	// --- envs ---
    @Environment(\.colorScheme) var theme
    
	// --- body ---
    var body: some View {
		HStack(spacing: 8) {
			carrierImageView
			VStack(
				alignment: .leading,
				spacing: 18
			) {
				VStack(alignment: .leading, spacing: 2) {
					HStack(alignment: .top) {
						carrierNameView
						dateView
							.opacity(0)
							.padding(.trailing, 12)
					}
					transferInfoView
				}
				tripContent
			}
		}
		.padding(.top, 14)
		.padding(.leading, 14)
		.background {
			RoundedRectangle(cornerRadius: 16)
				.fill(theme == .light ? .travelLightGray : .white)
		}
		.overlay(alignment: .topTrailing) {
			dateView
				.padding(.top, 14)
				.padding(.trailing, 14)
		}
		.task {
			await loadCarrierImage()
		}
    }
    
    // --- private subviews
	private var tripContent: some View {
		HStack(spacing: 8) {
			startTimeView
			timeDividerView
			deltaTimeView
			timeDividerView
			endTimeView
		}
		.padding(.trailing, 14)
		.padding(.bottom, 14)
	}
	
    @ViewBuilder
    private var carrierImageView: some View {
        if let carrierLogoImage {
            carrierLogoImage
                .resizable()
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                .frame(width: 38, height: 38)
        }
    }
    
    private var carrierNameView: some View {
        Text(carrier.name)
            .font(.regular17)
            .foregroundColor(.black)
    }
    
	@ViewBuilder
    private var transferInfoView: some View {
		if let transferInfo = carrier.transferInfo {
			Text(transferInfo)
				.font(.regular12)
				.foregroundColor(.travelRed)
		}
    }
    
    @ViewBuilder
    private var dateView: some View {
		Text(carrier.departureDateString)
			.font(.regular12)
			.foregroundColor(.black)
    }
    
    private var startTimeView: some View {
        Text(carrier.startTime)
            .font(.regular17)
            .foregroundColor(.black)
    }
    
    private var endTimeView: some View {
        Text(carrier.endTime)
            .font(.regular17)
            .foregroundColor(.black)
    }
    
    private var deltaTimeView: some View {
		Text(carrier.duration)
            .font(.regular12)
			.multilineTextAlignment(.center)
            .foregroundColor(.black)
    }
    
    private var timeDividerView: some View {
        Capsule(style: .continuous)
            .fill(.travelGray)
            .frame(height: 1)
    }
    
    // --- private methods ---
	private func loadCarrierImage() async {
		guard let logoURLString = carrier.logoURLString else { return }
		
		let loader = DataLoader()
		guard let imageURL = URL(string: logoURLString) else { return }
		guard
			let data = try? await loader.downloadData(url: imageURL),
			let uiImage = UIImage(data: data)
		else { return }
		carrierLogoImage = Image(uiImage: uiImage)
	}
}
