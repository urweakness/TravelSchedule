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
            
            if let currentStory = viewModel.currentStory {
                
                let storyParts = currentStory.storyParts
                let currentPartIndex = viewModel.currentStoryPartIndex
                
                if storyParts.indices.contains(currentPartIndex) {
                    let storyPart = storyParts[currentPartIndex]
                    ZStack {
                        StoryPartView(storyPart: storyPart)
                            .frame(width: geo.size.width)
                            .gesture(viewModel.makeDragGesture())
                            .overlay(alignment: .top) {
                                makeTopElementsView(
                                    storyID: currentStory.id,
                                    storyPartsCount: currentStory.storyParts.count
                                )
                            }
                            .offset(y: viewModel.verticalDragValue)
                            .scaleEffect(1 - viewModel.approximatedVerticalDragValue)
                            .animation(.default, value: viewModel.verticalDragValue)
                            .animation(.default, value: viewModel.currentStoryPartIndex)
                            .animation(.default, value: viewModel.currentStoryIndex)
                    }
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height,
                        alignment: .center
                    )
                }
                
            }
        }
		// Sync local VM changes with shared StoriesManager
        .onChange(of: viewModel.stories) { _, updated in
            manager.apply(updatedStories: updated)
        }
        .onDisappear {
            manager.apply(updatedStories: viewModel.stories)
        }
        .preferredColorScheme(.dark)
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
    func makeTopElementsView(
        storyID: String,
        storyPartsCount: Int
    ) -> some View {
        VStack(alignment: .trailing, spacing: 16) {
            makeTimeIndicatorView(
                storyID: storyID,
                storyPartsCount: storyPartsCount
            )
            closeButtonView
        }
        .padding(.top, 28)
    }
    
    func makeBackgroundView(size: CGSize) -> some View {
        Color.travelWhite
            .opacity(1.0 - viewModel.approximatedVerticalDragValue)
            .ignoresSafeArea()
    }
    
    func makeTimeIndicatorView(
        storyID: String,
        storyPartsCount: Int
    ) -> some View {
        HStack(spacing: 6) {
            ForEach(0..<storyPartsCount, id: \.self) { index in
                let state = viewModel.progressState(for: index)
                StoriesProgressView(
                    currentProgressPhase: state.phase,
                    animationTimeout: viewModel.storyTimeout,
                    isAnimated: state.isAnimated
                )
            }
        }
		// Link id to story & to current story part & to runID
		// which increments in every animation start
        .id("\(storyID)-\(viewModel.currentStoryPartIndex)-\(viewModel.progressRunID)")
        .padding(.horizontal, 12)
    }
    
    var closeButtonView: some View {
        Button(action: viewModel.performDismissView) {
            Circle()
                .fill(.travelWhite)
                .overlay {
                    Image(systemName: "xmark")
                        .resizable()
                        .font(.bold34)
                        .foregroundStyle(.white)
                        .frame(width: 10, height: 10)
                }
                .frame(width: 30, height: 30)
                .shadow(color: .white.opacity(0.2), radius: 5)
        }
        .frame(width: 24, height: 24)
        .padding(.trailing, 16)
    }
}
