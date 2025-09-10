import SwiftUI
import Combine

final class DragGestureObject: ObservableObject {
    
    /// Page spec direction
    enum PageSpec {
        /// Next page
        case next
        /// Previous page
        case prev
        /// Current page
        case none
    }
    
    var dismiss: (() -> Void)?
    var invalidateTimer: (() -> Void)?
    var performPage: ((PageSpec) -> Void)?
    var screenSize: (() -> CGSize)?
    
    @inline(__always)
    @Published private(set) var verticalDragValue: CGFloat = 0
    
    private let velocityThreshold: CGFloat = 1000
    
    private var cancellables = Set<AnyCancellable>()
    let dragGestureSubject = PassthroughSubject<(value: _ChangedGesture<DragGesture>.Value, isEnded: Bool), Never>()
    
    init() {
        setupBindings()
    }
    
    @inline(__always)
    var approximated: CGFloat {
        verticalDragValue / (screenSize?().height ?? .zero)
    }
    
    private func setupBindings() {
        
        // MARK: - verticalDragValue updater
        dragGestureSubject
            .removeDuplicates { $0.value == $1.value && $0.isEnded == $1.isEnded }
            .map { [weak self] data -> CGFloat in
                guard
                    let self,
                    let screenSize = screenSize?()
                else { return 0 }
                
                if data.isEnded {
                    return min(max(data.value.translation.height, 0), screenSize.height * 0.3)
                } else {
                    return 0
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.verticalDragValue, on: self)
            .store(in: &cancellables)
        
        // MARK: - Dismiss Handler
        dragGestureSubject
            .removeDuplicates { $0.value == $1.value && $0.isEnded == $1.isEnded }
            .filter { [weak self] data -> Bool in
                guard
                    let self,
                    data.isEnded
                else { return false }
                
                let isSwipeDown = data.value.velocity.height > self.velocityThreshold
                return approximated >= 0.3 || isSwipeDown
            }
            .sink { [weak self] _ in
                self?.invalidateTimer?()
                self?.dismiss?()
            }
            .store(in: &cancellables)
        
        // MARK: - Page Changing Handler
        dragGestureSubject
            .removeDuplicates { $0.value == $1.value && $0.isEnded == $1.isEnded }
            .map { [weak self] data -> PageSpec in
                guard
                    let self,
                    let screenSize = screenSize?(),
                    data.isEnded
                else { return .none }
                
                let width = data.value.translation.width
                let location = data.value.location
                
                guard width.isZero else {
                    if width > 0 {
                        return .prev
                    } else {
                        return .next
                    }
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
                self?.dragGestureSubject.send((value: value, isEnded: false))
            }
            .onEnded { [weak self] value in
                self?.dragGestureSubject.send((value: value, isEnded: true))
                self?.verticalDragValue = 0
            }
    }
}
