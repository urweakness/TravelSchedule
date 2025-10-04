import SwiftUI

struct FiltrationView: View {
    
    // --- private states ---
    @State private var selectedDepartFilters: Set<Filter.DepartTimeFilter> = []
    @State private var selectedTransferFilter: Bool?
    
    // --- private constants ---
    private let departFilters: [Filter.DepartTimeFilter] = [.morning, .day, .evening, .night]
    private let transferFilters: [Bool] = [true, false]
    
	// --- DI ---
	@Bindable var manager: TravelRoutingManager
	let pop: () -> Void
    
	// --- private getters ---
    private var departTimeTitle: String {
        Filter.departTime(.day).title
    }
    
    private var transferTitle: String {
        Filter.withTransfer(true).title
    }
    
    // --- body ---
    var body: some View {
        ZStack {
            Color.travelWhite
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                makeTitleView(departTimeTitle)
                VStack(spacing: 0) {
                    ForEach(departFilters) { departTimeFilter in
                        makeFilterCell(
                            .departTime(departTimeFilter)
                        )
                    }
                }
                
                makeTitleView(transferTitle)
                VStack(spacing: 0){
                    ForEach(transferFilters, id: \.self) { isSelected in
                        makeFilterCell(
                            .withTransfer(isSelected)
                        )
                    }
                }
                Spacer()
            }
			.customNavigationBackButton(pop: pop)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            VStack {
                Spacer()
                confirmButton
            }
            .padding(.bottom, 24)
        }
    }
    
    // --- private views ---
    private var confirmButton: some View {
        Button(action: confirmAction) {
            Text("Применить")
        }
        .buttonStyle(
            WideButtonStyle()
        )
    }
    
    private func makeFilterCell(_ filter: Filter) -> some View {
        @State var isSelected = isSelected(filter)
        
        return CheckBoxButtonView(
            isSelected: $isSelected,
            filter: filter,
            title: filter.description,
            action: {
                didTapFilterButton(filter, isSelected: isSelected)
            }
        )
    }
    
    private func makeTitleView(_ title: String) -> some View {
        Text(title)
            .font(.bold24)
            .foregroundStyle(.travelBlack)
    }
    
    // MARK: - Private Methods
    private func isSelected(_ filter: Filter) -> Bool {
        switch filter {
        case .departTime(let departTimeFilter):
            return selectedDepartFilters.contains(departTimeFilter)
        case .withTransfer(let bool):
            return bool == selectedTransferFilter
        }
    }
    
    private func didTapFilterButton(
        _ filter: Filter,
        isSelected: Bool
    ) {
        withAnimation(.spring(.bouncy(duration: 0.3))) {
            switch filter {
            case .departTime(let departTimeFilter):
                if isSelected {
                    selectedDepartFilters.remove(departTimeFilter)
                } else {
                    selectedDepartFilters.insert(departTimeFilter)
                }
            case .withTransfer(let bool):
                selectedTransferFilter = bool
            }
        }
    }
    
    private func confirmAction() {
        manager.filter = .init(
            departFilter: selectedDepartFilters,
            transferFilter: selectedTransferFilter
        )
		pop()
    }
}
