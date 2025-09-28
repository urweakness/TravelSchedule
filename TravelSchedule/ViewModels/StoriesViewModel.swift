import SwiftUI
import Combine

@Observable
@MainActor
final class StoriesViewModel {
	
	// MARK: - Internal Properties
    var screenSize: CGSize = .zero
    var currentStoryIndex: Int = 0 {
        didSet { storyIndexDidChange() }
    }
    var currentStoryPartIndex: Int = 0 {
        didSet { storyPartIndexDidChange() }
    }
    var stories: [StoryModel] = []
    var currentProgressPhase: StoryAnimationPhase = .start
    var progressRunID: Int = 0

    @ObservationIgnored
    var dismiss: DismissAction?
	
	// MARK: - Internal Constants
    let storyTimeout = TimeInterval(GlobalConstants.storyPreviewTimeout)
    
	// MARK: - Private Properties
    @ObservationIgnored
    private var timer: Timer?
    
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    
    @ObservationIgnored
    private var cancellable: Cancellable?
    
    @ObservationIgnored
    private var startProgressWorkItem: DispatchWorkItem?
    
	// Режим повторного просмотра: не трогаем isCheckedOut, но проигрываем всю сторис
	@ObservationIgnored
	private var isRewatchMode: Bool = false
    
	// MARK: - Internal Init
    init() {}
}

// MARK: - StoriesViewModel Extensions

// MARK: Internal

//MARK: viewDidAppear
extension StoriesViewModel {
	func viewDidAppear(
		dismiss: DismissAction,
		screenSize: CGSize,
		storyIndex: Int,
		stories: [StoryModel]
	) {
		self.dismiss = dismiss
		self.screenSize = screenSize
		self.stories = stories
		
		// delect rewatch model for choosed story
		let fullyViewed = isStoryFullyViewed(in: stories, at: storyIndex)
		self.isRewatchMode = fullyViewed
		
		// start part
		// if story fully checked -> start with 0 index
		// else -> start with FIRST not checked
		let startPartIndex = fullyViewed ? 0 : firstUnviewedPartIndex(for: storyIndex, in: stories)
		self.currentStoryIndex = storyIndex
		self.currentStoryPartIndex = startPartIndex
		
		finishProgressAnimation()
		scheduleStartProgressAfterTick(restartTimer: true)
	}
}

// MARK: viewModel state managing
extension StoriesViewModel {
	func performDismissView() {
		invalidateTimer()
		dismiss?()
	}
	
	func invalidateTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	private func restartTimer() {
		invalidateTimer()
		timer = Timer.scheduledTimer(
			timeInterval: storyTimeout,
			target: self,
			selector: #selector(timerDidFire),
			userInfo: nil,
			repeats: false
		)
	}
	
	@objc private func timerDidFire(_ timer: Timer) {
		goToNextPartOrStory()
	}
	
	func startProgressAnimation() {
		currentProgressPhase = .end
		progressRunID &+= 1
	}
	func finishProgressAnimation() {
		currentProgressPhase = .start
	}
}

// MARK: Data Getters
extension StoriesViewModel {
	var currentStory: StoryModel? {
		stories[safe: currentStoryIndex]
	}
	
	func progressState(for index: Int) -> (phase: StoryAnimationPhase, isAnimated: Bool) {
		guard let story = currentStory, story.storyParts.indices.contains(index) else {
			return (.start, false)
		}
		
		if isRewatchMode {
			if index < currentStoryPartIndex {
				return (.end, false)
			} else if index == currentStoryPartIndex {
				return (currentProgressPhase, true)
			} else {
				return (.start, false)
			}
		}
		
		let part = story.storyParts[index]
		if part.isCheckedOut || index < currentStoryPartIndex {
			return (.end, false)
		} else if index == currentStoryPartIndex {
			return (currentProgressPhase, !part.isCheckedOut)
		} else {
			return (.start, false)
		}
	}
}

// MARK: stories navigation
extension StoriesViewModel {
	func goToNextPartOrStory() {
		guard let story = currentStory else { return }
		// Помечаем текущую часть просмотренной (кроме режима повторного просмотра)
		setCheckedOut(storyIndex: currentStoryIndex, partIndex: currentStoryPartIndex, to: true)
		
		if currentStoryPartIndex < story.storyParts.count - 1 {
			currentStoryPartIndex += 1
		} else if currentStoryIndex < stories.count - 1 {
			let nextIndex = currentStoryIndex + 1
			currentStoryIndex = nextIndex
			// Определяем режим для новой сторис
			isRewatchMode = isStoryFullyViewed(in: stories, at: nextIndex)
			currentStoryPartIndex = isRewatchMode
			? 0
			: firstUnviewedPartIndex(for: nextIndex, in: stories)
		} else {
			performDismissView()
		}
	}
	
	func goToPrevPartOrStory() {
		if currentStoryPartIndex > 0 {
			if !isRewatchMode {
				setCheckedOut(storyIndex: currentStoryIndex, partIndex: currentStoryPartIndex, to: false)
				let targetIndex = currentStoryPartIndex - 1
				setCheckedOut(storyIndex: currentStoryIndex, partIndex: targetIndex, to: false)
				currentStoryPartIndex = targetIndex
			} else {
				currentStoryPartIndex -= 1
			}
		} else if currentStoryIndex > 0 {
			if !isRewatchMode {
				setCheckedOut(storyIndex: currentStoryIndex, partIndex: currentStoryPartIndex, to: false)
			}
			let prevIndex = currentStoryIndex - 1
			currentStoryIndex = prevIndex
			isRewatchMode = isStoryFullyViewed(in: stories, at: prevIndex)
			currentStoryPartIndex = isRewatchMode
			? 0
			: firstUnviewedPartIndex(for: prevIndex, in: stories)
		}
	}
}

// MARK: - Private

// MARK: Updating isCheckedOut status for concrete part
private extension StoriesViewModel {
	func setCheckedOut(storyIndex: Int, partIndex: Int, to isCheckedOut: Bool) {
		// Do not edit source data in rewatchMode
		guard !isRewatchMode else { return }
		guard stories.indices.contains(storyIndex) else { return }
		let story = stories[storyIndex]
		guard story.storyParts.indices.contains(partIndex) else { return }
		var parts = story.storyParts
		let old = parts[partIndex]
		parts[partIndex] = StoryPartModel(
			id: old.id,
			fullImageResource: old.fullImageResource,
			title: old.title,
			description: old.description,
			isCheckedOut: isCheckedOut
		)
		stories[storyIndex] = StoryModel(
			id: story.id,
			previewImageResource: story.previewImageResource,
			storyParts: parts
		)
	}
}

// MARK: reactive handlers (didSet observation)
private extension StoriesViewModel {
	func storyIndexDidChange() {
		// На случай внешней смены индекса
		isRewatchMode = isStoryFullyViewed(in: stories, at: currentStoryIndex) && currentStoryPartIndex == 0
		finishProgressAnimation()
		scheduleStartProgressAfterTick(restartTimer: true)
	}
	
	func storyPartIndexDidChange() {
		finishProgressAnimation()
		scheduleStartProgressAfterTick(restartTimer: true)
	}
}

// MARK: - Helpers
private extension StoriesViewModel {
	func firstUnviewedPartIndex(for storyIndex: Int, in stories: [StoryModel]) -> Int {
		guard stories.indices.contains(storyIndex) else { return 0 }
		let parts = stories[storyIndex].storyParts
		return parts.firstIndex(where: { !$0.isCheckedOut }) ?? 0
	}
	
	func isStoryFullyViewed(in stories: [StoryModel], at index: Int) -> Bool {
		guard stories.indices.contains(index) else { return false }
		return stories[index].storyParts.allSatisfy(\.isCheckedOut)
	}
	
	func scheduleStartProgressAfterTick(restartTimer shouldRestartTimer: Bool) {
		startProgressWorkItem?.cancel()
		if shouldRestartTimer { invalidateTimer() }
		let work = DispatchWorkItem { [weak self] in
			guard let self else { return }
			self.startProgressAnimation()
			if shouldRestartTimer { self.restartTimer() }
		}
		startProgressWorkItem = work
		DispatchQueue.main.async(execute: work)
	}
}

