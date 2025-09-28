import SwiftUI

struct StoryContentView<G: Gesture>: View {
	
	private let makeStoryGesture: () -> G
	private let verticalDragValue: CGFloat
	
	@Environment(StoriesViewModel.self) private var viewModel
	
	init(
		makeStoryGesture: @escaping () -> G,
		verticalDragValue: CGFloat
	) {
		self.makeStoryGesture = makeStoryGesture
		self.verticalDragValue = verticalDragValue
	}
	
	@ViewBuilder
	var body: some View {
		let size = viewModel.screenSize
		
		if let currentStory = viewModel.currentStory {
			let storyParts = currentStory.storyParts
			let currentStoryIndex = viewModel.currentStoryIndex
			let currentPartIndex = viewModel.currentStoryPartIndex
			
			if let storyPart = storyParts[safe: currentPartIndex] {
				
				ZStack {
					StoryPartView(storyPart: storyPart)
						.frame(width: size.width)
						.overlay(alignment: .top) {
							StoryTopLevelElementsView(
								storyID: currentStory.id,
								storyPartsCount: currentStory.storyParts.count
							)
						}
						.offset(y: verticalDragValue)
						.scaleEffect(1 - (verticalDragValue / (size.height)))
						.animation(
							verticalDragValue == 0 ? .linear(duration: 0.15) : nil,
							value: verticalDragValue
						)
						.animation(.default, value: currentPartIndex)
						.animation(.default, value: currentStoryIndex)
				}
				.frame(
					width: size.width,
					height: size.height,
					alignment: .center
				)
				.gesture(makeStoryGesture())
			}
		}
	}
}
