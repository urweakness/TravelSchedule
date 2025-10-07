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
		var transferInfo: String?
		if let code = segment.thread?.uid {
			do {
				let threadStationReponse = try await fetchThreadStations(code)
				transferInfo = parseThreadStationsResponse(threadStationReponse)
			} catch {
				print("Error parsing thread stations: \(error.localizedDescription)")
			}
		}
		
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
	private func parseThreadStationsResponse(_ response: ThreadStationsResponse?) -> String? {
		guard let response else { return nil }
		guard let stops = response.stops else { return nil }
		print(String(describing: stops))
		if stops.count > 2 {
			if
				let transferPoint = stops.last,
				let transferPointName = transferPoint.station?.title
			{
				return "С пересадкой в \(transferPointName)"
			} else {
				return nil
			}
		} else {
			return "С пересадками"
		}
	}
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

//[
//	TravelSchedule.Components.Schemas.Stop(arrival: nil, departure: Optional("2025-10-10 16:40:00"), stop_time: nil, duration: Optional(0), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Уфа, Южный Автовокзал"), short_title: nil, popular_title: nil, code: Optional("s9636684"), lat: nil, lng: nil, station_type: Optional("bus_station"), station_type_name: Optional("автовокзал"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 17:17:00"), departure: Optional("2025-10-10 17:18:00"), stop_time: Optional(60), duration: Optional(2280), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Шарипово, поворот"), short_title: nil, popular_title: nil, code: Optional("s9843690"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 17:55:00"), departure: Optional("2025-10-10 17:56:00"), stop_time: Optional(60), duration: Optional(4560), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Чирша-Тартыш"), short_title: Optional(""), popular_title: Optional(""), code: Optional("s9746460"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 18:13:00"), departure: Optional("2025-10-10 18:14:00"), stop_time: Optional(60), duration: Optional(5640), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Карача-Елга"), short_title: Optional(""), popular_title: Optional(""), code: Optional("s9746424"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 18:55:00"), departure: Optional("2025-10-10 19:00:00"), stop_time: Optional(300), duration: Optional(8400), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Дюртюли, автовокзал"), short_title: nil, popular_title: Optional("Автовокзал Дюртюли"), code: Optional("s9650896"), lat: nil, lng: nil, station_type: Optional("bus_station"), station_type_name: Optional("автовокзал"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 19:30:00"), departure: Optional("2025-10-10 19:31:00"), stop_time: Optional(60), duration: Optional(10260), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Асяново"), short_title: nil, popular_title: nil, code: Optional("s9746850"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 19:37:00"), departure: Optional("2025-10-10 19:38:00"), stop_time: Optional(60), duration: Optional(10680), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Лаяшты"), short_title: nil, popular_title: nil, code: Optional("s9746849"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 19:44:00"), departure: Optional("2025-10-10 19:45:00"), stop_time: Optional(60), duration: Optional(11100), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Ишкарово"), short_title: nil, popular_title: nil, code: Optional("s9746848"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 19:55:00"), departure: Optional("2025-10-10 20:00:00"), stop_time: Optional(300), duration: Optional(12000), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Верхнеяркеево, автостанция"), short_title: nil, popular_title: Optional("Автостанция Верхнеяркеево"), code: Optional("s9636678"), lat: nil, lng: nil, station_type: Optional(""), station_type_name: Optional("автостанция"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 20:20:00"), departure: Optional("2025-10-10 20:21:00"), stop_time: Optional(60), duration: Optional(13260), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Исаметово"), short_title: Optional(""), popular_title: Optional(""), code: Optional("s9747030"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 20:25:00"), departure: Optional("2025-10-10 20:26:00"), stop_time: Optional(60), duration: Optional(13560), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Зяйлево"), short_title: nil, popular_title: nil, code: Optional("s9747029"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 18:45:00"), departure: Optional("2025-10-10 18:46:00"), stop_time: Optional(60), duration: Optional(14760), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Старое Байсарово, трасса М7"), short_title: Optional(""), popular_title: Optional(""), code: Optional("s9842472"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 20:55:00"), departure: Optional("2025-10-10 20:56:00"), stop_time: Optional(60), duration: Optional(22560), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Набережные Челны, автовокзал"), short_title: nil, popular_title: nil, code: Optional("s9633007"), lat: nil, lng: nil, station_type: Optional("bus_station"), station_type_name: Optional("автовокзал"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-10 22:30:00"), departure: Optional("2025-10-10 22:31:00"), stop_time: Optional(60), duration: Optional(28260), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Мамадыш, объездная"), short_title: nil, popular_title: nil, code: Optional("s9875325"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 00:10:00"), departure: Optional("2025-10-11 00:11:00"), stop_time: Optional(60), duration: Optional(34260), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Вятские Поляны, автостанция"), short_title: nil, popular_title: nil, code: Optional("s9730598"), lat: nil, lng: nil, station_type: Optional(""), station_type_name: Optional("автостанция"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))),
//	TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 01:10:00"), departure: Optional("2025-10-11 01:11:00"), stop_time: Optional(60), duration: Optional(37860), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Казань-Малмыж, развилка"), short_title: nil, popular_title: nil, code: Optional("s9882978"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 02:54:00"), departure: Optional("2025-10-11 02:55:00"), stop_time: Optional(60), duration: Optional(44100), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Уржум"), short_title: Optional(""), popular_title: Optional(""), code: Optional("s9730596"), lat: nil, lng: nil, station_type: Optional(""), station_type_name: Optional("автостанция"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 04:03:00"), departure: Optional("2025-10-11 04:04:00"), stop_time: Optional(60), duration: Optional(48240), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Перевоз / Нолинск, поворот"), short_title: nil, popular_title: nil, code: Optional("s9730595"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 04:52:00"), departure: Optional("2025-10-11 04:53:00"), stop_time: Optional(60), duration: Optional(51180), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Суна"), short_title: nil, popular_title: nil, code: Optional("s9636939"), lat: nil, lng: nil, station_type: Optional(""), station_type_name: Optional("автостанция"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 05:34:00"), departure: Optional("2025-10-11 05:35:00"), stop_time: Optional(60), duration: Optional(53700), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Кумёны, поворот"), short_title: Optional(""), popular_title: Optional(""), code: Optional("s9636940"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 06:29:00"), departure: Optional("2025-10-11 06:30:00"), stop_time: Optional(60), duration: Optional(57000), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Нововятск"), short_title: nil, popular_title: nil, code: Optional("s9730594"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 06:58:00"), departure: Optional("2025-10-11 06:59:00"), stop_time: Optional(60), duration: Optional(58740), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Киров, автовокзал"), short_title: nil, popular_title: Optional("Автовокзал Киров"), code: Optional("s9636941"), lat: nil, lng: nil, station_type: Optional("bus_station"), station_type_name: Optional("автовокзал"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 10:01:00"), departure: Optional("2025-10-11 10:02:00"), stop_time: Optional(60), duration: Optional(69720), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Летка"), short_title: nil, popular_title: nil, code: Optional("s9632966"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 11:15:00"), departure: Optional("2025-10-11 11:16:00"), stop_time: Optional(60), duration: Optional(74160), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Ношуль, поворот"), short_title: nil, popular_title: nil, code: Optional("s9730589"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 11:42:00"), departure: Optional("2025-10-11 11:43:00"), stop_time: Optional(60), duration: Optional(75780), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Объячево, автостанция"), short_title: nil, popular_title: nil, code: Optional("s9633065"), lat: nil, lng: nil, station_type: Optional(""), station_type_name: Optional("автостанция"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 12:10:00"), departure: Optional("2025-10-11 12:11:00"), stop_time: Optional(60), duration: Optional(77460), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Вухтым"), short_title: Optional(""), popular_title: Optional(""), code: Optional("s9730588"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 12:41:00"), departure: Optional("2025-10-11 12:42:00"), stop_time: Optional(60), duration: Optional(79320), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Занулье, поворот"), short_title: nil, popular_title: nil, code: Optional("s9730587"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 13:20:00"), departure: Optional("2025-10-11 13:21:00"), stop_time: Optional(60), duration: Optional(81660), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Куратово, поворот / Слобода"), short_title: nil, popular_title: nil, code: Optional("s9878815"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 13:35:00"), departure: Optional("2025-10-11 13:36:00"), stop_time: Optional(60), duration: Optional(82560), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Чукаиб"), short_title: nil, popular_title: nil, code: Optional("s9730585"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 13:49:00"), departure: Optional("2025-10-11 13:50:00"), stop_time: Optional(60), duration: Optional(83400), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Визинга, поворот"), short_title: Optional(""), popular_title: Optional(""), code: Optional("s9632776"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 14:56:00"), departure: Optional("2025-10-11 14:57:00"), stop_time: Optional(60), duration: Optional(87420), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Лэзым"), short_title: Optional(""), popular_title: Optional(""), code: Optional("s9730584"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 15:23:00"), departure: Optional("2025-10-11 15:24:00"), stop_time: Optional(60), duration: Optional(89040), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Выльгорт"), short_title: nil, popular_title: nil, code: Optional("s9859308"), lat: nil, lng: nil, station_type: Optional("bus_stop"), station_type_name: Optional("автобусная остановка"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 15:34:00"), departure: Optional("2025-10-11 15:35:00"), stop_time: Optional(60), duration: Optional(89700), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Сыктывкар, автовокзал"), short_title: nil, popular_title: Optional("Автовокзал Сыктывкар"), code: Optional("s9600297"), lat: nil, lng: nil, station_type: Optional("bus_station"), station_type_name: Optional("автовокзал"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 18:13:00"), departure: Optional("2025-10-11 18:14:00"), stop_time: Optional(60), duration: Optional(99240), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Емва, автостанция"), short_title: nil, popular_title: nil, code: Optional("s9600298"), lat: nil, lng: nil, station_type: Optional(""), station_type_name: Optional("автостанция"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil))), TravelSchedule.Components.Schemas.Stop(arrival: Optional("2025-10-11 22:04:00"), departure: nil, stop_time: nil, duration: Optional(113040), terminal: nil, platform: Optional(""), station: Optional(TravelSchedule.Components.Schemas.Station(_type: Optional("station"), title: Optional("Ухта, автовокзал"), short_title: nil, popular_title: nil, code: Optional("s9600305"), lat: nil, lng: nil, station_type: Optional("bus_station"), station_type_name: Optional("автовокзал"), transport_type: Optional("bus"), distance: nil, majority: nil, direction: nil, codes: nil, type_choices: nil)))]
