import SwiftUI
import Combine

final class DragGestureObject: ObservableObject {
    
    enum PageSpec {
        case next
        case prev
        case none
    }
    
	// MARK: - Internal Handlers
    var dismiss: (() -> Void)?
    var invalidateTimer: (() -> Void)?
    var performPage: ((PageSpec) -> Void)?
    var screenSize: (() -> CGSize)?
    
	// MARK: - Private(set) Properties
    @inline(__always)
	@Published private(set) var verticalDragValue: CGFloat = 0 {
        didSet {
			isDismissing = verticalDragValue > minimalDragThreshold
            verticalDragValueSubject.send(verticalDragValue)
        }
    }
	
	// MARK: - Internal Constants
    let verticalDragValueSubject = PassthroughSubject<CGFloat, Never>()
    
	// MARK: - Private Properties
    private var isDismissing: Bool = false
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Private Constants
	private let minimalDragThreshold: CGFloat = 20
    private let velocityThreshold: CGFloat = 1000
    private let dragGestureSubject = PassthroughSubject<(_ChangedGesture<DragGesture>.Value), Never>()
    
    init() {
        setupBindings()
    }
    
    @inlinable
    var approximated: CGFloat {
        verticalDragValue / (screenSize?().height ?? .zero )
    }
    
    private func setupBindings() {
        // MARK: - Dismiss Handler
        dragGestureSubject
            .removeDuplicates()
            .filter { [weak self] value -> Bool in
                guard let self else { return false }
                let isSwipeDown = value.velocity.height > self.velocityThreshold
                return approximated >= 0.3 || isSwipeDown
            }
            .sink { [weak self] _ in
                self?.invalidateTimer?()
                self?.dismiss?()
            }
            .store(in: &cancellables)
        
        // MARK: - Page Changing Handler
        dragGestureSubject
            .removeDuplicates()
            .map { [weak self] value -> PageSpec in
                guard
                    let self,
                    let screenSize = screenSize?(),
                    !isDismissing
                else { return .none }
                
                let width = value.translation.width
                let location = value.location
                
				if width > minimalDragThreshold || width < minimalDragThreshold {
                    return width > minimalDragThreshold ? .prev : .next
                }
                
                if location.x < screenSize.width / 2 {
                    return .prev
                } else {
                    return .next
                }
            }
            .sink { [weak self] pageSpec in
                self?.performPage?(pageSpec)
            }
            .store(in: &cancellables)
    }
    
    func makeStoryGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { [weak self] value in
                guard
                    let self,
                    let height = screenSize?().height
                else { return }

                verticalDragValue = min(max(value.translation.height, 0), height * 0.3)
            }
            .onEnded { [weak self] value in
                self?.dragGestureSubject.send(value)
                self?.verticalDragValue = 0
            }
    }
}
