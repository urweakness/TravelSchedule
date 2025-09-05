enum Filter {
    case departTime(DepartTimeFilter)
    case withTransfer(Bool)
    
    var description: String {
        switch self {
        case .departTime(let departTimeFilter):
            departTimeFilter.description
            
        case .withTransfer(let yes):
            yes ? "Да" : "Нет"
        }
    }
    
    var title: String {
        switch self {
        case .departTime:
            "Время отправления"
        case .withTransfer:
            "Показывать варианты с пересадками"
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
                "Утро 06:00 - 12:00"
            case .day:
                "День 12:00 - 18:00"
            case .evening:
                "Вечер 18:00 - 00:00"
            case .night:
                "Ночь 00:00 - 06:00"
            }
        }
        
        var id: Self { self }
    }
}
