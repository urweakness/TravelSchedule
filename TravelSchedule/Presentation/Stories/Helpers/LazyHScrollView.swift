import SwiftUI

struct LazyHScrollView<Content: View>: View {
	
	// --- binding properties ---
	@Binding var yDragOffset: CGFloat
	var isScrolling: Binding<Bool>
	
	// --- internal constants ---
	let fakeCurrentStoryIndex: Int
	let storyDidShow: (Int) -> Void
	let animateContentTransition: Bool
	let handleTouch: (CGFloat, CGFloat) -> Void
	let alignemnt: VerticalAlignment = .center
	let spacing: CGFloat? = 0
	let content: () -> Content
	
	// --- private constants ---
	private let coordinateSpaceName = UUID()
	
	// --- envs ---
	@Environment(\.dismiss) private var dismiss
	
	// --- body ---
	var body: some View {
		GeometryReader {
			let size = $0.size
			
			ScrollViewReader { proxy in
				ScrollView(.horizontal) {
					LazyHStack(
						alignment: alignemnt,
						spacing: spacing,
						content: {
							content()
								.frame(width: size.width)
								.applyScrollTransition(size: size)
								.overlay(alignment: .bottom) {
									PanGestureOverlayView(
										size: size,
										isScrolling: isScrolling,
										yDragOffset: $yDragOffset,
										handleTouch: handleTouch
									)
								}
						}
					)
					.scrollTargetLayout()
					.onScrollPageChange(
						isScrolling: isScrolling,
						pageWidth: size.width,
						coordinateSpace: .named(coordinateSpaceName)
					) { page in
						scrollPageDidChange(to: page)
					}
					
				}
				.applyScrollSettings()
				.scrollDisabled(yDragOffset > 0)
				.coordinateSpace(.named(coordinateSpaceName))
				.onChange(of: fakeCurrentStoryIndex) { _, newValue in
					fakeIndexDidChange(
						to: newValue,
						proxy: proxy
					)
				}
			}
			.offset(y: yDragOffset)
			.scaleEffect(1 - (yDragOffset / size.height))
		}
	}
}

// MARK: - LazyHScrollView Extensions
// MARK: Private

// --- helpers ---
private extension LazyHScrollView {
	func scrollPageDidChange(to page: Int) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			storyDidShow(page)
		}
	}
	
	func fakeIndexDidChange(
		to index: Int,
		proxy: ScrollViewProxy
	) {
		withAnimation(animateContentTransition ? .easeInOut(duration: 0.3) : nil) {
			proxy.scrollTo(index, anchor: .center)
		}
	}
}

// MARK: - View Extensions
// MARK: Private

// --- incapsulation ---
private extension View {
	func applyScrollSettings() -> some View {
		self
			.scrollIndicators(.hidden)
			.scrollTargetBehavior(.paging)
	}
	
	func applyScrollTransition(size: CGSize) -> some View {
		self
			.scrollTransition { visualContent, phase in
				visualContent
					.rotation3DEffect(
						.degrees(phase.isIdentity ? 0 : phase.value * 45),
						axis: (x: 0, y: -1, z: 0)
					)
					.offset(x: -phase.value * size.width / 8)
			}
	}
}
