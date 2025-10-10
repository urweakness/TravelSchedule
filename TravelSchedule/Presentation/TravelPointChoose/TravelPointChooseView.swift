import SwiftUI

struct TravelPointChooseView<D: TravelPoint>: View {
	
    // --- private states ---
	@StateObject private var viewModel: TravelPointChooseViewModel<D>
    
	// --- DI ---
	let loadingState: LoadingState
	let pop: () -> Void
	let navigationTitle: String
	let navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode
	
	init(
		routingManager: TravelRoutingManager,
		appManager: AppManager,
		loadingState: LoadingState,
		push: @escaping (Page) -> Void,
		pop: @escaping () -> Void,
		popToRoot: @escaping () -> Void,
		navigationTitle: String,
		navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode
	) {
		self.loadingState = loadingState
		self.pop = pop
		self.navigationTitle = navigationTitle
		self.navigationTitleDisplayMode = navigationTitleDisplayMode
		
		_viewModel = StateObject(
			wrappedValue:
				TravelPointChooseViewModel(
					appManager: appManager,
					routingManager: routingManager,
					push: push,
					popToRoot: popToRoot
				)
		)
		
		
	}
    
    // --- body ---
    @ViewBuilder
    var body: some View {
        VStack(spacing: 16) {
            searchFieldView
            
			ZStack {
				Group {
					if viewModel.filteredObjects.isEmpty {
						emptyDestinationsView
							.transition(.opacity)
					} else {
						destinationsView
					}
				}
				.opacity(loadingState == .idle ? 1 : 0)
				
				Group {
					Spacer()
					ProgressView()
						.scaleEffect(2)
						.progressViewStyle(.circular)
						.transition(.blurReplace)
						.transition(.scale)
				}
				.opacity(loadingState == .fetching ? 1 : 0)
			}
            
            Spacer()
        }
        .padding(.horizontal, 16)
		.navigationTitle(navigationTitle)
		.navigationBarTitleDisplayMode(navigationTitleDisplayMode)
        .background(.travelWhite)
		.customNavigationBackButton(pop: pop)
        .animation(.bouncy, value: viewModel.filteredObjects)
		.ignoresSafeArea(edges: .bottom)
		.onChange(of: loadingState) { _, newValue in
			guard newValue == .idle else { return }
			viewModel.parseTravelPoints()
		}
		.animation(.default, value: loadingState)
    }
    
    // --- private subviews ---
    private var emptyDestinationsView: some View {
        GeometryReader {
            Text(D.noContentTitleText)
                .font(.bold24)
                .transition(.blurReplace)
                .frame(width: $0.size.width, height: $0.size.height)
        }
    }

    private var destinationsView: some View {
		List(viewModel.filteredObjects, id: \.id) { destination in
			TravelListCell(
				text: destination.name,
				buttonAction: {
					viewModel.didTapOnObject(destination: destination)
				}, rightView: {
					Image(systemName: "chevron.right")
						.font(.bold17)
				}
			)
			.listRowBackground(Color.clear)
			.listRowSeparator(.hidden)
			.listSectionSeparator(.hidden)
		}
		.scrollIndicators(.hidden)
		.listStyle(.plain)
		.scrollContentBackground(.hidden)
		.scrollDismissesKeyboard(.interactively)
		.padding(.horizontal, -16)
		.accessibilityIdentifier(
			AccessibilityIdentifier.travelPointList.rawValue
		)
    }
    
    private var searchFieldView: some View {
		TextField(
			String(localized: .enterTextToSearch),
			text: $viewModel.searchText
		)
		.textFieldStyle(SearchTextFieldStyle(text: $viewModel.searchText))
		.allowsHitTesting(loadingState == .idle)
    }
}
