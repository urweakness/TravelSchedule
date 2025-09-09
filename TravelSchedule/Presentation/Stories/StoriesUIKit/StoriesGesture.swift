import UIKit

final class StoriesGesture: NSObject {
    
    private(set) lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handlePanGesture))
        return gesture
    }()
    
    private(set) lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(handleTapGesture))
        return gesture
    }()
    
    var trySetPreviousStory: (() -> Void)?
    var trySetNextStory: (() -> Void)?
    var restoreViewNormalState: (() -> Void)?
    var dismiss: (() -> Void)?
    
    var screenSize: CGSize?
    
    var location: ((UIGestureRecognizer) -> CGPoint)?
    var translation: ((UIPanGestureRecognizer) -> CGPoint)?
    var velocity: ((UIPanGestureRecognizer) -> CGPoint)?
    
    private let velocityThreshold: CGFloat = 1000
    private var storyTimelineTimer: Timer?
    private var verticalDragValue: CGFloat = 0
    
    @inline(__always)
    var approximatedVerticalDragValue: CGFloat {
        verticalDragValue / (screenSize?.height ?? 1)
    }
    
    private func setVerticalDragValue(_ value: CGFloat) {
        verticalDragValue = value
    }
    
    private func handlePanGestureEnded() {
        guard
            let startPoint = location?(panGesture),
            let endPoint = translation?(panGesture),
            let velocityY = velocity?(panGesture).y
        else { return }
        
        let startY = startPoint.y
        let endY = endPoint.y
        let startX = startPoint.x
        let endX = endPoint.x
        
        let translationY = startY - endY
        let translationX = startX - endX
        setVerticalDragValue(abs(translationY))
        
        handleDragGesture(
            translation: .init(
                x: translationX,
                y: translationY
            ),
            velocityY: velocityY,
            endX: endX
        )
        
        if verticalDragValue == 0 {
            verticalDragValue = 0
        }
        
        restoreViewNormalState?()
    }
    
    private func tapGestureEnded(_ gesture: UITapGestureRecognizer) {
        guard let location = location?(gesture) else { return }
        
        if location.x > (screenSize?.width ?? 0) / 2 {
            trySetPreviousStory?()
        } else {
            trySetNextStory?()
        }
    }
    
    private func handleDragGesture(
        translation: CGPoint,
        velocityY: CGFloat,
        endX: CGFloat
    ) {
        let isSwipeDown = translation.y > 0 || velocityY >= velocityThreshold
        if isSwipeDown {
            dismiss?()
            return
        }
        
        guard translation.x.isZero else {
            if translation.x > 0 {
                trySetPreviousStory?()
            } else {
                trySetNextStory?()
            }
            return
        }
    }
    
    private func panGestureChanged(_ gesture: UIPanGestureRecognizer) {
        guard
            let startPoint = location?(gesture),
            let endPoint = translation?(gesture)
        else { return }
        
        let startY = startPoint.y
        let endY = endPoint.y
        
        let translationY = startY - endY
        setVerticalDragValue(abs(translationY))
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .possible:
            fallthrough
        case .began:
            fallthrough
        case .changed:
            fallthrough
        case .ended:
            tapGestureEnded(gesture)
        case .cancelled:
            break
        case .failed:
            break
        case .recognized:
            break
        @unknown default:
            break
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .possible:
            fallthrough
        case .began:
            panGestureChanged(gesture)
        case .changed:
            panGestureChanged(gesture)
        case .ended:
            handlePanGestureEnded()
        case .cancelled:
            restoreViewNormalState?()
        case .failed:
            restoreViewNormalState?()
        case .recognized:
            break
        @unknown default:
            break
        }
    }
}
