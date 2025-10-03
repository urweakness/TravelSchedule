@MainActor
protocol StoriesManagerProtocol {
	var stories: [StoryModel] { get }
	var currentStoryIndex: Int { get set }
	
	func setStoryPartCheckedOutStatus(
		currentStoryIndex: Int,
		currentStoryPartIndex: Int,
	)
}
