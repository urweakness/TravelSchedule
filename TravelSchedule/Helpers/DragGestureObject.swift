import SwiftUI
import Combine

@Observable
@MainActor
final class DragGestureObject {
    
    enum PageSpec {
        case next
        case prev
        case none
    }
    
    @ObservationIgnored
    var dismiss: (() -> Void)?
    @ObservationIgnored
    var invalidateTimer: (() -> Void)?
    @ObservationIgnored
    var performPage: ((PageSpec) -> Void)?
    @ObservationIgnored
    var screenSize: (() -> CGSize)?
    
    @inline(__always)
    private(set) var verticalDragValue: CGFloat = 0 {
        didSet {
            verticalDragValueSubject.send(verticalDragValue)
            isDismissing = verticalDragValue > 0
        }
    }
    let verticalDragValueSubject = PassthroughSubject<CGFloat, Never>()
    
    @ObservationIgnored
    private var isDismissing: Bool = false

    private let velocityThreshold: CGFloat = 1000
    
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
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
                
                if abs(width) > 24 {
                    return width > 0 ? .prev : .next
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
