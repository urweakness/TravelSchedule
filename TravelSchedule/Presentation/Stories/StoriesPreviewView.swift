import SwiftUI

struct StoriesPreviewView: View {
    
    // MARK: - Environments
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var storiesManager: StoriesManager
    
    // MARK: - Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .center, spacing: 16) {
                ForEach(storiesManager.stories) { story in
                    StoryPreviewView(
                        story: story
                    )
                    .onTapGesture {
                        setStoryID(story.id)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 140)
        .padding(.vertical, 24)
    }
    
    // MARK: - Private Methods
    private func setStoryID(_ storyID: UUID) {
        let storyID = storiesManager.stories.firstIndex(where: { $0.id == storyID })
        storiesManager.currentStoryIndex = storyID ?? 0
        coordinator.present(fullScreenCover: .story)
    }
}
