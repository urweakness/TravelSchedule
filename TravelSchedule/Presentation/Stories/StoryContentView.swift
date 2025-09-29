import SwiftUI

struct StoryContentView: View {
	
	@StateObject private var dragGestureModel = DragGestureObject()
	@Environment(StoriesViewModel.self) private var viewModel
	
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
						.offset(y: dragGestureModel.verticalDragValue)
						.scaleEffect(1 - (dragGestureModel.verticalDragValue / (size.height)))
						.animation(
							dragGestureModel.verticalDragValue == 0 ?
								.linear(duration: 0.15) : nil,
							value: dragGestureModel.verticalDragValue
						)
						.animation(.default, value: currentPartIndex)
						.animation(.default, value: currentStoryIndex)
				}
				.frame(
					width: size.width,
					height: size.height,
					alignment: .center
				)
				.onAppear(perform: setupDragModelBindings)
				.gesture(dragGestureModel.makeStoryGesture())
			}
		}
	}
}


// MARK: - StoryView Extensions
// MARK: Private Methods
private extension StoryContentView {
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
