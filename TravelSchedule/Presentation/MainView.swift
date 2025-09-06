import SwiftUI

struct MainView: View {
    
    // MARK: - Enviroments
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var travelRoutingViewModel: TravelRoutingViewModel
    
    // MARK: - Body
    @ViewBuilder
    var body: some View {
        ZStack {
            Color.travelWhite
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                StoriesPreviewView()
                RoutingView()
                
                if travelRoutingViewModel.travelPointsFilled {
                    findButtonView
                        .transition(.opacity)
                }
                Spacer()
            }
        }
    }
    
    // MARK: - Private Views
    private var findButtonView: some View {
        Button(action: {
            coordinator.push(page: .carriersChoose)
            travelRoutingViewModel.isDestination = nil
        }) {
            Text("Найти")
                .font(.bold17)
                .foregroundColor(.white)
                .padding(20)
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.travelBlue)
        )
    }
}

#Preview {
    CoordinatorView()
        .environmentObject(Coordinator())
}
