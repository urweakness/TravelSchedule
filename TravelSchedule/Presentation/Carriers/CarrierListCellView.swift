import SwiftUI

struct CarrierListCellView: View {
    
    // MARK: - State Private Properties
    @State var carrier: CarrierModel
    @State private var carrierLogoImage: Image?
    @Environment(\.colorScheme) var theme
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(theme == .light ? .travelLightGray : .white)
            .overlay(alignment: .topLeading) {
                HStack(spacing: 8) {
                    carrierImageView
                    VStack(alignment: .leading, spacing: 2) {
                        carrierNameView
                        transferInfoView
                    }
                }
                .padding(.top, 14)
                .padding(.leading, 14)
            }
            .overlay(alignment: .topTrailing) {
                dateView
                    .padding(.top, 14)
                    .padding(.trailing, 14)
            }
            .overlay(alignment: .bottom) {
				tripContent
            }
            .frame(height: 104)
            .task {
                Task {
					await loadCarrierImage()
                }
            }
    }
    
    // MARK: - Private Views
	private var tripContent: some View {
		HStack(spacing: 8) {
			startTimeView
			timeDividerView
			deltaTimeView
			timeDividerView
			endTimeView
		}
		.padding(.horizontal, 14)
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
    
    private var transferInfoView: some View {
        Text(carrier.transferInfo)
            .font(.regular12)
            .foregroundColor(.travelRed)
    }
    
    @ViewBuilder
    private var dateView: some View {
        if let dateString = convertInputDateString(carrier.dateString) {
            Text(dateString)
            .font(.regular12)
            .foregroundColor(.black)
        }
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
        Text(carrier.tripTimeDelta)
            .font(.regular12)
            .foregroundColor(.black)
    }
    
    private var timeDividerView: some View {
        Capsule(style: .continuous)
            .fill(.travelGray)
            .frame(height: 1)
    }
    
    // MARK: - Private Methods
	private func loadCarrierImage() async {
		let loader = DataLoader()
		guard let imageURL = URL(string: carrier.logoURLString) else { return }
		guard
			let data = try? await loader.downloadData(url: imageURL),
			let uiImage = UIImage(data: data)
		else { return }
		carrierLogoImage = Image(uiImage: uiImage)
	}
	
    private func convertInputDateString(_ dateString: String?) -> String? {
        guard let dateString else {
            return nil
        }
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateStyle = .long
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputDateFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "d MMMM"
        
        return outputDateFormatter.string(from: date)
    }
}

#Preview {
    CarrierListCellView(carrier: stubCarrier)
}
