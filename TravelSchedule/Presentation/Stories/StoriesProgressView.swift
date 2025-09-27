import SwiftUI

struct StoriesProgressView: View {
	
	// MARK: - Private(set) Properties
    private(set) var currentProgressPhase: StoryAnimationPhase
	
	// Whether to enable the fill animation (for current part and only if there is no isCheckedOut)
	private(set) var isAnimated: Bool
	
	// MARK: - Private Constants
    private let animationTimeout: TimeInterval
    
	// MARK: - Private States
    @State private var displayedValue: CGFloat = 0
	
	// MARK: - Internal Init
	init(
		currentProgressPhase: StoryAnimationPhase,
		animationTimeout: TimeInterval,
		isAnimated: Bool
	) {
		self.currentProgressPhase = currentProgressPhase
		self.animationTimeout = animationTimeout
		self.isAnimated = isAnimated
	}
    
	// MARK: - Body
    var body: some View {
        ProgressView(value: displayedValue, total: 1)
            .progressViewStyle(TravelScheduleStoryProgressViewStyle())
            .onAppear { syncDisplayedValue() }
            .onChange(of: currentProgressPhase) {
                syncDisplayedValue()
            }
            .onChange(of: isAnimated) {
                syncDisplayedValue()
            }
    }
    
	// MARK: - Private Methods
    private func syncDisplayedValue() {
        switch currentProgressPhase {
        case .start:
            displayedValue = 0
        case .end:
            if isAnimated {
                withAnimation(.linear(duration: animationTimeout)) {
                    displayedValue = 1
                }
            } else {
                displayedValue = 1
            }
        }
    }
}
