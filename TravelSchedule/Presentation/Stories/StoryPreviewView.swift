import SwiftUI

struct StoryPreviewView: View {
    
    @State private(set) var story: StoryModel
    
    var body: some View {
        Image(story.previewImageResource)
            .overlay(alignment: .bottom) {
                titleCover
            }
            .overlay(content: border)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var titleCover: some View {
        Text(story.title)
            .font(.regular12)
            .foregroundStyle(.white)
            .padding(.bottom, 12)
            .padding(.horizontal, 8)
            .lineLimit(3)
    }
    
    private func border() -> some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(story.isCheckedOut ? .clear : .travelBlue, lineWidth: 6)
            .padding(1)
    }
    
}
