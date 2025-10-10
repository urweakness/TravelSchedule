struct Station: TravelPoint {
    var id: Self { self }
    let name: String
	let esrCode: String?
	let yandexCode: String?
    
    static var noContentTitleText: String {
		.init(localized: .noStationFound)
    }
}
