import SwiftUI

struct CarriersListView: View {
    
    // --- private states ---
	@State private var viewModel: CarrierListViewModel
    
	// --- DI ---
	let loadingState: LoadingState
	let push: (Page) -> Void
	let pop: () -> Void
    
    // --- private constants ---
    private let overscrollBottomPadding = CarrierListOverscroll().bottomPadding
	
	// --- internal init ---
	init(
		manager: TravelRoutingManager,
		dataCoordinator: DataCoordinator,
		push: @escaping (Page) -> Void,
		pop: @escaping () -> Void
	) {
		self.loadingState = dataCoordinator.loader.loadingState
		self.push = push
		self.pop = pop

		_viewModel = State(
			initialValue: .init(
				manager: manager,
				dataCoordinator: dataCoordinator,
				pushCarrier: {
					push(.carrierInfo)
				}
			)
		)
	}
    
    // --- body ---
    var body: some View {
        ZStack {
            Color.travelWhite
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                titleView
				
				ZStack {
					carriersListView
						.opacity(loadingState == .idle ? 1 : 0)
					
					ZStack {
						Spacer()
						ProgressView()
							.progressViewStyle(.circular)
							.scaleEffect(2)
							.transition(.blurReplace)
							.transition(.scale)
							.frame(maxWidth: .infinity)
						Spacer()
					}
					.opacity(loadingState == .fetching ? 1 : 0)
				}
            }
            .padding(.horizontal, 16)
			.customNavigationBackButton(pop: pop)
            .navigationBarBackButtonHidden()
            
            VStack {
                Spacer()
                nextButtonView
                    .padding(.bottom)
            }
        }
		.animation(.default, value: loadingState)
		.onChange(of: viewModel.manager.filter) {
			viewModel.updateCarriers()
		}
        .task {
			await loadCarriers()
        }
    }
    
    // --- private views ---
	private var carriersListView: some View {
		List(
			Array(viewModel.filteredCarriers.enumerated()),
			id: \.element.id
		) { index, carrier in
			CarrierListCellView(carrier: carrier)
				.customListCellMods()
				.onTapGesture {
					viewModel.didTap(carrier)
				}
			// --- overscroll :) ---
			if index == viewModel.filteredCarriers.count - 1 {
				Color.clear
					.customListCellMods()
					.frame(height: overscrollBottomPadding)
			}
		}
		.listStyle(.plain)
		.scrollContentBackground(.hidden)
		.padding(.horizontal, -16)
		.scrollBounceBehavior(.basedOnSize)
	}
    private var titleView: some View {
		Text(viewModel.title)
            .font(.bold24)
            .foregroundStyle(.travelBlack)
			.truncationMode(.head)
    }
    
    private var nextButtonView: some View {
        Button(action: {
			push(.filtration)
        }) {
            Text(.checkTime)
        }
        .buttonStyle(
            WideButtonStyle()
        )
		.disabled(loadingState != .idle)
    }
    
    // --- private methods ---
    private func loadCarriers() async {
		guard
			let response = await viewModel.fetchScheduleBetweenStations()
		else {
			print("\n\(#function) No response from API\n")
			return
		}
		
		viewModel.parseResponse(response)
		viewModel.updateCarriers()
    }
}


// MARK: - View Extensions
// --- fileprivate list cell modifiers ---
fileprivate extension View {
	func customListCellMods() -> some View {
		self
			.listRowBackground(Color.clear)
			.listRowSeparator(.hidden)
			.listSectionSeparator(.hidden)
	}
}
