import SwiftUI

struct StoryContentView: View {
	// --- internal constants ---
	let story: StoryModel
	let showProgress: Bool
	let currentStoryPartIndex: Int
	let progress: CGFloat
	
	// --- body ---
	@ViewBuilder
	var body: some View {
		if let storyPart = story.storyParts[safe: currentStoryPartIndex] {
			StoryPartView(storyPart: storyPart)
				.overlay(alignment: .topLeading) {
					VStack(
						alignment: .trailing,
						spacing: 16
					) {
						progressView
							.frame(height: .progressBarHeight)
							.padding(.horizontal, 8)
						
						CloseButtonView()
						Spacer()
					}
					.safeAreaPadding(.top)
					.padding(.top, 16)
				}
		}
	}
	
	// --- private subviews ---
	private var progressView: some View {
		Group {
			let storyPartsCount = story.storyParts.count
			
			if showProgress {
				StoriesProgressView(
					storyPartsCount: storyPartsCount,
					progress: progress
				)
			} else {
				ProgressBar(
					storyPartsCount: storyPartsCount,
					progress: 0
				)
			}
		}
	}
}
