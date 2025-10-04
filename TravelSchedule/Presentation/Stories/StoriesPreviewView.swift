import SwiftUI

struct StoriesPreviewView: View {
    
	// --- envs ---
	@Bindable var manager: StoriesManager
	let present: (FullScreenCover) -> Void
    
    // --- body ---
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .center, spacing: 16) {
                ForEach(manager.stories) { story in
                    StoryPreviewView(
                        story: story
                    )
                    .onTapGesture {
                        openStory(withID: story.id)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 140)
        .padding(.vertical, 24)
    }
    
    // --- private helpers ---
    private func openStory(withID storyUUIDString: String) {
        let storyIndex = manager.stories.firstIndex(where: { $0.id == storyUUIDString }) ?? 0
        manager.currentStoryIndex = storyIndex
		present(.story)
    }
}
