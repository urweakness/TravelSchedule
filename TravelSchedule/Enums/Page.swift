import SwiftUI
enum Page: Identifiable, Hashable {
    case none
    case tabView
    case main
    case settings
    case townChoose
    case stationChoose
    case userAgreement
    case carriersChoose
    case filtration
    case carrierInfo
    
    case routing
    case storiesPreview
    
    var id: Self { self }
	
	var navigationTitle: String {
		switch self {
		case .townChoose:
			.init(localized: .townChoose)
		case .stationChoose:
			.init(localized: .stationChoose)
		case .userAgreement:
			.init(localized: .userAgreement)
		case .carrierInfo:
			.init(localized: .carrierInfo)
		default:
			""
		}
	}
	
	var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode {
		switch self {
		case .townChoose, .stationChoose, .userAgreement, .carrierInfo:
			.inline
		default:
			.large
		}
	}
}
