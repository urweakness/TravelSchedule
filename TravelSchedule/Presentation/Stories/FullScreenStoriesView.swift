import SwiftUI

struct FullScreenStoriesView: View {
    
    // MARK: - State Private Properties
    @State private var viewModel = StoriesViewModel()
    
    // MARK: - DI States
    @Environment(StoriesManager.self) private var manager
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    @ViewBuilder
    var body: some View {
        GeometryReader { geo in
			
            makeBackgroundView(size: geo.size)
                .onAppear { performStoriesManager(size: geo.size) }
            
			StoryContentView()
				.environment(viewModel)
			
        }
		.preferredColorScheme(.dark)
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
}

// MARK: Private Views
private extension FullScreenStoriesView {
	func makeBackgroundView(size: CGSize) -> some View {
		Color.travelWhite
			.ignoresSafeArea()
	}
}
