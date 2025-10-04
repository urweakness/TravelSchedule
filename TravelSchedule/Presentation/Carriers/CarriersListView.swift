import SwiftUI

// MARK: - Tempororary implementation
struct CarrierModel: Identifiable {
    let id: UUID = UUID()
    var logoURLString: String
    var name: String
    var transferInfo: String
    var dateString: String
    var startTime: String
    var endTime: String
    var tripTimeDelta: String
}

let stubCarrier = CarrierModel(
    logoURLString: "https://yastat.net/s3/rasp/media/data/company/logo/thy_kopya.jpg",
    name: "TK",
    transferInfo: "С пересадкой в Костроме",
    dateString: "2023-01-14T15:30:00+0000",
    startTime: "22:30",
    endTime: "08:15",
    tripTimeDelta: "20 часов"
)

struct CarriersListView: View {
    
    // --- private states ---
    @State private var carriers: [CarrierModel] = [stubCarrier, stubCarrier, stubCarrier, stubCarrier, stubCarrier, stubCarrier]
    
	// --- DI ---
	@Bindable var manager: TravelRoutingManager
	let push: (Page) -> Void
	let pop: () -> Void
    
    // --- private constants ---
    private let networkServicesManager = ServicesManager.shared
    private let overscrollBottomPadding = CarrierListOverscroll().bottomPadding
    
    // --- body ---
    var body: some View {
        ZStack {
            Color.travelWhite
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                titleView
                ScrollView(.vertical){
                    VStack(spacing: 8) {
                        ForEach(carriers) { carrier in
                            CarrierListCellView(carrier: carrier)
                                .onTapGesture {
                                    #warning("TODO: set carrier before pushing info about him")
                                    manager.choosedCarrier = ""
									push(.carrierInfo)
                                }
                        }
                    }
                    .padding(.bottom, overscrollBottomPadding)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal, 16)
			.customNavigationBackButton(pop: pop)
            .navigationBarBackButtonHidden()
            
            VStack {
                Spacer()
                nextButtonView
                    .padding(.bottom)
            }
        }
        .task {
            Task {
                await loadCarriers()
            }
        }
    }
    
    // --- private views ---
    private var titleView: some View {
        Text(manager.title)
            .font(.bold24)
            .foregroundStyle(.travelBlack)
    }
    
    private var nextButtonView: some View {
        Button(action: {
			push(.filtration)
        }) {
            Text("Уточнить время")
        }
        .buttonStyle(
            WideButtonStyle()
        )
    }
    
    // --- private methods ---
    private func loadCarriers() async {
        #warning("TODO: load carriers using (travelRoutingManager.filter)")
    }
}
