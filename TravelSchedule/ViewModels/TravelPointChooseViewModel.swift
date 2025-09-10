import Combine
import SwiftUI

final class TravelPointChooseViewModel<D: TravelPoint>: ObservableObject {
    private let travelPoints = D.allCases
    
    init() {
        setupBindings()
    }
    
    @Published private(set) var filteredObjects = [D]()
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
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
            return (self.travelPoints as? [D]) ?? []
        } else {
            return self.travelPoints.filter {
                $0.name.lowercased().contains(clearText)
            }
        }
    }
}
