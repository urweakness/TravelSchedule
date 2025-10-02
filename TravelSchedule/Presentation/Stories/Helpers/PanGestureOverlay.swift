struct PanGestureOverlay: UIViewRepresentable {
	var onChange: (CGFloat) -> Void
	var onEnd: (CGFloat, CGFloat) -> Void
	
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
	
	final class Coordinator: NSObject, UIGestureRecognizerDelegate {
		var onChange: (CGFloat) -> Void
		var onEnd: (CGFloat, CGFloat) -> Void
		
		init(
			onChange: @escaping (CGFloat) -> Void,
			onEnd: @escaping (CGFloat, CGFloat) -> Void) {
			self.onChange = onChange
			self.onEnd = onEnd
		}
		
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
		
		@objc func handleTap(_ gesture: UITapGestureRecognizer) {
			switch gesture.state {
			case .ended:
				let xPos = gesture.location(in: gesture.view).x
				onEnd(xPos, 0)
			default:
				break
			}
		}
		
		func gestureRecognizer(
			_ gestureRecognizer: UIGestureRecognizer,
			shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
		) -> Bool {
			true
		}
	}
}