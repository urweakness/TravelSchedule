import DeveloperToolsSupport
import Foundation

struct StoryPartModel: Identifiable, Equatable {
    let id: String
    let fullImageResource: ImageResource
    let title: String
    let description: String
    let isCheckedOut: Bool

	// MARK: Explicit init with id (default: new id will generate initially)
    init(
        id: String = UUID().uuidString,
        fullImageResource: ImageResource,
        title: String,
        description: String,
        isCheckedOut: Bool
    ) {
        self.id = id
        self.fullImageResource = fullImageResource
        self.title = title
        self.description = description
        self.isCheckedOut = isCheckedOut
    }
    
    func invertedCheckedOutStatus(to status: Bool) -> Self {
        .init(
            id: id, // saving part identifier
            fullImageResource: fullImageResource,
            title: title,
            description: description,
            isCheckedOut: status
        )
    }
}

struct StoryModel: Identifiable, Equatable {
    let id: String
    let previewImageResource: ImageResource
    var storyParts: [StoryPartModel]
    
	// MARK: Explicit init with id (default: new id will generate initially)
    init(
        id: String = UUID().uuidString,
        previewImageResource: ImageResource,
        storyParts: [StoryPartModel]
    ) {
        self.id = id
        self.previewImageResource = previewImageResource
        self.storyParts = storyParts
    }
    
	// MARK: - Considering a story state (isCheckedOut -> true) only when all parts have been viewed
    var isCheckedOut: Bool {
        storyParts.allSatisfy(\.isCheckedOut)
    }
}
