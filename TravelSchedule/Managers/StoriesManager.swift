import Foundation

@Observable
@MainActor
final class StoriesManager: StoriesManagerProtocol {
    private(set) var stories = [StoryModel]()
    var currentStoryIndex: Int = 0
    
    init(stories: [StoryModel] = []) {
        self.stories = stories
    }
    
	func setStoryPartCheckedOutStatus(
		currentStoryIndex: Int,
		currentStoryPartIndex: Int,
	) {
		guard
			let storyPart =
				stories[safe: currentStoryIndex]?
					.storyParts[safe: currentStoryPartIndex]
		else { return }
		
		stories[currentStoryIndex]
			.storyParts[currentStoryPartIndex] = storyPart.invertedCheckedOutStatus(to: true)
	}
}
