import SwiftUI

struct FullScreenStoriesView: View {
    
	// --- states ---
    @State private var viewModel: StoriesViewModel
	@State private var animateContentTransition = false
	@State private var isScrolling = false
	@State private var yDragOffset: CGFloat = 0

	// --- envs ---
	@Environment(StoriesManager.self) private var manager
    @Environment(\.dismiss) private var dismiss

	// --- raw init ---
    init() {
        // --- viewModel will be initialized in .onAppear ---
		_viewModel = State(
			wrappedValue: StoriesViewModel(manager: DummyStoriesManager())
		)
    }

	// --- body ---
    var body: some View {
        LazyHScrollView(
			yDragOffset: $yDragOffset,
			isScrolling: $isScrolling,
            fakeCurrentStoryIndex: viewModel.currentStoryIndex,
            storyDidShow: { idx in viewModel.setCurrentStory(index: idx) },
            animateContentTransition: animateContentTransition,
            handleTouch: handleTouch
        ) {
            ForEach(
                Array(viewModel.stories.enumerated()),
                id: \.element.id
            ) { index, story in
                StoryContentView(
                    story: story,
                    showProgress: index == viewModel.currentStoryIndex,
                    currentStoryPartIndex: index == viewModel.currentStoryIndex ? viewModel.currentStoryPartIndex : 0,
                    progress: index == viewModel.currentStoryIndex ? progressForCurrentStoryProgress(for: story) : 0
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
			// --- lazy manager init ---
			viewModel = StoriesViewModel(manager: manager)
			viewModel.dismiss = dismiss
            viewModel.timer.start()
			
			DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat.yDragOffsetAnimationTime) {
				animateContentTransition = true
			}
        }
        .onDisappear {
            viewModel.timer.stop()
        }
		// --- user interaction
		// --- called when next page position stopped and centered ---
		.onChange(of: isScrolling) {
			if isScrolling {
				viewModel.timer.pause()
			} else {
				viewModel.timer.resume()
			}
		}
		.onChange(of: yDragOffset) {
			if yDragOffset > 0 {
				viewModel.timer.pause()
			} else {
				DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat.yDragOffsetAnimationTime) {
					viewModel.timer.resume()
				}
			}
		}
    }
}

// MARK: - FullScreenStoriesView Extensions
// --- private helpers ---
private extension FullScreenStoriesView {
	func handleTouch(_ screenWidth: CGFloat, _ xPos: CGFloat) {
		if xPos >= screenWidth / 2 {
			viewModel.performNextStoryPart()
		} else {
			viewModel.performPrevStoryPart()
		}
	}
	
	func progressForCurrentStoryProgress(for story: StoryModel) -> CGFloat {
		let count = max(1, story.storyParts.count) // --- safe ---
		let partIndex = viewModel.currentStoryPartIndex
		let partProgress = viewModel.timer.progress
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

// MARK: - Dummy StoriesManagerProtocol implementation
fileprivate final class DummyStoriesManager: StoriesManagerProtocol {
	private(set) var stories = [StoryModel]()
	var currentStoryIndex: Int = 0
	
	func setStoryPartCheckedOutStatus(
		currentStoryIndex: Int,
		currentStoryPartIndex: Int,
	) {}
}
