struct LazyHScrollView<Content: View>: View {
	
	let fakeCurrentStoryIndex: Int
	@Binding var yDragOffset: CGFloat
	var isScrolling: Binding<Bool>
	let storyDidShow: (Int) -> Void
	let animateContentTransition: Bool
	let handleTouch: (CGFloat, CGFloat) -> Void
	let alignemnt: VerticalAlignment = .center
	let spacing: CGFloat? = 0
	let content: (ScrollViewProxy) -> Content
	
	private let yVelocityThreshold: CGFloat = 1000
	private let coordinateSpaceName = UUID()
	
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			
			ScrollViewReader { proxy in
				ScrollView(.horizontal) {
					LazyHStack(
						alignment: alignemnt,
						spacing: spacing,
						content: {
							content(proxy)
								.frame(width: size.width)
								.scrollTransition { visualContent, phase in
									visualContent
										.rotation3DEffect(
											.degrees(phase.isIdentity ? 0 : phase.value * 45),
											axis: (x: 0, y: -1, z: 0)
										)
										.offset(x: -phase.value * size.width / 8)
								}
								.overlay(alignment: .bottom) {
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
					)
					.scrollTargetLayout()
					.onScrollPageChange(
						isScrolling: isScrolling,
						pageWidth: size.width,
						coordinateSpace: .named(coordinateSpaceName)
					) { page in
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
							storyDidShow(page)
						}
					}
					
				}
				.scrollDisabled(yDragOffset > 0)
				.coordinateSpace(.named(coordinateSpaceName))
				.scrollIndicators(.hidden)
				.scrollTargetBehavior(.paging)
				.onChange(of: fakeCurrentStoryIndex) { oldValue, newValue in
					withAnimation(animateContentTransition ? .easeInOut(duration: 0.3) : nil) {
						proxy.scrollTo(newValue, anchor: .center)
					}
				}
			}
			.offset(y: yDragOffset)
			.scaleEffect(1 - (yDragOffset / size.height))
		}
	}
}