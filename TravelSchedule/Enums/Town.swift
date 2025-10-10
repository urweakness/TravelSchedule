struct Town: TravelPoint {
    var id: Self { self }
	let name: String
	let code: String
    
    static var noContentTitleText: String {
		.init(localized: .noTownFound)
    }
	
	init?(name: String?, code: String?) {
		guard
			let name, let code
		else { return nil }
		self.name = name
		self.code = code
	}
}
