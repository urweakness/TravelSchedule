import SwiftUI

struct StoryPreviewView: View {
    
	// MARK: - Private Constants
    private let story: StoryModel
    
	// MARK: - Internal Init
	init(story: StoryModel) {
		self.story = story
	}
	
	// MARK: - Body
    var body: some View {
        Image(story.previewImageResource)
            .overlay(alignment: .bottom) {
                titleCover
            }
            .overlay(content: border)
            .clipShape(RoundedRectangle(cornerRadius: 16))
			.opacity(story.isCheckedOut ? 0.5 : 1)
    }
    
	// MARK: - Private Views
    @ViewBuilder
    private var titleCover: some View {
        let title = story.storyParts.first?.title ?? "FAILED TO PARSE STORY TITLE"
        Text(title)
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
