import SwiftUI

struct StoryPartView: View {
	
	// MARK: - Private Constants
    private let storyPart: StoryPartModel
	
	// MARK: - Internal Init
	init(storyPart: StoryPartModel) {
		self.storyPart = storyPart
	}
    
	// MARK: - Body
    var body: some View {
        imageView
            .overlay(alignment: .bottom) {
                storyDescription
            }
    }
}

// MARK: - StoryPartView Extensions

// MARK: - Private Views
private extension StoryPartView {
    var storyDescription: some View {
        VStack(spacing: 16) {
            titleView
            descriptionView
        }
        .padding(.bottom, 40)
    }
    
    var titleView: some View {
        Text(storyPart.title)
            .font(.bold34)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 16)
            .lineLimit(2)
            .contentTransition(.numericText())
    }
    
    var descriptionView: some View {
        Text(storyPart.description)
            .font(.regular20)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 16)
            .lineLimit(3)
            .contentTransition(.numericText())
    }
    
    var imageView: some View {
        Image(storyPart.fullImageResource)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 40))
    }
}

