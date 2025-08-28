import SwiftUI

struct CustomNavigationBackButton: ViewModifier {
    
    @EnvironmentObject var coordinator: Coordinator
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                            .renderingMode(.template)
                            .foregroundStyle(.travelBlack)
                            .font(.bold17)
                    }
                }
            }
    }
}
