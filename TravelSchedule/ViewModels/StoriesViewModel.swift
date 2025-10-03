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

// --- internal heplers ---
extension StoriesViewModel {
	func dataForStoryContentView(index: Int, story: StoryModel) ->
	(showProgress: Bool, currentStoryPartIndex: Int, progress: CGFloat) {
		let showProgress = index == currentStoryIndex
		let currentStoryPartIndex = index == currentStoryIndex ? currentStoryPartIndex : 0
		let progress = index == currentStoryIndex ? progressForCurrentStoryProgress(for: story) : 0
		
		return (
			showProgress: showProgress,
			currentStoryPartIndex: currentStoryPartIndex,
			progress: progress
		)
	}
	
	func setCurrentStory(index: Int) {
		guard stories.indices.contains(index) else { return }
		manager.currentStoryIndex = index
		currentStoryPartIndex = 0
		timer.reset()
	}
	
	func handleTouch(_ screenWidth: CGFloat, _ xPos: CGFloat) {
		if xPos >= screenWidth / 2 {
			performNextStoryPart()
		} else {
			performPrevStoryPart()
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
	
	func progressForCurrentStoryProgress(for story: StoryModel) -> CGFloat {
		let count = max(1, story.storyParts.count) // --- safe ---
		let partIndex = currentStoryPartIndex
		let partProgress = timer.progress
		var result: CGFloat = 0
		for i in 0..<count {
			if i < partIndex {
				result += 1
			} else if i == partIndex {
				result += partProgress
			}
		}
		return result / CGFloat(count)
	}
}

// --- TimerViewModelDelegate protocol conforomance ---
extension StoriesViewModel: @MainActor TimerViewModelDelegate {
    func timerDidCompletePart() {
        performNextStoryPart()
    }
}
