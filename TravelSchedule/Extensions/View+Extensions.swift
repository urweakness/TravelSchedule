import SwiftUI

// MARK: - View Extensions
extension View {
	func customNavigationBackButton(pop: @escaping () -> Void) -> some View {
		modifier(CustomNavigationBackButton(pop: pop))
    }
	
	func onScrollPageChange(
		isScrolling: Binding<Bool>,
		pageWidth: CGFloat,
		coordinateSpace: CoordinateSpace,
		onPageChange: @escaping (Int) -> Void
	) -> some View {
		modifier(
			HPageTrackingModifier(
				pageWidth: pageWidth,
				onPageChange: onPageChange,
				coordinateSpace: coordinateSpace,
				isScrolling: isScrolling
			)
		)
	}
}


// MARK: - Private Helper for LazyHScrollView
// --- preference ---
private struct ScrollOffsetPreferenceKey: PreferenceKey {
	static let defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

// --- view modifier ---
private struct HPageTrackingModifier: ViewModifier {
	let pageWidth: CGFloat
	let onPageChange: (Int) -> Void
	let coordinateSpace: CoordinateSpace
	
	@Binding var isScrolling: Bool
	@State private var lastPage: Int = 0
	
	func body(content: Content) -> some View {
		content
			.overlay(
				GeometryReader { geo in
					Color.clear.preference(
						key: ScrollOffsetPreferenceKey.self,
						value: geo.frame(in: coordinateSpace).minX
					)
				}
			)
			.onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
				let row = abs(offset) / pageWidth
				
				if row.truncatingRemainder(dividingBy: 1) == 0 {
					let page = Int(row)
					
					isScrolling = false
					
					if page != lastPage {
						lastPage = page
						onPageChange(page)
					}
				} else {
					isScrolling = true
				}
			}
	}
}
