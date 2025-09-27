enum Station: TravelPoint {
    case kiyev
    case kursk
    case yaroslavl
    case belorus
    case savelov
    case lenin
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .kiyev:
            "Киевский вокзал"
        case .kursk:
            "Курский вокзал"
        case .yaroslavl:
            "Ярославский вокзал"
        case .belorus:
            "Белорусский вокзал"
        case .savelov:
            "Савеловский вокзал"
        case .lenin:
            "Ленинградский вокзал"
        }
    }
    
    static var noContentTitleText: String {
        "Станция не найдена"
    }
}
