import SwiftUI
import Combine

@Observable
@MainActor
final class StoriesViewModel {
	
	// MARK: - Internal Properties
	@ObservationIgnored
    var screenSize: CGSize = .zero
	
    @ObservationIgnored
    var dismiss: DismissAction?

}

// MARK: - StoriesViewModel Extensions

// MARK: Internal

//MARK: viewDidAppear
extension StoriesViewModel {
	func viewDidAppear(
		dismiss: DismissAction,
		screenSize: CGSize
	) {
		self.dismiss = dismiss
		self.screenSize = screenSize
	}
}

// MARK: viewModel state managing
extension StoriesViewModel {
	func performDismissView() {
		dismiss?()
	}
}

// MARK: stories navigation
extension StoriesViewModel {

}

// MARK: - Private

// MARK: Updating isCheckedOut status for concrete part
private extension StoriesViewModel {

}

// MARK: - Helpers
private extension StoriesViewModel {

}

