import Foundation

@MainActor
final class CarrierParser {
	// --- parsing response ---
	func parseResponse(
		_ response: ScheduleBetweenStationsResponse
	) -> [CarrierModel] {
		(response.segments ?? []).compactMap(parseSegment)
	}
}

// MARK: - CarrierParser Extensions

// --- private subparsers ---
private extension CarrierParser {
	func parseSegment(
		segment: Components.Schemas.Segment?
	) -> CarrierModel? {
		// --- safe unwrap ---
		guard
			let segment,
			
			let startDateString = segment.start_date,
			let departureDate = date(from: startDateString),
			
			let carrier = segment.thread?.carrier,
			
			let code = carrier.code,
			let name = carrier.title,
			
			let departureTimeString = segment.departure,
			let arrivalTimeString = segment.arrival,
			
			let startTime = extractTimeFromTimeString(departureTimeString),
			let endTime = extractTimeFromTimeString(arrivalTimeString),
			
			let durationSecs = segment.duration
		else { return nil }
	
		let duration = convertSecondsToHours(durationSecs)
		
		// --- transfer info parse ---
		let transferInfo = parseThreadStationsResponse(segment.transfers)
		
		// --- row carrier model ---
		let carrierModel = CarrierModel(
			code: code,
			logoURLString: carrier.logo,
			name: name,
			transferInfo: transferInfo,
			departureDate: departureDate,
			startTime: startTime,
			endTime: endTime,
			duration: duration,
			email: carrier.phone,
			phone: carrier.email
	   )
		
		return carrierModel
	}
	
	// --- returns parsed transferInfo for CarrierModel ---
	func parseThreadStationsResponse(_ transfers: [Components.Schemas.Transfer]?) -> String? {
		guard
			let transfers,
			transfers.count > 0
		else { return nil }
		
		let pluralized = String(
			localized: transfers.count > 1 ? .transfersAt : .transfersAt
		)
		
		return pluralized + " " + transfers.compactMap(\.title).joined(separator: ", ")
	}
}

// --- private helpers ---
private extension CarrierParser {
	func pluralizeHour(_ number: Int) -> String {
		let lastTwoDigits = number % 100
		
		return .init(localized: .hours(lastTwoDigits))
	}
	
	func pluzalizeMinute(_ number: Int) -> String {
		let lastTwoDigits = number % 100
		
		return .init(localized: .minutes(lastTwoDigits))
	}
	
	func pluralizeDays(_ number: Int) -> String {
		let lastTwoDigits = number % 100
		
		return .init(localized: .days(lastTwoDigits))
	}
	
	func extractTimeFromTimeString(_ timeString: String) -> String? {
		let components = timeString.split(separator: ":")
		guard
			let hour = components[safe: 0],
			let minute = components[safe: 1]
		else { return nil }
		
		return "\(hour):\(minute)"
	}
	
	func date(from dateString: String) -> Date? {
		let inputFormatter = DateFormatter()
		inputFormatter.dateFormat = "yyyy-MM-dd"
		guard
			let date = inputFormatter.date(from: dateString)
		else {
			print("Bad Date provided (yyyy-MM-dd format expected) --> got: \(dateString)")
			return nil
		}
		
		return date
	}
	
	func convertSecondsToHours(_ totalSeconds: Int) -> String {
		let days = totalSeconds / 86_400
		let hours = (totalSeconds % 86_400) / 3600
		let minutes = (totalSeconds % 3600) / 60

		let daysString = days == 0 ? "" : pluralizeDays(days)
		let hoursString = hours == 0 ? "" : pluralizeHour(hours)
		let minutesString = minutes == 0 ? "" : pluzalizeMinute(minutes)
		
		return [daysString, hoursString, minutesString]
			.filter { !$0.isEmpty }
			.joined(separator: "\n")
	}
}
