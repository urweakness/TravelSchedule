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
    
    // MARK: - Private States
    @State private var carriers: [CarrierModel] = [stubCarrier, stubCarrier, stubCarrier, stubCarrier, stubCarrier, stubCarrier]
    
    // MARK: - Enviroments
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var travelRoutingViewModel: TravelRoutingViewModel
    
    // MARK: - Private Constants
    private let manager = ServicesManager.shared
    private let overscrollBottomPadding = CarrierListOverscroll().bottomPadding
    
    // MARK: - Body
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
                                    travelRoutingViewModel.choosedCarrier = ""
                                    coordinator.push(page: .carrierInfo)
                                }
                        }
                    }
                    .padding(.bottom, overscrollBottomPadding)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal, 16)
            .customNavigationBackButton()
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
    
    // MARK: - Private Views
    private var titleView: some View {
        Text(travelRoutingViewModel.title)
            .font(.bold24)
            .foregroundStyle(.travelBlack)
    }
    
    private var nextButtonView: some View {
        Button(action: {
            coordinator.push(page: .filtration)
        }) {
            Text("Уточнить время")
        }
        .buttonStyle(
            WideButtonStyle()
        )
    }
    
    // MARK: - Private Methods
    private func loadCarriers() async {
        #warning("TODO: load carriers using (travelRoutingManager.filter)")
    }
}

#Preview {
    CarriersListView()
        .environmentObject(Coordinator())
        .environmentObject(TravelRoutingViewModel())
}
