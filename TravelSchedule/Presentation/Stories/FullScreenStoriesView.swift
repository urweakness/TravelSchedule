import SwiftUI

struct FullScreenStoriesView: View {
    
    // MARK: - State Private Properties
    @State private var viewModel = StoriesViewModel()
	@StateObject private var dragGestureModel = DragGestureObject()
    
    // MARK: - DI States
    @Environment(StoriesManager.self) private var manager
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    @ViewBuilder
    var body: some View {
        GeometryReader { geo in
			
            makeBackgroundView(size: geo.size)
                .onAppear { performStoriesManager(size: geo.size) }
            
			StoryContentView(
				makeStoryGesture: dragGestureModel.makeStoryGesture,
				verticalDragValue: dragGestureModel.verticalDragValue,
				size: geo.size
			)
			.environment(viewModel)
			
        }
		.preferredColorScheme(.dark)
		.onAppear {
			setupDragModelBindings()
		}
        // Sync local VM changes with shared StoriesManager
        .onChange(of: viewModel.stories) { _, updated in
            manager.apply(updatedStories: updated)
        }
        .onDisappear {
            manager.apply(updatedStories: viewModel.stories)
        }
    }
}

// MARK: - StoryView Extensions
// MARK: Private Methods
private extension FullScreenStoriesView {
    func performStoriesManager(size: CGSize) {
        let currentStoryIndex = manager.currentStoryIndex
        let stories = manager.stories
        
        viewModel.viewDidAppear(
            dismiss: dismiss,
            screenSize: size,
            storyIndex: currentStoryIndex,
            stories: stories
        )
    }
    
    func setupDragModelBindings() {
        dragGestureModel.dismiss = { [weak viewModel] in
            viewModel?.performDismissView()
        }
        dragGestureModel.invalidateTimer = { [weak viewModel] in
            viewModel?.invalidateTimer()
        }
        dragGestureModel.performPage = { [weak viewModel] spec in
            guard let viewModel else { return }
            switch spec {
            case .none:
                break
            case .next:
                viewModel.goToNextPartOrStory()
            case .prev:
                viewModel.goToPrevPartOrStory()
            }
        }
        dragGestureModel.screenSize = { [viewModel] in
            viewModel.screenSize
        }
    }
}

// MARK: Private Views
private extension FullScreenStoriesView {
	func makeBackgroundView(size: CGSize) -> some View {
		Color.travelWhite
			.opacity(1.0 - dragGestureModel.approximated)
			.ignoresSafeArea()
	}
}
