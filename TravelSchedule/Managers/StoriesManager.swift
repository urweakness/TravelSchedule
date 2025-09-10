import Foundation

final class StoriesManager: ObservableObject {
    @Published private(set) var stories: [StoryModel] = stubStories
    @Published var currentStoryIndex: Int = 0
}
