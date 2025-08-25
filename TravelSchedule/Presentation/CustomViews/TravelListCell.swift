import SwiftUI

struct TravelListCell<V: View>: View {
    
    @State var text: String
    let buttonAction: (() -> Void)?
    @State var rightView: () -> V
    
    var body: some View {
        Button(action: buttonAction ?? {}){
            HStack {
                Text(text)
                    .font(.regular17)
                Spacer()
                rightView()
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}
