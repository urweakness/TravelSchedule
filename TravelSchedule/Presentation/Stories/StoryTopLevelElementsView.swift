import SwiftUI

struct StoryTopLevelElementsView: View {
	
	private let storyID: String
	private let storyPartsCount: Int
	
	@Environment(StoriesViewModel.self) private var viewModel
	
	init(storyID: String, storyPartsCount: Int) {
		self.storyID = storyID
		self.storyPartsCount = storyPartsCount
	}
	
	var body: some View {
		makeTopElementsView(
			storyID: storyID,
			storyPartsCount: storyPartsCount
		)
	}
	
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
