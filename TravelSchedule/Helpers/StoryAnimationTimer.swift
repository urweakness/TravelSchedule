import Foundation

final class StoryAnimationTimer {
    
    // MARK: - Private Properties
    private var timer: Timer?
    
    // MARK: - Internal Methods
    func updateTimer(interval: TimeInterval, _ completion: @escaping () -> Void) {
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: false
        ) { [weak self] _ in
            guard let _ = self else {
                self?.invalidateTimer()
                return
            }
            completion()
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
