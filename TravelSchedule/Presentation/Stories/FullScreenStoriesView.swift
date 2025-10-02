import SwiftUI
import Combine

#warning("TODO: refactor this god object")
struct FullScreenStoriesView: View {
	
	// --- timer ---
	struct Configuration {
		let timerTickInterval: TimeInterval
		let progressPerTick: CGFloat
		
		init(
			storiesCount: Int,
			secondsPerStory: TimeInterval = 5,
			timerTickInterval: TimeInterval = 0.05
		) {
			self.timerTickInterval = timerTickInterval
			self.progressPerTick = 1.0 / CGFloat(storiesCount) / secondsPerStory * timerTickInterval
		}
	}
	
	@State private var progress: CGFloat = 0
	@State private var timer = Timer.publish(every: 0, on: .main, in: .common)
	@State private var cancellable: Cancellable?
	
	@State private var timerConfig: Configuration
	
	// --- data ---
	@Environment(StoriesManager.self) private var manager
	
	@State private var stories = [StoryModel]()
	@State private var fakeCurrentStoryIndex: Int = 0
	@State private var currentStoryIndex: Int = 0
	@State private var currentStoryPartIndex: Int = 0
	
	// --- user interaction ----
	@State private var animateContentTransition: Bool = false
	@State private var yDragOffset: CGFloat = 0
	@State private var isScrolling: Bool = false
	
	@Environment(\.dismiss) private var dismiss
	
	init() {
		timerConfig = .init(storiesCount: mockStories.first?.storyParts.count ?? 0)
	}
	
	var body: some View {
		LazyHScrollView(
			yDragOffset: $yDragOffset,
			isScrolling: $isScrolling,
			fakeCurrentStoryIndex: fakeCurrentStoryIndex,
			storyDidShow: storyDidShow,
			animateContentTransition: animateContentTransition,
			handleTouch: handleTouch
		) {
			ForEach(
				Array(stories.enumerated()),
				id: \.element.id
			) { index, story in
				StoryContentView(
					story: story,
					showProgress: index == currentStoryIndex,
					currentStoryPartIndex: currentStoryPartIndex,
					progress: progress
				)
				.id(index)
			}
		}
		.preferredColorScheme(.dark)
		.background {
			Color.travelWhite
				.ignoresSafeArea()
		}
		.onAppear {
			stories = manager.stories
			currentStoryIndex = manager.currentStoryIndex
			fakeCurrentStoryIndex = currentStoryIndex
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
				animateContentTransition = true
			}
		}
		// --- sync local stories with global env ---
		.onChange(of: stories) {
			manager.apply(updatedStories: stories)
		}
		
		// --- user interaction
		// --- called when next page position stopped and centered ---
		.onChange(of: isScrolling) {
			if isScrolling {
				dismissTimer()
			} else {
				resetTimer()
			}
		}
		.onChange(of: yDragOffset) {
			if yDragOffset > 0 {
				dismissTimer()
			} else {
				DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat.yDragOffsetAnimationTime) {
					resetTimer()
				}
			}
		}
		
		// --- timer ---
		.onAppear {
			resetTimer()
		}
		.onDisappear(perform: dismissTimer)
		.onReceive(timer) { _ in
			timerTick()
		}
		.onChange(of: currentStoryIndex) { _, newValue in
			updateTimerConfig(with: newValue)
		}
		.onChange(of: progress) {
			guard let story = stories[safe: currentStoryIndex] else { return }
			let partFullProgress = 1 / CGFloat(story.storyParts.count)
			
			if Float(progress.truncatingRemainder(dividingBy: partFullProgress)) == (
				Float(partFullProgress) - 0.005
			) {
				performNextStoryPart()
			}
		}
	}
}

// MARK: - FullScreenStoriesView Extensions
// MARK: Private

// MARK: - helpers
private extension FullScreenStoriesView {
	// --- currentStoryIndex sync with fakeStoryIndex
	func storyDidShow(_ storyIndex: Int) {
		currentStoryIndex = storyIndex
		progress = 0
		currentStoryPartIndex = 0
		resetTimer()
	}
	
	// --- showing first storypart if provided index is not a currentStoryIndex ---
	func storyPartAt(storyIndex: Int) -> StoryPartModel? {
		let story = stories[storyIndex]
		
		if storyIndex == fakeCurrentStoryIndex {
			return story.storyParts[safe: currentStoryPartIndex]
		} else {
			return story.storyParts.first
		}
	}
	
	func setStoryPartCheckedOutStatus() {
		guard let storyPart = stories[safe: currentStoryIndex]?.storyParts[safe: currentStoryPartIndex] else { return }
		stories[currentStoryIndex].storyParts[currentStoryPartIndex] = storyPart.invertedCheckedOutStatus(to: true)
	}
	
	func handleTouch(
		_ screenWidth: CGFloat,
		_ xPos: CGFloat
	) {
		if xPos >= screenWidth / 2 {
			performNextStoryPart()
		} else {
			performPrevStoryPart()
		}
	}
}

// MARK: - stories routing
private extension FullScreenStoriesView {
	func performNextStory() {
		if stories.indices.contains(fakeCurrentStoryIndex + 1) {
			dismissTimer()
			progress = 1
			progress = 1
			currentStoryPartIndex = 0
			fakeCurrentStoryIndex += 1
		} else {
			dismiss()
		}
	}
	
	func performNextStoryPart() {
		setStoryPartCheckedOutStatus()
		
		guard let currentStory = stories[safe: fakeCurrentStoryIndex] else {
			return
		}
		
		if currentStory.storyParts.indices.contains(currentStoryPartIndex + 1) {
			currentStoryPartIndex += 1
			recalcProgress()
		} else {
			performNextStory()
		}
	}
	
	func performPrevStory() {
		fakeCurrentStoryIndex = max(0, fakeCurrentStoryIndex - 1)
	}
	
	func performPrevStoryPart() {
		guard let currentStory = stories[safe: fakeCurrentStoryIndex] else {
			return
		}
		
		if currentStory.storyParts.indices.contains(currentStoryPartIndex - 1) {
			currentStoryPartIndex -= 1
			recalcProgress()
		} else {
			performPrevStory()
		}
	}
}

// MARK: - timer managment
private extension FullScreenStoriesView {
	func recalcProgress() {
		dismissTimer()
		defer {
			resetTimer()
		}
		
		guard let currentStory = stories[safe: currentStoryIndex] else {
			return
		}
		let storyPartCount = currentStory.storyParts.count
		let storyPartFullProgress = 1 / CGFloat(storyPartCount)
		
		progress = storyPartFullProgress * CGFloat(currentStoryPartIndex)
	}
	
	func timerTick() {
		let nextProgress = progress + timerConfig.progressPerTick
		progress = nextProgress
	}
	
	func dismissTimer() {
		cancellable?.cancel()
		cancellable = nil
	}
	
	func resetTimer() {
		cancellable?.cancel()
		timer = createTimer(configuration: timerConfig)
		cancellable = timer.connect()
	}
	
	func createTimer(configuration: Configuration) -> Timer.TimerPublisher {
		Timer.publish(every: configuration.timerTickInterval, on: .main, in: .common)
	}
	
	func updateTimerConfig(with storyIndex: Int) {
		guard let story = stories[safe: storyIndex] else { return }
		let storyPartsCount = story.storyParts.count
		timerConfig = .init(
			storiesCount: storyPartsCount
		)
	}
}
