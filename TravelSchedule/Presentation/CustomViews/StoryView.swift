import SwiftUI

struct StoryView: View {
    
    @State private(set) var attributedTitle: AttributedString
    @State private(set) var imageResource: ImageResource
    @State private(set) var checked: Bool
    
    var body: some View {
        Image(imageResource)
            .overlay(alignment: .bottom) {
                titleCover
            }
            .overlay(content: border)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var titleCover: some View {
        Text(attributedTitle)
            .font(.regular12)
            .foregroundStyle(.white)
            .padding(.bottom, 12)
            .padding(.horizontal, 8)
            .lineLimit(3)
    }
    
    private func border() -> some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(checked ? .clear : .travelBlue, lineWidth: 6)
            .padding(1)
    }
    
}
