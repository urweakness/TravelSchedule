import Foundation

struct CarrierModel: Identifiable {
	let id: UUID = UUID()
	let code: Int
	let logoURLString: String?
	let name: String
	let transferInfo: String?
	let departureDate: Date
	let startTime: String
	let endTime: String
	let duration: String
	let email: String?
	let phone: String?
	
	var departureDateString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "d MMMM"
		return formatter.string(from: departureDate)
	}
	
	static let mock: Self = .init(
		code: 0,
		logoURLString: nil,
		name: "",
		transferInfo: nil,
		departureDate: .now,
		startTime: "",
		endTime: "",
		duration: "",
		email: "",
		phone: ""
	)
}
