import Network
import Combine
import SwiftUI

@MainActor
@Observable
final class ConnectionMonitor {
	// --- observation state ---
	private(set) var isConnected = false
	
	// --- inner non observable constants ---
	@ObservationIgnored
	private let wifiMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
	@ObservationIgnored
	private let cellularMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
	@ObservationIgnored
	private let queue = DispatchQueue(label: "NetworkMonitor")
	
	// --- internal init ---
	init() {
		let handler: @Sendable (NWPath) -> Void = { [weak self] _ in
			Task { @MainActor in
				self?.update()
			}
		}

		wifiMonitor.pathUpdateHandler = handler
		cellularMonitor.pathUpdateHandler = handler

		wifiMonitor.start(queue: queue)
		cellularMonitor.start(queue: queue)
	}
	
	// --- private methods ---
	private func update() {
		let wifi = wifiMonitor.currentPath.status == .satisfied
		let cell = cellularMonitor.currentPath.status == .satisfied
		isConnected = wifi || cell
	}
	
	// --- deinit ---
	deinit {
		wifiMonitor.cancel()
		cellularMonitor.cancel()
	}
}
