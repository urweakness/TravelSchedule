import SwiftUI
import Combine

@MainActor
@Observable
final class TimerManager {
	@ObservationIgnored
    private let timerTickInterval: TimeInterval
	@ObservationIgnored
    private let secondsPerStoryPart: TimeInterval

    private(set) var progress: CGFloat = 0
	@ObservationIgnored
    private var cancellable: Cancellable?
	@ObservationIgnored
    weak var delegate: TimerViewModelDelegate?

    init(
		secondsPerStoryPart: TimeInterval,
		timerTickInterval: TimeInterval = 0.05
	) {
        self.secondsPerStoryPart = secondsPerStoryPart
        self.timerTickInterval = timerTickInterval
    }

    func start() {
        stop()
        let publisher = Timer
            .publish(every: timerTickInterval, on: .main, in: .common)
            .autoconnect()
        cancellable = publisher.sink { [weak self] _ in
            self?.tick()
        }
    }

    func stop() {
        cancellable?.cancel()
        cancellable = nil
    }
	
	func pause() {
		cancellable?.cancel()
	}
	
	func resume() {
		let publisher = Timer
			.publish(every: timerTickInterval, on: .main, in: .common)
			.autoconnect()
		cancellable = publisher.sink { [weak self] _ in
			self?.tick()
		}
	}

    func reset() {
        stop()
        progress = 0
        start()
    }

    private func tick() {
        let progressPerTick = CGFloat(timerTickInterval / secondsPerStoryPart)
        progress += progressPerTick
        if progress >= 1.0 {
            progress = 1.0
            stop()
            delegate?.timerDidCompletePart()
        }
    }
}
