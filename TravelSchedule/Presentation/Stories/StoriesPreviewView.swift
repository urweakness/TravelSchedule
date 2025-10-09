import SwiftUI

struct StoriesPreviewView: View {
	// --- DI ---
	@Bindable var manager: StoriesManager
	let present: (FullScreenCover) -> Void
    
    // --- body ---
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .center, spacing: 16) {
                ForEach(manager.stories) { story in
					content(story)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 140)
        .padding(.vertical, 24)
		.accessibilityIdentifier(
			AccessibilityIdentifier.storiesPreviewScroll.rawValue
		)
    }
    
	// --- private subviews ---
	private func content(_ story: StoryModel) -> some View {
		Button {
			openStory(withID: story.id)
		} label: {
			StoryPreviewContentView(
				story: story
			)
		}
	}
	
    // --- private helpers ---
    private func openStory(withID storyUUIDString: String) {
        let storyIndex = manager.stories.firstIndex(where: { $0.id == storyUUIDString }) ?? 0
        manager.currentStoryIndex = storyIndex
		present(.story)
    }
}
