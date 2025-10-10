import Foundation
enum Filter {
    case departTime(DepartTimeFilter)
    case withTransfer(Bool)
    
    var description: String {
        switch self {
        case .departTime(let departTimeFilter):
            departTimeFilter.description
            
        case .withTransfer(let yes):
            yes ? 
			String(localized: .yes) :
			String(localized: .no)
        }
    }
    
    var title: String {
        switch self {
        case .departTime:
			.init(localized: .departTime)
        case .withTransfer:
			.init(localized: .showWithTransfers)
        }
    }
    
    enum DepartTimeFilter: Identifiable {
        case morning
        case day
        case evening
        case night
        
        var description: String {
            switch self {
            case .morning:
				.init(localized: .morning)
            case .day:
				.init(localized: .day)
            case .evening:
				.init(localized: .evening)
            case .night:
				.init(localized: .night)
            }
        }
		
		var time: (leftBound: String, rightBound: String) {
			switch self {
			case .morning:
				return (leftBound: "06:00", rightBound: "12:00")
			case .day:
				return (leftBound: "12:00", rightBound: "18:00")
			case .evening:
				return (leftBound: "18:00", rightBound: "00:00")
			case .night:
				return (leftBound: "00:00", rightBound: "06:00")
			}
		}
        
        var id: Self { self }
    }
}
