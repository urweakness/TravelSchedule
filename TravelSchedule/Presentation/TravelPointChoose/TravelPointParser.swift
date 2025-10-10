final class TravelPointParser {
	func parseTowns(countries: [Components.Schemas.Country]?) -> [Town] {
		countries?
			.filter { $0.title == "Россия" }
			.flatMap { $0.regions ?? [] }
			.flatMap { $0.settlements ?? [] }
			.compactMap {
				Town(name: $0.title, code: $0.codes?.yandex_code)
			} ?? []
	}
	
	func parseStations(
		countries: [Components.Schemas.Country]?,
		targetTownName: String?
	) -> [Station] {
		countries?
			.flatMap { $0.regions ?? [] }
			.flatMap { $0.settlements ?? [] }
			.filter { $0.title == targetTownName }
			.flatMap { $0.stations ?? [] }
			.compactMap { station in
				guard let title = station.title else { return nil }
				return Station(
					name: title,
					esrCode: station.codes?.esr_code,
					yandexCode: station.codes?.yandex_code
				)
			} ?? []
	}
}
