enum Town: TravelPoint {
    case moscow
    case saintPetersburg
    case sochi
    case gorniy
    case krasnodar
    case kazan
    case omsk
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .moscow:
            return "Москва"
        case .saintPetersburg:
            return "Санкт-Петербург"
        case .sochi:
            return "Сочи"
        case .gorniy:
            return "Горный Воздух"
        case .krasnodar:
            return "Краснодар"
        case .kazan:
            return "Казань"
        case .omsk:
            return "Омск"
        }
    }
    
    static var noContentTitleText: String {
        "Город не найден"
    }
    
    static var navigationTitleText: String {
        "Выбор города"
    }
}
