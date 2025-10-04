import SwiftUI

struct StoriesProgressView: View {
	// --- internal constants ---
	let storyPartsCount: Int
	let progress: CGFloat
	
	// --- body ---
    var body: some View {
		ProgressBar(
			storyPartsCount: storyPartsCount,
			progress: progress
		)
    }
}
