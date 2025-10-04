import SwiftUI

struct CustomNavigationBackButton: ViewModifier {
    
	let pop: () -> Void
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: pop) {
                        Image(systemName: "chevron.left")
                            .renderingMode(.template)
                            .foregroundStyle(.travelBlack)
                            .font(.bold17)
                    }
                }
            }
    }
}
