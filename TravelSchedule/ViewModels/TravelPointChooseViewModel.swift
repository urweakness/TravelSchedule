import Combine
import SwiftUI

final class TravelPointChooseViewModel<D: TravelPoint>: ObservableObject {
	
	// MARK: - Private Constants
    private let travelPoints = D.allCases

	// MARK: - Published States
	// init filteredObject with all points (to avoid initial debounce delay)
    @Published private(set) var filteredObjects: [D]
    @Published var searchText: String = ""

	// MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()

    init() {
		// if search is empty -> showing all points
        self.filteredObjects = Array(travelPoints)
        setupBindings()
    }

	// MARK: - Private Methods
    private func setupBindings() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { [weak self] searchText -> [D] in
                guard let self else { return [] }
                return filterObjects(for: searchText)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.filteredObjects, on: self)
            .store(in: &cancellables)
    }

    private func filterObjects(for searchText: String) -> [D] {
        let clearText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if clearText.isEmpty {
            return Array(self.travelPoints)
        } else {
            return self.travelPoints.filter {
                $0.name.lowercased().contains(clearText)
            }
        }
    }
}
