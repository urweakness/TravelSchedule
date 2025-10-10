import SwiftUI

struct PanGestureOverlay: UIViewRepresentable {
	// --- internal properties ---
	var onChange: (CGFloat) -> Void
	var onEnd: (CGFloat, CGFloat) -> Void
	
	// --- view life cycles ---
	func makeUIView(context: Context) -> some UIView {
		let view = UIView()
		
		let panGesture = UIPanGestureRecognizer(
			target: context.coordinator,
			action: #selector(Coordinator.handlePan)
		)
		panGesture.delegate = context.coordinator
		
		let tapGesture = UITapGestureRecognizer(
			target: context.coordinator,
			action: #selector(Coordinator.handleTap)
		)
		tapGesture.delegate = context.coordinator
		
		view.addGestureRecognizer(panGesture)
		view.addGestureRecognizer(tapGesture)
		
		return view
	}

	func updateUIView(_ uiView: UIViewType, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(onChange: onChange, onEnd: onEnd)
	}
}

// MARK: - PanGestureOverlay Extensions
// MARK: Internal

// --- Coordinator ---
extension PanGestureOverlay {
	final class Coordinator: NSObject, UIGestureRecognizerDelegate {
		
		// --- internal properties ---
		var onChange: (CGFloat) -> Void
		var onEnd: (CGFloat, CGFloat) -> Void
		
		// --- internal init ---
		init(
			onChange: @escaping (CGFloat) -> Void,
			onEnd: @escaping (CGFloat, CGFloat) -> Void) {
				self.onChange = onChange
				self.onEnd = onEnd
			}
		
		// --- gesture handlers ---
		// pan gesture
		@objc func handlePan(_ gesture: UIPanGestureRecognizer) {
			switch gesture.state {
			case .changed:
				let height = gesture.translation(in: gesture.view).y
				onChange(height)
			case .ended:
				let velocity = gesture.velocity(in: gesture.view).y
				onEnd(-1, velocity)
			default:
				break
			}
		}
		
		// tap gesture
		@objc func handleTap(_ gesture: UITapGestureRecognizer) {
			switch gesture.state {
			case .ended:
				let xPos = gesture.location(in: gesture.view).x
				onEnd(xPos, 0)
			default:
				break
			}
		}
		
		// UIGestureRecognizerDelegate methods
		func gestureRecognizer(
			_ gestureRecognizer: UIGestureRecognizer,
			shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
		) -> Bool {
			true
		}
	}
}
