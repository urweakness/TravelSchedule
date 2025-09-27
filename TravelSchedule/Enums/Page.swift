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
			"Выбор города"
		case .stationChoose:
			"Выбор станции"
		case .userAgreement:
			"Пользовательское соглашение"
		case .carrierInfo:
			"Информация о перевозчике"
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
