struct PanGestureOverlayView: View {
	
	let size: CGSize
	let isScrolling: Binding<Bool>
	@Binding var yDragOffset: CGFloat
	let handleTouch: (CGFloat, CGFloat) -> Void
	
	private let yVelocityThreshold: CGFloat = 1000
	
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		PanGestureOverlay(
			onChange: { height in
				guard !isScrolling.wrappedValue else { return }
				yDragOffset = max(0, min(height, size.height * 0.3))
			},
			onEnd: { xPos, yVelocity in
				// --- reset yDragOffset value ---
				
				defer {
					withAnimation(
						.easeIn(duration: CGFloat.yDragOffsetAnimationTime)
					) {
						yDragOffset = 0
					}
				}
				
				if yVelocity >= yVelocityThreshold || yDragOffset ~= size.height * 0.3 {
					dismiss()
				}
				
				// --- touches only ---
				guard
					!isScrolling.wrappedValue,
					xPos > 0
				else { return }
				handleTouch(size.width, xPos)
			}
		)
		.frame(height: size.height * 0.88)
		.allowsHitTesting(!isScrolling.wrappedValue)
	}
}