import SwiftUI

struct FullScreenStoriesView: View {
    
	// --- states ---
    @State private var viewModel: StoriesViewModel
	@State private var animateContentTransition = false
	@State private var isScrolling = false
	@State private var yDragOffset: CGFloat = 0

	// --- envs ---
    @Environment(\.dismiss) private var dismiss

	// --- raw init ---
	init(manager: StoriesManager) {
		_viewModel = State(
			wrappedValue: StoriesViewModel(manager: manager)
		)
    }

	// --- body ---
    var body: some View {
		
        LazyHScrollView(
			yDragOffset: $yDragOffset,
			isScrolling: $isScrolling,
			storyIndex: viewModel.currentStoryIndex,
            storyDidShow: { idx in viewModel.setCurrentStory(index: idx) },
            animateContentTransition: animateContentTransition,
			handleTouch: viewModel.handleTouch
        ) {
            ForEach(
                Array(viewModel.stories.enumerated()),
                id: \.element.id
            ) { index, story in
				
				let data = viewModel.dataForStoryContentView(index: index, story: story)
				
                StoryContentView(
					story: story,
					showProgress: data.showProgress,
					currentStoryPartIndex: data.currentStoryPartIndex,
					progress: data.progress
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
			viewModel.dismiss = dismiss
            viewModel.timer.start()
			
			DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat.yDragOffsetAnimationTime) {
				animateContentTransition = true
			}
        }
        .onDisappear {
            viewModel.timer.stop()
        }
		// --- user interaction ---
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
