enum Page: Identifiable, Hashable {
    case none
    case main
    case townChoose
    case stationChoose
    case userAgreement
    case carriersChoose
    case filtration
    case carrierInfo
    
    var id: Self { self }
}
