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
}
