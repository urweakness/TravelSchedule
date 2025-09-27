import SwiftUI

struct StoriesPreviewView: View {
    
	// MARK: - DI States
    @Environment(StoriesManager.self) private var manager
    @EnvironmentObject private var coordinator: Coordinator
    
    // MARK: - Body
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
    
    // MARK: - Private Methods
    private func openStory(withID storyUUIDString: String) {
        let storyIndex = manager.stories.firstIndex(where: { $0.id == storyUUIDString }) ?? 0
        // ВАЖНО: больше не сбрасываем флаги при повторном просмотре
        manager.currentStoryIndex = storyIndex
        coordinator.present(fullScreenCover: .story)
    }
}
