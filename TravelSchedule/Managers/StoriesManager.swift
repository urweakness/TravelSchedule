import Foundation

@Observable
@MainActor
final class StoriesManager {
    private(set) var stories = [StoryModel]()
    var currentStoryIndex: Int = 0
    
    init(stories: [StoryModel] = []) {
        self.stories = stories
    }
    
	// MARK: - Centralized updating of an array of stories
    func apply(updatedStories: [StoryModel]) {
        self.stories = updatedStories
    }
    
	// MARK: - Refresh story parts on "isCheckedOut -> false" - if story fully checked
    func resetStoryIfFullyViewed(at index: Int) {
        guard stories.indices.contains(index) else { return }
        let story = stories[index]
        guard story.storyParts.allSatisfy(\.isCheckedOut) else { return }
        let resetParts = story.storyParts.map { $0.invertedCheckedOutStatus(to: false) }
        stories[index] = StoryModel(
            id: story.id, // save story identifier
            previewImageResource: story.previewImageResource,
            storyParts: resetParts
        )
    }
}
