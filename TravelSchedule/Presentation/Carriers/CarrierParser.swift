import Foundation

@MainActor
final class CarrierParser {
	// --- parsing response ---
	func parseResponse(
		_ response: ScheduleBetweenStationsResponse,
		fetchThreadStations: @escaping @Sendable (String) async throws -> ThreadStationsResponse?
	) async -> [CarrierModel] {
		var result = [CarrierModel]()
		for segment in response.segments ?? [] {
			guard
				let carrier = await parseSegment(
					segment: segment,
					fetchThreadStations: fetchThreadStations
				)
			else { continue }
			
			result.append(carrier)
		}
		return result
	}
	
	private func parseSegment(
		segment: Components.Schemas.Segment?,
		fetchThreadStations: @escaping @Sendable (String) async throws -> ThreadStationsResponse?
	) async -> CarrierModel? {
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
		let transferInfo = (segment.has_transfers ?? false) ? "С пересадками" : nil
//		var transferInfo: String?
//		if
//			segment.has_transfers ?? false,
//			let code = segment.thread?.uid
//		{
//			do {
//				let threadStationReponse = try await fetchThreadStations(code)
//				transferInfo = parseThreadStationsResponse(threadStationReponse)
//			} catch {
//				print("Error parsing thread stations: \(error.localizedDescription)")
//			}
//		}
		
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
//	private func parseThreadStationsResponse(_ response: ThreadStationsResponse?) -> String? {
//		guard let response else { return nil }
//		guard let stops = response.stops else { return nil }
//		print(String(describing: stops))
//		if stops.count > 2 {
//			if
//				let transferPoint = stops.last,
//				let transferPointName = transferPoint.station?.title
//			{
//				return "С пересадкой в \(transferPointName)"
//			} else {
//				return nil
//			}
//		} else {
//			return "С пересадками"
//		}
//	}
}

// MARK: - CarrierParser Extensions

// --- private helpers ---
private extension CarrierParser {
	func declineHour(_ number: Int) -> String {
		let lastDigit = number % 10
		let lastTwoDigits = number % 100
		
		if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
			return "часов"
		}
		
		switch lastDigit {
		case 1:
			return "час"
		case 2, 3, 4:
			return "часа"
		default:
			return "часов"
		}
	}
	
	func declineMinute(_ number: Int) -> String {
		let lastDigit = number % 10
		let lastTwoDigits = number % 100
		
		if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
			return "минут"
		}
		
		switch lastDigit {
		case 1:
			return "минута"
		case 2, 3, 4:
			return "минуты"
		default:
			return "минут"
		}
	}
	
	func declineDays(_ number: Int) -> String {
		let lastDigit = number % 10
		let lastTwoDigits = number % 100
		
		if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
			return "дней"
		}
		
		switch lastDigit {
		case 1:
			return "день"
		case 2, 3, 4:
			return "дня"
		default:
			return "дней"
		}
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

		let daysString = days == 0 ? "" : "\(days) \(declineDays(days))"
		let hoursString = hours == 0 ? "" : "\(hours) \(declineHour(hours))"
		let minutesString = minutes == 0 ? "" : "\(minutes) \(declineMinute(minutes))"
		
		return [daysString, hoursString, minutesString]
			.filter { !$0.isEmpty }
			.joined(separator: "\n")
	}
}
