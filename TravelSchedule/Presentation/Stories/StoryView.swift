import SwiftUI

#Preview {
    StoryView()
        .environmentObject(Coordinator())
        .environmentObject(StoriesManager())
}

//struct StoryView: View {
//    
//    @StateObject private var viewModel = StoriesUIKitViewModel()
//    let gesture = StoriesPanGesture()
//    
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject private var storiesViewModel: StoriesViewModel
//    
//    var body: some View {
//        GeometryReader {
//            StoryViewRepresentable(
//                viewModel: viewModel,
//                gesture: gesture,
//                screenSize: $0.size
//            )
//            .onAppear {
//                storiesViewModel.currentStoryIndex = 0
//                viewModel.currentStoryIndex = storiesViewModel.currentStoryIndex
//            }
//        }
//    }
//}

struct StoryView: View {
    
    // MARK: - State Private Properties
    @StateObject private var viewModel = StoriesViewModel()
    
    // MARK: - Enviroments
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var storiesManager: StoriesManager
    
    // MARK: - Body
    @ViewBuilder
    var body: some View {
        GeometryReader {
            let size = $0.size

            makeBackgroundView(size: size)
                .onAppear { performStoriesManager(size: size) }

            if let currentStory = viewModel.currentStory {
                imageView(imageResource: currentStory.fullImageResource)
                    .frame(
                        width: size.width,
                        height: size.height,
                        alignment: .center
                    )
                    .overlay(alignment: .top) {
                        topElementsView
                    }
                    .overlay(alignment: .bottom) {
                        makeBottomElementsView(currentStory)
                    }
                    .gesture(
                        viewModel.dragGestureModel.makeStoryGesture()
                    )
                    .offset(y: viewModel.dragGestureModel.verticalDragValue)
                    .scaleEffect(1 - viewModel.dragGestureModel.approximated)
                    .animation(.interactiveSpring, value: viewModel.dragGestureModel.verticalDragValue)
                    .animation(.interactiveSpring, value: viewModel.currentStory)
                    .animation(.interactiveSpring, value: viewModel.stories)
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - StoryView Extensions
// MARK: Private Methods
private extension StoryView {
    func performStoriesManager(size: CGSize) {
        let currentStoryIndex = storiesManager.currentStoryIndex
        let stories = storiesManager.stories
        
        viewModel.viewDidAppear(
            screenSize: size,
            storyIndex: currentStoryIndex,
            stories: stories
        )
    }
}

// MARK: Private Views
private extension StoryView {
    func makeBottomElementsView(_ story: StoryModel) -> some View {
        VStack(spacing: 16) {
            titleView(title: story.title)
            descriptionView(description: story.description)
        }
        .padding(.bottom, 40)
    }
    
    var topElementsView: some View {
        VStack(alignment: .trailing, spacing: 16) {
            timeIndicatorView()
            closeButtonView
        }
        .padding(.top, 28)
    }
    
    func makeBackgroundView(size: CGSize) -> some View {
        Color.travelWhite
            .opacity(1.0 - viewModel.dragGestureModel.approximated)
            .onAppear { performStoriesManager(size: size) }
            .ignoresSafeArea()
    }
    
    var closeButtonView: some View {
        Button(action: viewModel.dismissView) {
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
    
    func timeIndicatorView() -> some View {
        HStack(spacing: 6) {
            ForEach(0..<(viewModel.stories?.count ?? 0), id: \.self) { index in
                progressView(storyIndex: index)
            }
        }
        .padding(.horizontal, 12)
    }
    
    func progressView(storyIndex: Int) -> some View {
        ProgressView(
            value: viewModel.progressValue(storyIndex: storyIndex),
            total: 1.0
        )
        .progressViewStyle(TravelScheduleStoryProgressViewStyle())
    }
    
    func titleView(title: String) -> some View {
        Text(title)
            .font(.bold34)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 16)
            .lineLimit(2)
            .contentTransition(.numericText())
    }
    
    func descriptionView(description: String) -> some View {
        Text(description)
            .font(.regular20)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 16)
            .lineLimit(3)
            .contentTransition(.numericText())
    }
    
    func imageView(imageResource: ImageResource) -> some View {
        Image(imageResource)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 40))
    }
}
