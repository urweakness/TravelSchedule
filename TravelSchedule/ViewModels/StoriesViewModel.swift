import SwiftUI

@Observable
@MainActor
final class StoriesViewModel {
    // --- manager (source of truth) ---
	private(set) var manager: StoriesManagerProtocol

    // --- Index for story part ---
    private(set) var currentStoryPartIndex: Int = 0

    // --- timer ---
    let timer: TimerManager
	
	@ObservationIgnored
	var dismiss: DismissAction?

	// --- internal init ---
    init(
		manager: StoriesManagerProtocol,
		secondsPerStoryPart: TimeInterval = 5
	) {
        self.manager = manager
        self.currentStoryPartIndex = 0
        self.timer = TimerManager(secondsPerStoryPart: secondsPerStoryPart)
        self.timer.delegate = self
    }
	
    // --- proxy accessors ---
    var stories: [StoryModel] { manager.stories }
    var currentStoryIndex: Int { manager.currentStoryIndex }
}

// MARK: - StoriesViewModel Extensions
// --- private navigation ---
private extension StoriesViewModel {
	func setCurrentStory(index: Int) {
		guard stories.indices.contains(index) else { return }
		manager.currentStoryIndex = index
		currentStoryPartIndex = 0
		timer.reset()
	}
	
	func performNextStory() {
		guard stories.indices.contains(currentStoryIndex + 1) else {
			dismiss?()
			return
		}
		manager.currentStoryIndex += 1
		currentStoryPartIndex = 0
		timer.reset()
	}
	
	func performPrevStory() {
		guard currentStoryIndex > 0 else { return }
		manager.currentStoryIndex -= 1
		currentStoryPartIndex = 0
		timer.reset()
	}
	
	func performNextStoryPart() {
		setStoryPartCheckedOutStatus()
		guard let story = stories[safe: currentStoryIndex] else { return }
		if story.storyParts.indices.contains(currentStoryPartIndex + 1) {
			currentStoryPartIndex += 1
			timer.reset()
		} else {
			performNextStory()
		}
	}
	
	func performPrevStoryPart() {
		if currentStoryPartIndex > 0 {
			currentStoryPartIndex -= 1
			timer.reset()
		} else {
			performPrevStory()
		}
	}
}

// --- private helpers ---
private extension StoriesViewModel {
	func setStoryPartCheckedOutStatus() {
		manager.setStoryPartCheckedOutStatus(
			currentStoryIndex: currentStoryIndex,
			currentStoryPartIndex: currentStoryPartIndex
		)
	}
}

// --- TimerViewModelDelegate protocol conforomance ---
extension StoriesViewModel: @MainActor TimerViewModelDelegate {
    func timerDidCompletePart() {
        performNextStoryPart()
    }
}
