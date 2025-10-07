struct Town: TravelPoint {
    var id: Self { self }
	let name: String
	let code: String
    
    static var noContentTitleText: String {
        "Город не найден"
    }
}
